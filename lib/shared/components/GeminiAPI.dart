import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiApi{
  Gemini gemini = Gemini.instance;
  GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.9,
      maxOutputTokens: 256,
      topP: 0.9,
      topK: 20
  );

  Future<List<double>> embeddingGenerator(String txt) async {
    List<double> embeddings = [];
      await gemini.embedContent(
        txt,
      ).then((onValue) {
        embeddings = onValue!.toList().cast();
      });
      return embeddings;
  }

  Future<String> chatGenerator(String prompt, String resources) async {
    String response = '';
    await gemini.text(
        "Given these resources:"
        "$resources"
        "Answer the following prompt using only the given resources "
        "and provide the name of the reference at the end of the response. "
        "If there's no answer tell the user that his resources about doesn't have any answer"
        "and don't provide any reference. You can response to chatting prompts normally."
        "Don't use any markdown formatting in the response, "
        "keep just a plain text with numbers or bullets only if needed."
        "Prompt: $prompt",
        generationConfig: generationConfig
    ).then((onValue) {
      response = onValue?.output as String;
    });

    return response;
  }
}