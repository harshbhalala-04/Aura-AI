import 'package:aivo/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../controllers/model_settings_controller.dart';
import '../core/app_constant.dart';
import '../controllers/chat_controller.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/loading_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstant.APP_NAME,
          style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppConstant.BACKGROUND_COLOR,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(() {
            final model =
                Get.find<ModelSettingsController>().selectedModel.value;
            return PopupMenuButton<String>(
              icon: Row(
                children: [
                  const Icon(Icons.smart_toy),
                  const SizedBox(width: 4),
                  Text(
                    model.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
              onSelected: (value) {
                Get.find<ModelSettingsController>().changeModel(value);
                SnackBarUtils.showSuccessMessage(
                    "Model Changed, Now using $value");
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: "gemini", child: Text("Gemini")),
                const PopupMenuItem(value: "openai", child: Text("OpenAI")),
                const PopupMenuItem(value: "claude", child: Text("Claude")),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.PRIMARY_COLOR,
                      ),
                      onPressed: Get.find<AuthController>().logout,
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: LoadingWidget());
              }

              if (controller.messages.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(AppConstant.PADDING_MEDIUM),
                itemCount: controller.messages.length +
                    (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length &&
                      controller.isTyping.value) {
                    return ChatBubble(
                      message: Message(
                        id: "typing",
                        userId: "",
                        role: MessageRole.model,
                        content: "...",
                        createdAt: null,
                      ),
                      isTyping: true,
                    );
                  }
                  if (controller.messages[index].content.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ChatBubble(
                    message: controller.messages[index],
                  );
                },
              );
            }),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hub_rounded,
                size: 80, color: AppConstant.TEXT_SECONDARY.withOpacity(0.5)),
            const SizedBox(height: AppConstant.PADDING_MEDIUM),
            Text(
              "Ask me anything!",
              style: GoogleFonts.inter(
                fontSize: AppConstant.FONT_TITLE,
                color: AppConstant.TEXT_SECONDARY,
              ),
            )
          ],
        ),
      );

  Widget _buildInputBar() => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppConstant.SURFACE_COLOR.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.textController,
                          style: GoogleFonts.inter(
                            color: AppConstant.TEXT_PRIMARY,
                          ),
                          decoration: InputDecoration(
                            hintText: "Ask Aura anything...",
                            hintStyle: GoogleFonts.inter(
                              color:
                                  AppConstant.TEXT_SECONDARY.withOpacity(0.7),
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => controller.sendMessage(),
                        ),
                      ),
                      Obx(() {
                        final isListening = controller.isListening.value;

                        return InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: controller.toggleMic,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isListening
                                  ? Colors.redAccent.withOpacity(0.8)
                                  : Colors.white10,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isListening ? Icons.mic : Icons.mic_none,
                              size: 22,
                              color: isListening
                                  ? Colors.white
                                  : AppConstant.TEXT_SECONDARY.withOpacity(0.9),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() {
                final empty = controller.inputText.value.trim().isEmpty;
                return AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: empty ? 0.9 : 1.05,
                  child: GestureDetector(
                    onTap: empty ? null : controller.sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: empty
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xff6C63FF), Color(0xff8D77FF)],
                              ),
                        color: empty ? Colors.white.withOpacity(0.08) : null,
                        boxShadow: empty
                            ? []
                            : [
                                BoxShadow(
                                  color:
                                      const Color(0xff6C63FF).withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 22,
                        color: empty ? Colors.grey : Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
}
