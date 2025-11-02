import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controllers/tts_controller.dart';
import '../core/app_constant.dart';
import '../models/message.dart';
import 'loading_widget.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isTyping;

  ChatBubble({super.key, required this.message, this.isTyping = false});

  final ttsController = Get.find<TtsController>();

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor =
        isUser ? AppConstant.PRIMARY_COLOR : AppConstant.SURFACE_COLOR;

    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin:
            const EdgeInsets.symmetric(vertical: AppConstant.PADDING_SMALL / 2),
        padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppConstant.BORDER_RADIUS_LARGE),
            topRight: const Radius.circular(AppConstant.BORDER_RADIUS_LARGE),
            bottomLeft: isUser
                ? const Radius.circular(AppConstant.BORDER_RADIUS_LARGE)
                : const Radius.circular(4),
            bottomRight: isUser
                ? const Radius.circular(4)
                : const Radius.circular(AppConstant.BORDER_RADIUS_LARGE),
          ),
        ),
        child: isTyping
            ? const LoadingWidget()
            : _buildMessageContent(context, isUser),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          data: message.content,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.inter(
                color: AppConstant.TEXT_PRIMARY,
                fontSize: AppConstant.FONT_BODY),
            code: GoogleFonts.firaCode(
                backgroundColor: Colors.black.withOpacity(0.2),
                color: Colors.white,
                fontSize: AppConstant.FONT_BODY - 1),
            h1: GoogleFonts.outfit(
                color: AppConstant.TEXT_PRIMARY, fontWeight: FontWeight.bold),
            h2: GoogleFonts.outfit(
                color: AppConstant.TEXT_PRIMARY, fontWeight: FontWeight.bold),
            listBullet: GoogleFonts.inter(color: AppConstant.TEXT_PRIMARY),
          ),
        ),
        if (!isUser)
          Padding(
            padding: const EdgeInsets.only(top: AppConstant.PADDING_SMALL),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(Icons.copy, 'Copy', () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                }),
                Obx(() {
                  final isSpeaking = ttsController.isSpeaking(message.id);

                  return _iconButton(
                    icon: isSpeaking ? Icons.stop : Icons.volume_up,
                    onTap: () async {
                      if (isSpeaking) {
                        await ttsController.stop();
                      } else {
                        await ttsController.speak(message.id, message.content);
                      }
                    },
                  );
                }),
              ],
            ),
          )
      ],
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(icon, size: 18, color: AppConstant.TEXT_SECONDARY),
      onPressed: onTap,
      constraints: const BoxConstraints(),
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstant.PADDING_SMALL),
    );
  }

  Widget _buildActionButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 18, color: AppConstant.TEXT_SECONDARY),
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints(),
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstant.PADDING_SMALL),
    );
  }
}
