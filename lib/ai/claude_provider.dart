import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ai_provider.dart';

class ClaudeProvider implements AIProvider {
  final String apiKey;

  ClaudeProvider({required this.apiKey});

  final _url = Uri.parse("https://api.anthropic.com/v1/messages");

  @override
  Stream<String> generateStream({
    required String prompt,
    String? systemPrompt,
    String model = "claude-sonnet-4-5",
    double temperature = 0.7,
    int maxTokens = 4096,
  }) async* {
    final request = http.Request("POST", _url);

    request.headers.addAll({
      "Content-Type": "application/json",
      "x-api-key": apiKey,
      "anthropic-version": "2023-06-01",
      "Accept": "text/event-stream",
    });

    request.body = jsonEncode({
      "model": model,
      "max_tokens": maxTokens,
      "temperature": temperature,
      "system": systemPrompt ?? "You are a helpful AI assistant.",
      "messages": [
        {
          "role": "user",
          "content": prompt,
        },
      ],
      "stream": true,
    });

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception("Claude Stream failed: ${response.statusCode}");
    }

    // Read line-by-line SSE
    await for (var line in response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (!line.startsWith("data:")) continue;

      final payload = line.substring(5).trim();
      if (payload.isEmpty || payload == "[DONE]") continue;

      try {
        final data = jsonDecode(payload);

        // Claude streaming event example:
        // {"type":"content_block_delta","delta":{"text":"Hello"}}
        if (data["type"] == "content_block_delta") {
          final text = data["delta"]?["text"];
          if (text != null && text.isNotEmpty) yield text;
        }
      } catch (_) {
        continue;
      }
    }
  }
}
