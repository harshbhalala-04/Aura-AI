import 'package:aivo/core/app_constant.dart';
import 'package:hive/hive.dart';
import '../services/hive_service.dart';
import 'ai_provider.dart';
import 'claude_provider.dart';
import 'gemini_provider.dart';
import 'open_ai_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIManager {
  static Box get _settings => HiveService.getSettings();

  static AIProvider get active {
    final provider = _settings.get("model", defaultValue: "gemini");
    switch (provider) {
      case "openai":
        return OpenAIProvider(apiKey: dotenv.env[AppConstant.OPEN_AI_API_KEY] ?? "");
      case "claude":
        return ClaudeProvider(apiKey: dotenv.env[AppConstant.CLAUDE_API_KEY] ?? "");
      default:
        return GeminiProvider(apiKey: dotenv.env[AppConstant.GEMINI_API_KEY] ?? "");
    }
  }

  static void setProvider(String provider) {
    _settings.put("model", provider);
  }
}
