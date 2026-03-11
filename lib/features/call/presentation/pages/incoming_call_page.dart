import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prj_final_prm/core/theme/app_color_scheme.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/call_args.dart';

class IncomingCallPage extends StatefulWidget {
  final CallArgs args;

  const IncomingCallPage({super.key, required this.args});

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  double _sliderValue = 0;

  void _acceptCall() {
    final nextArgs = widget.args.copyWith(isIncoming: true);
    context.pushReplacement(AppRoutes.callActive, extra: nextArgs);
  }

  void _declineCall() {
    context.pop();
  }

  void _onSliderEnd(double value) {
    if (value >= 0.95) {
      _acceptCall();
    } else {
      setState(() => _sliderValue = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final remoteName = widget.args.remoteName;
    final avatarUrl = widget.args.remoteAvatarUrl?.trim() ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _BlurredBackdrop(avatarUrl: avatarUrl),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                _AvatarCircle(avatarUrl: avatarUrl, name: remoteName),
                const SizedBox(height: 16),
                Text(
                  remoteName,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Incoming call',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickAction(
                        icon: Icons.alarm,
                        label: 'Remind me',
                        onTap: () {},
                      ),
                      _QuickAction(
                        icon: Icons.message,
                        label: 'Message',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        color: const Color(0xFFE53935),
                        icon: Icons.call_end,
                        onTap: _declineCall,
                      ),
                      Expanded(
                        child: _SlideToAnswer(
                          value: _sliderValue,
                          onChanged: (value) => setState(() => _sliderValue = value),
                          onChangeEnd: _onSliderEnd,
                        ),
                      ),
                      _CircleButton(
                        color: const Color(0xFF2E7D32),
                        icon: Icons.call,
                        onTap: _acceptCall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredBackdrop extends StatelessWidget {
  final String avatarUrl;

  const _BlurredBackdrop({required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF101010),
          ],
        ),
      ),
      child: avatarUrl.isEmpty
          ? null
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.network(avatarUrl, fit: BoxFit.cover),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const _AvatarCircle({required this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((p) => p[0]).take(2).join()
        : '?';

    return CircleAvatar(
      radius: 48,
      backgroundColor: Colors.white10,
      foregroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
      child: Text(
        initials.toUpperCase(),
        style: AppTextStyles.h2.copyWith(color: Colors.white),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white70),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 32,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _SlideToAnswer extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const _SlideToAnswer({
    required this.value,
    required this.onChanged,
    required this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 44,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: const Color(0xFF2E7D32),
        inactiveTrackColor: Colors.white12,
        thumbColor: Colors.white,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}
