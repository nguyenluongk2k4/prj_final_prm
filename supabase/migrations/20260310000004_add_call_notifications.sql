-- Notify receiver on incoming call and add indexes for call sessions

CREATE INDEX IF NOT EXISTS idx_call_sessions_caller_created
  ON public.call_sessions (caller_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_call_sessions_receiver_created
  ON public.call_sessions (receiver_id, created_at DESC);

CREATE OR REPLACE FUNCTION public.notify_call_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_token TEXT;
  v_caller_name TEXT;
  v_title TEXT;
  v_body TEXT;
BEGIN
  SELECT fcm_token
    INTO v_token
    FROM public.profiles
   WHERE user_id = NEW.receiver_id;

  IF v_token IS NULL OR v_token = '' THEN
    RETURN NEW;
  END IF;

  SELECT display_name
    INTO v_caller_name
    FROM public.profiles
   WHERE user_id = NEW.caller_id;

  v_caller_name := COALESCE(NULLIF(v_caller_name, ''), 'Người dùng');
  v_title := 'Incoming call';
  v_body := v_caller_name || ' is calling you';

  PERFORM public.send_fcm_notification(
    v_token,
    v_title,
    v_body,
    jsonb_build_object(
      'type', 'call',
      'call_id', NEW.id::text,
      'channel', NEW.channel_name,
      'caller_id', NEW.caller_id::text,
      'receiver_id', NEW.receiver_id::text,
      'call_type', NEW.call_type::text
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_call_fcm ON public.call_sessions;
CREATE TRIGGER trigger_notify_call_fcm
AFTER INSERT ON public.call_sessions
FOR EACH ROW EXECUTE FUNCTION public.notify_call_fcm();
