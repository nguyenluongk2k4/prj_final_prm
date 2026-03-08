import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../i18n/strings.g.dart';

class ConversationInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool hasText;
  final VoidCallback onSend;
  final VoidCallback onAttachmentTap;
  final VoidCallback onVoiceTap;
  final VoidCallback? onInputTap;

  const ConversationInputBar({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hasText,
    required this.onSend,
    required this.onAttachmentTap,
    required this.onVoiceTap,
    this.onInputTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final mq = MediaQuery.of(context);

    return Container(
      color: c.background,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: mq.padding.bottom + 12,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          color: c.backgroundSecondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: c.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onAttachmentTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Assets.icons.icAttachment.svg(
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(c.text70, BlendMode.srcIn),
                ),
              ),
            ),
            Expanded(
              child: AppTextField(
                controller: controller,
                focusNode: focusNode,
                hint: context.t.yourMessageHint,
                maxLines: 4,
                minLines: 1,
                embedded: true,
                onChanged: (_) {},
                onSubmitted: (_) => onSend(),
                onTap: onInputTap,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: hasText
                  ? GestureDetector(
                      key: const ValueKey('send'),
                      onTap: onSend,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Assets.icons.icSendMessage.image(
                            width: 18,
                            height: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      key: const ValueKey('voice'),
                      onTap: onVoiceTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Assets.icons.icMicrophone.svg(
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            c.text70,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
