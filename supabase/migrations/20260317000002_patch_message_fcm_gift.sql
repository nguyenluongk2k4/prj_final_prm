-- Patch notify_message_fcm to handle gift message type
CREATE OR REPLACE FUNCTION public.notify_message_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_token TEXT;
  v_body TEXT;
  v_sender_name TEXT;
  v_gift_emoji TEXT;
  v_distance TEXT;
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

  IF NEW.message_type = 'gift' THEN
    -- content format: "emoji|distanceMeters"
    v_gift_emoji := split_part(COALESCE(NEW.content, '🎁|0'), '|', 1);
    v_distance   := split_part(COALESCE(NEW.content, '🎁|0'), '|', 2);
    v_body := v_sender_name || ' đang cách bạn ' || v_distance || 'm và ném ' || v_gift_emoji || ' cho bạn';
  ELSIF NEW.message_type = 'image' THEN
    v_body := v_sender_name || ' đã gửi cho bạn một ảnh';
  ELSIF NEW.message_type = 'file' THEN
    v_body := v_sender_name || ' đã gửi cho bạn một file';
  ELSE
    v_body := COALESCE(NEW.content, '');
  END IF;

  PERFORM public.send_fcm_notification(
    v_token,
    v_sender_name,
    v_body,
    jsonb_build_object(
      'type', NEW.message_type::text,
      'sender_id', NEW.sender_id::text,
      'receiver_id', NEW.receiver_id::text,
      'message_id', NEW.id::text
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
