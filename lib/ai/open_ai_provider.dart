import 'ai_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class OpenAIProvider implements AIProvider {
  final String apiKey;
  OpenAIProvider({required this.apiKey});

  @override
  Stream<String> generateStream({
    required String prompt,
    String? systemPrompt,
  }) async* {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final req = http.Request("POST", url)
      ..headers["Content-Type"] = "application/json"
      ..headers["Authorization"] = "Bearer $apiKey"
      ..body = jsonEncode({
        "model": "gpt-4o-mini",
        "stream": true,
        "messages": [
          if (systemPrompt != null) {"role": "system", "content": systemPrompt},
          {"role": "user", "content": prompt}
        ]
      });

    final res = await req.send();
    if (res.statusCode != 200) throw Exception("OpenAI stream failed");

    await for (final line in res.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (!line.startsWith("data: ")) continue;
      final jsonStr = line.substring(6).trim();
      if (jsonStr == "[DONE]") break;

      final data = jsonDecode(jsonStr);
      final text = data["choices"]?[0]?["delta"]?["content"];
      if (text != null) yield text;
    }
  }
}
