-- Map gifts table for Zenly-style gift throwing

CREATE TABLE IF NOT EXISTS public.map_gifts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  receiver_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  gift_type TEXT NOT NULL,
  sender_lat DOUBLE PRECISION NOT NULL,
  sender_lng DOUBLE PRECISION NOT NULL,
  distance_meters INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.map_gifts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can insert gifts they send"
  ON public.map_gifts FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can read gifts they sent or received"
  ON public.map_gifts FOR SELECT
  USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- FCM trigger: notify receiver when a gift is sent
CREATE OR REPLACE FUNCTION public.notify_map_gift_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_token TEXT;
  v_sender_name TEXT;
  v_body TEXT;
BEGIN
  SELECT fcm_token INTO v_token
    FROM public.profiles
   WHERE user_id = NEW.receiver_id;

  IF v_token IS NULL OR v_token = '' THEN
    RETURN NEW;
  END IF;

  SELECT COALESCE(display_name, 'Someone') INTO v_sender_name
    FROM public.profiles
   WHERE user_id = NEW.sender_id;

  v_body := v_sender_name || ' đang cách bạn ' || NEW.distance_meters || 'm và ném ' || NEW.gift_type || ' cho bạn';

  PERFORM public.send_fcm_notification(
    v_token,
    v_sender_name,
    v_body,
    jsonb_build_object(
      'type', 'map_gift',
      'sender_id', NEW.sender_id::text,
      'receiver_id', NEW.receiver_id::text,
      'gift_type', NEW.gift_type,
      'distance_meters', NEW.distance_meters::text,
      'gift_id', NEW.id::text
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_map_gift_fcm ON public.map_gifts;
CREATE TRIGGER trigger_notify_map_gift_fcm
AFTER INSERT ON public.map_gifts
FOR EACH ROW EXECUTE FUNCTION public.notify_map_gift_fcm();

ALTER PUBLICATION supabase_realtime ADD TABLE public.map_gifts;
