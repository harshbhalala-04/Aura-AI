abstract class AIProvider {
  Stream<String> generateStream({
    required String prompt,
    String? systemPrompt,
  });
}
