import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/call_token_service.dart';
import '../models/call_args.dart';

class InCallPage extends StatefulWidget {
  final CallArgs args;

  const InCallPage({super.key, required this.args});

  @override
  State<InCallPage> createState() => _InCallPageState();
}

class _InCallPageState extends State<InCallPage> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _isConnecting = true;
  bool _isMuted = false;
  bool _speakerOn = true;
  bool _videoEnabled = false;
  bool _frontCamera = true;
  String? _error;
  static const bool _useTempAgoraConfig = false;
  static const String _tempAppId = 'd4d165d27296449b980a873124010d74';
  static const String _tempChannel = 'aa';
  static const String _tempToken =
      '007eJxTYFDvl03K1UpVKpIX++5nHlV7Q/ZqW4H6+V3nHl94JaBb/kWBIcUkxdDMNMXI3MjSzMTEMsnSwiDRwtzY0MjEwNAgxdxku++GzIZARgZLnnnMjAwQCOIzMSQmMjAAAG6zHCQ=';

  @override
  void initState() {
    super.initState();
    _videoEnabled = widget.args.isVideo;
    print('[Agora] init call channel=${widget.args.channelId} user=${widget.args.localUserId}');
    _setupCall();
  }

  @override
  void dispose() {
    _leaveChannel();
    super.dispose();
  }

  Future<void> _setupCall() async {
    try {
      print('[Agora] setup start');
      final appId = _useTempAgoraConfig
          ? _tempAppId
          : dotenv.env['AGORA_APP_ID'];
      if (appId == null || appId.isEmpty) {
        print('[Agora] missing AGORA_APP_ID');
        setState(() => _error = 'AGORA_APP_ID is missing');
        return;
      }
      print('[Agora] appId length=${appId.length} head=${appId.substring(0, 4)} tail=${appId.substring(appId.length - 4)}');

      final channelId = _useTempAgoraConfig
          ? _tempChannel
          : widget.args.channelId;

      final permissionsOk = await _ensurePermissions();
      if (!permissionsOk) {
        print('[Agora] permissions denied');
        setState(() => _error = 'Permissions are required for calling');
        return;
      }

      print('[Agora] create engine');
      final engine = createAgoraRtcEngine();
      await engine.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
      print('[Agora] engine initialized');
      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (!mounted) return;
            print('[Agora] join success channel=${connection.channelId}');
            _applySpeakerphone();
            setState(() => _isConnecting = false);
          },
          onUserJoined: (connection, uid, elapsed) {
            if (!mounted) return;
            print('[Agora] remote joined uid=$uid');
            setState(() => _remoteUid = uid);
          },
          onUserOffline: (connection, uid, reason) {
            if (!mounted) return;
            print('[Agora] remote offline uid=$uid reason=$reason');
            setState(() => _remoteUid = null);
            _endCall();
          },
          onLeaveChannel: (connection, stats) {
            if (!mounted) return;
            print('[Agora] leave channel');
            setState(() => _remoteUid = null);
          },
          onError: (err, msg) {
            if (!mounted) return;
            final mapped = _mapAgoraError(err, msg);
            print('[Agora] error code=$err msg=$msg mapped=$mapped');
            setState(() => _error = mapped);
          },
        ),
      );

      try {
        print('[Agora] enable audio');
        await engine.enableAudio();
      } catch (err) {
        print('[Agora] enableAudio error: $err');
        setState(() => _error = err.toString());
        return;
      }


      if (_videoEnabled) {
        try {
          print('[Agora] enable video');
          await engine.enableVideo();
          await engine.startPreview();
        } catch (err) {
          print('[Agora] enableVideo/startPreview error: $err');
          setState(() => _error = err.toString());
          return;
        }
      }

      String token;
      if (_useTempAgoraConfig) {
        token = _tempToken;
        print('[Agora] using temp token');
      } else {
        final tokenService = CallTokenService(Supabase.instance.client);
        print('[Agora] fetch token');
        token = await tokenService.fetchToken(
          channelId: channelId,
          userId: widget.args.localUserId,
          isPublisher: true,
        );
        print('[Agora] token length=${token.length}');
      }

      print('[Agora] join channel (user account)');
      await engine.joinChannelWithUserAccount(
        token: token,
        channelId: channelId,
        userAccount: widget.args.localUserId,
        options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack: _videoEnabled,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      if (mounted) {
        print('[Agora] setup done');
        setState(() => _engine = engine);
      }
    } catch (err) {
      if (mounted) {
        print('[Agora] setup error: $err');
        setState(() => _error = err.toString());
      }
    }
  }

  String _mapAgoraError(ErrorCodeType code, String msg) {
    if (msg.trim().isNotEmpty) return msg;
    switch (code) {
      case ErrorCodeType.errInvalidAppId:
        return 'Agora error: invalid app id';
      case ErrorCodeType.errInvalidToken:
        return 'Agora error: invalid token';
      case ErrorCodeType.errTokenExpired:
        return 'Agora error: token expired';
      default:
        return 'Agora error: $code';
    }
  }

  Future<bool> _ensurePermissions() async {
    final mic = await Permission.microphone.request();
    if (!mic.isGranted) return false;
    if (_videoEnabled) {
      final cam = await Permission.camera.request();
      if (!cam.isGranted) return false;
    }
    return true;
  }

  Future<void> _leaveChannel() async {
    if (_engine == null) return;
    await _engine!.leaveChannel();
    await _engine!.stopPreview();
    await _engine!.release();
    _engine = null;
  }

  void _toggleMute() {
    if (_engine == null) return;
    setState(() => _isMuted = !_isMuted);
    _engine!.muteLocalAudioStream(_isMuted);
  }

  void _toggleSpeaker() {
    if (_engine == null) return;
    setState(() => _speakerOn = !_speakerOn);
    _engine!.setEnableSpeakerphone(_speakerOn);
  }

  Future<void> _applySpeakerphone() async {
    if (_engine == null) return;
    try {
      print('[Agora] apply speakerphone=${_speakerOn ? 'on' : 'off'}');
      await _engine!.setEnableSpeakerphone(_speakerOn);
    } catch (err) {
      print('[Agora] apply speakerphone error: $err');
    }
  }

  void _toggleVideo() {
    if (_engine == null) return;
    setState(() => _videoEnabled = !_videoEnabled);
    _engine!.enableLocalVideo(_videoEnabled);
    if (_videoEnabled) {
      _engine!.startPreview();
    } else {
      _engine!.stopPreview();
    }
  }

  void _switchCamera() {
    if (_engine == null || !_videoEnabled) return;
    setState(() => _frontCamera = !_frontCamera);
    _engine!.switchCamera();
  }

  void _endCall() {
    _leaveChannel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.args.remoteName;
    final avatarUrl = widget.args.remoteAvatarUrl?.trim() ?? '';
    final isVideo = widget.args.isVideo;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: isVideo ? _buildVideoView(name, avatarUrl) : _buildAudioView(name, avatarUrl),
            ),
            if (isVideo) Positioned(top: 16, right: 16, child: _buildLocalPreview()),
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: _buildStatus(name),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: _buildControls(),
            ),
            if (_error != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 120,
                child: _ErrorBanner(message: _error!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(String name) {
    final statusText = _isConnecting
        ? 'Connecting...'
        : (_remoteUid == null ? 'Calling...' : 'In call');

    return Column(
      children: [
        Text(
          name,
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          statusText,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildVideoView(String name, String avatarUrl) {
    if (_remoteUid == null || _engine == null) {
      return _buildAudioView(name, avatarUrl);
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: widget.args.channelId),
      ),
    );
  }

  Widget _buildLocalPreview() {
    if (_engine == null || !_videoEnabled) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 110,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine!,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioView(String name, String avatarUrl) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((p) => p[0]).take(2).join()
        : '?';

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white10,
              foregroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: Text(
                initials.toUpperCase(),
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    final isVideo = widget.args.isVideo;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: _isMuted ? Icons.mic_off : Icons.mic,
          label: _isMuted ? 'Unmute' : 'Mute',
          onTap: _toggleMute,
        ),
        const SizedBox(width: 16),
        _ActionButton(
          icon: _speakerOn ? Icons.volume_up : Icons.volume_off,
          label: _speakerOn ? 'Speaker' : 'Earpiece',
          onTap: _toggleSpeaker,
        ),
        if (isVideo) ...[
          const SizedBox(width: 16),
          _ActionButton(
            icon: _videoEnabled ? Icons.videocam : Icons.videocam_off,
            label: _videoEnabled ? 'Video' : 'Video off',
            onTap: _toggleVideo,
          ),
          const SizedBox(width: 16),
          _ActionButton(
            icon: Icons.switch_camera,
            label: _frontCamera ? 'Front' : 'Rear',
            onTap: _switchCamera,
          ),
        ],
        const SizedBox(width: 16),
        _ActionButton(
          icon: Icons.call_end,
          label: 'End',
          backgroundColor: const Color(0xFFE53935),
          onTap: _endCall,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkResponse(
          onTap: onTap,
          radius: 30,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: backgroundColor ?? Colors.white12,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
