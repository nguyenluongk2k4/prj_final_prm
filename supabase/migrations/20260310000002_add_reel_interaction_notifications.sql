-- Notify reel author on likes and comments

CREATE OR REPLACE FUNCTION public.notify_reel_interaction_fcm()
RETURNS TRIGGER AS $$
DECLARE
  v_author_id UUID;
  v_token TEXT;
  v_title TEXT;
  v_body TEXT;
  v_type TEXT;
  v_actor_name TEXT;
BEGIN
  SELECT author_id
    INTO v_author_id
    FROM public.reels
   WHERE id = NEW.reel_id;

  IF v_author_id IS NULL OR v_author_id = NEW.user_id THEN
    RETURN NEW;
  END IF;

  SELECT fcm_token
    INTO v_token
    FROM public.profiles
   WHERE user_id = v_author_id;

  SELECT display_name
    INTO v_actor_name
    FROM public.profiles
   WHERE user_id = NEW.user_id;

  v_actor_name := COALESCE(NULLIF(v_actor_name, ''), 'Một người');

  IF v_token IS NULL OR v_token = '' THEN
    RETURN NEW;
  END IF;

  IF TG_TABLE_NAME = 'reel_likes' THEN
    v_title := 'Thích mới';
    v_body := v_actor_name || ' đã thích video của bạn';
    v_type := 'reel_like';
  ELSE
    v_title := 'Bình luận mới';
    v_body := v_actor_name || ' đã bình luận: ' || COALESCE(NEW.content, '');
    v_type := 'reel_comment';
  END IF;

  PERFORM public.send_fcm_notification(
    v_token,
    v_title,
    v_body,
    jsonb_build_object(
      'type', v_type,
      'reel_id', NEW.reel_id::text,
      'actor_id', NEW.user_id::text,
      'comment_id', CASE WHEN TG_TABLE_NAME = 'reel_comments' THEN NEW.id::text ELSE NULL END
    )
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_reel_like_fcm ON public.reel_likes;
CREATE TRIGGER trigger_notify_reel_like_fcm
AFTER INSERT ON public.reel_likes
FOR EACH ROW EXECUTE FUNCTION public.notify_reel_interaction_fcm();

DROP TRIGGER IF EXISTS trigger_notify_reel_comment_fcm ON public.reel_comments;
CREATE TRIGGER trigger_notify_reel_comment_fcm
AFTER INSERT ON public.reel_comments
FOR EACH ROW EXECUTE FUNCTION public.notify_reel_interaction_fcm();
