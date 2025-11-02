import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsController extends GetxController {
  final FlutterTts _tts = FlutterTts();

  // Which message is currently speaking
  final RxString activeMessageId = "".obs;

  @override
  void onInit() {
    super.onInit();
    _tts.setLanguage('en-US');
    _tts.setSpeechRate(0.45);

    // Reset when TTS completes
    _tts.setCompletionHandler(() {
      activeMessageId.value = "";
    });
  }

  Future<void> speak(String messageId, String text) async {
    // If someone else is speaking → stop first
    if (activeMessageId.value.isNotEmpty && activeMessageId.value != messageId) {
      await _tts.stop();
    }

    activeMessageId.value = messageId;
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    activeMessageId.value = "";
  }

  bool isSpeaking(String messageId) => activeMessageId.value == messageId;
}
