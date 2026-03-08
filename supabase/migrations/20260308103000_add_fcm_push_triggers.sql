-- Enable pg_net for HTTP calls
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Store FCM token on profiles
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS fcm_token TEXT;

-- Store app settings (URL + secret) without ALTER DATABASE permission
CREATE TABLE IF NOT EXISTS public.app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- Helper to send FCM via Edge Function
CREATE OR REPLACE FUNCTION public.send_fcm_notification(
  p_token TEXT,
  p_title TEXT,
  p_body TEXT,
  p_data JSONB
) RETURNS VOID AS $$
DECLARE
  v_url TEXT;
  v_secret TEXT;
  v_anon_key TEXT;
BEGIN
  SELECT value INTO v_url
    FROM public.app_settings
   WHERE key = 'fcm_function_url';

  SELECT value INTO v_secret
    FROM public.app_settings
   WHERE key = 'fcm_webhook_secret';

  SELECT value INTO v_anon_key
    FROM public.app_settings
   WHERE key = 'supabase_anon_key';

  IF v_anon_key IS NULL OR v_anon_key = '' THEN
    RAISE NOTICE 'Supabase anon key not set';
    RETURN;
  END IF;
  IF v_url IS NULL OR v_url = '' THEN
    RAISE NOTICE 'FCM function URL not set';
    RETURN;
  END IF;

  PERFORM net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-fcm-secret', COALESCE(v_secret, ''),
      'authorization', 'Bearer ' || v_anon_key,
      'apikey', v_anon_key
    ),
    body := jsonb_build_object(
      'token', p_token,
      'title', p_title,
      'body', p_body,
      'data', COALESCE(p_data, '{}'::jsonb)
    )
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Notify on new message
CREATE OR REPLACE FUNCTION public.notify_message_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_token TEXT;
  v_body TEXT;
BEGIN
  SELECT fcm_token
    INTO v_token
    FROM public.profiles
   WHERE user_id = NEW.receiver_id;

  IF v_token IS NULL OR v_token = '' THEN
    RETURN NEW;
  END IF;

  v_body := CASE
    WHEN NEW.message_type = 'image' THEN 'sent you a photo'
    WHEN NEW.message_type = 'file' THEN 'sent you a file'
    ELSE COALESCE(NEW.content, '')
  END;

  PERFORM public.send_fcm_notification(
    v_token,
    'New message',
    v_body,
    jsonb_build_object(
      'type', 'message',
      'sender_id', NEW.sender_id::text,
      'receiver_id', NEW.receiver_id::text,
      'message_id', NEW.id::text
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_message_fcm ON public.messages;
CREATE TRIGGER trigger_notify_message_fcm
AFTER INSERT ON public.messages
FOR EACH ROW EXECUTE FUNCTION public.notify_message_fcm();

-- Notify on new match (send to both users)
CREATE OR REPLACE FUNCTION public.notify_match_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_token_1 TEXT;
  v_token_2 TEXT;
BEGIN
  SELECT fcm_token
    INTO v_token_1
    FROM public.profiles
   WHERE user_id = NEW.user1_id;

  SELECT fcm_token
    INTO v_token_2
    FROM public.profiles
   WHERE user_id = NEW.user2_id;

  IF v_token_1 IS NOT NULL AND v_token_1 <> '' THEN
    PERFORM public.send_fcm_notification(
      v_token_1,
      'New match',
      'You have a new match',
      jsonb_build_object(
        'type', 'match',
        'match_id', NEW.id::text,
        'other_user_id', NEW.user2_id::text
      )
    );
  END IF;

  IF v_token_2 IS NOT NULL AND v_token_2 <> '' THEN
    PERFORM public.send_fcm_notification(
      v_token_2,
      'New match',
      'You have a new match',
      jsonb_build_object(
        'type', 'match',
        'match_id', NEW.id::text,
        'other_user_id', NEW.user1_id::text
      )
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_match_fcm ON public.matches;
CREATE TRIGGER trigger_notify_match_fcm
AFTER INSERT ON public.matches
FOR EACH ROW EXECUTE FUNCTION public.notify_match_fcm();
