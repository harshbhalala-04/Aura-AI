import 'ai_provider.dart';
import '../core/app_constant.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class GeminiProvider implements AIProvider {
  final String apiKey;
  GeminiProvider({required this.apiKey});

  @override
  Stream<String> generateStream({
    required String prompt,
    String? systemPrompt,
    String model = AppConstant.TEXT_MODEL,
    double temperature = AppConstant.TEMPERATURE,
    int maxTokens = AppConstant.MAX_TOKENS,
  }) async* {
    final url = Uri.parse(
        '${AppConstant.GEMINI_API_URL}$model:streamGenerateContent?alt=sse');

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'text': systemPrompt != null
                  ? '$systemPrompt\n\nUser: $prompt'
                  : prompt
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': temperature,
        'maxOutputTokens': maxTokens,
        'topP': AppConstant.TOP_P,
        'topK': AppConstant.TOP_K,
      },
    };

    try {
      final request = http.Request('POST', url);
      request.headers['Content-Type'] = 'application/json';
      request.headers['x-goog-api-key'] = apiKey;
      request.body = jsonEncode(requestBody);

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 60));

      if (streamedResponse.statusCode != 200) {
        throw Exception('Stream failed: ${streamedResponse.statusCode}');
      }

      await for (var chunk in streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (chunk.startsWith('data: ')) {
          final jsonStr = chunk.substring(6).trim();
          if (jsonStr.isEmpty || jsonStr == '[DONE]') continue;
          try {
            final data = jsonDecode(jsonStr);
            final text =
                data['candidates']?[0]?['content']?['parts']?[0]?['text'];
            if (text != null && text.isNotEmpty) {
              yield text;
            }
          } catch (e) {
            continue;
          }
        }
      }
    } on TimeoutException {
      throw Exception('Stream timed out. Please try again.');
    } catch (e) {
      throw Exception('Streaming error: $e');
    }
  }
}
