import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../ai/ai_manager.dart';
import '../models/message.dart';
import '../services/hive_service.dart';
import '../services/speech_service.dart';

class ChatController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool isListening = false.obs;
  final inputText = ''.obs;
  final speech = SpeechService();

  final messages = <Message>[].obs;
  final isLoading = false.obs;
  final isTyping = false.obs;

  final _uuid = const Uuid();

  Box<Message> get _messagesBox => HiveService.getMessages();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      inputText.value = textController.text;
    });
    _loadLocalMessages();
    speech.init();
  }

  Future<void> startListening() async {
    print("speech available: ${speech.isAvailable}");
    if (!speech.isAvailable) return;

    isListening.value = true;

    try {
      final text = await speech.listenOnce(timeout: 30);
      if (text.isNotEmpty) {
        textController.text = text;
        inputText.value = text;
      }
    } catch (_) {}

    isListening.value = false;
  }

  void stopListening() {
    speech.stop();
    isListening.value = false;
  }

  void toggleMic() {
    if (isListening.value) {
      stopListening();
    } else {
      print("starting to listen");
      startListening();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _loadLocalMessages() {
    isLoading.value = true;
    final data = _messagesBox.values.toList();
    messages.assignAll(data);
    isLoading.value = false;
    _scrollToBottom();
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    textController.clear();
    inputText.value = '';
    Get.focusScope?.unfocus();

    final userMessage = Message(
      id: _uuid.v4(),
      userId: "local_user",
      role: MessageRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    await _saveMessage(userMessage);
    isTyping.value = true;

    final aiMessageId = _uuid.v4();
    final aiMessage = Message(
      id: aiMessageId,
      userId: "local_user",
      role: MessageRole.model,
      content: "",
      createdAt: DateTime.now(),
    );

    await _saveMessage(aiMessage);

    String completed = "";

    try {
      // final stream = _geminiService.generateTextStream(prompt: text);
      final stream = AIManager.active.generateStream(prompt: text);
      final messagesBox = HiveService.getMessages();

      await for (final chunk in stream) {
        completed += chunk;

        // Update UI list (observable)
        final index = messages.indexWhere((m) => m.id == aiMessageId);
        if (index != -1) {
          final updated = messages[index].copyWith(content: completed);
          messages[index] = updated;

          final key = messagesBox.keyAt(index);
          await messagesBox.put(key, updated);
        }

        _scrollToBottom();
      }

      try {
        final index = messages.indexWhere((m) => m.id == aiMessageId);
        if (index != -1) {
          final key = messagesBox.keyAt(index);
          final finalUpdated = messages[index].copyWith(content: completed);
          await messagesBox.put(key, finalUpdated);
        }
      } catch (e) {
        print("error saving final AI message: $e");
      }
    } catch (e) {
      print("error: $e");
      await _saveMessage(Message(
        id: _uuid.v4(),
        userId: "local_user",
        role: MessageRole.model,
        content: "Sorry, something went wrong.",
        createdAt: DateTime.now(),
      ));
    }

    isTyping.value = false;
    _scrollToBottom();
  }

  Future<void> _saveMessage(Message msg) async {
    await _messagesBox.add(msg);
    messages.add(msg);
    _scrollToBottom();
  }
}
