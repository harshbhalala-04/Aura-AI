import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _stt = SpeechToText();

  Future<bool> init() => _stt.initialize();

  bool get isAvailable => _stt.isAvailable;

  Future<String> listenOnce({int timeout = 5}) async {
    final completer = Completer<String>();
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          print("final string: ${result.recognizedWords}");
          completer.complete(result.recognizedWords);
        }
      },
      listenFor: Duration(seconds: timeout),
      pauseFor: const Duration(seconds: 4),
      localeId: 'en_US',
    );
    return completer.future.timeout(Duration(seconds: timeout + 3), onTimeout: () {
      _stt.stop();
      return '';
    });
  }

  void stop() => _stt.stop();
}
