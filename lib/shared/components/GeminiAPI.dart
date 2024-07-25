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
        // modelName: 'text-embedding-004',
        // generationConfig: generationConfig
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
            "and if there's no answer tell that there's no answer. "
            "Prompt: $prompt",
        modelName: 'gemini-1.0-pro',
        generationConfig: generationConfig
    ).then((onValue) {
      print(onValue);
      response = onValue?.output as String;
    });

    return response;
  }
}