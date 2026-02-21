import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ClaudeService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-sonnet-4-5';
  static const String _apiVersion = '2023-06-01';

  final String apiKey;

  ClaudeService({required this.apiKey});

  Future<Map<String, dynamic>> _sendMessage({
    required String systemPrompt,
    required String userMessage,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': _apiVersion,
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 4096,
        'system': systemPrompt,
        'messages': [
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
        'API Hatasi (${response.statusCode}): ${error['error']?['message'] ?? response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final text = data['content'][0]['text'] as String;

    // Extract JSON from response (handle markdown code blocks)
    final jsonStr = _extractJson(text);
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  String _extractJson(String text) {
    // Try to extract JSON from markdown code block
    final codeBlockRegex = RegExp(r'```(?:json)?\s*([\s\S]*?)```');
    final match = codeBlockRegex.firstMatch(text);
    if (match != null) {
      return match.group(1)!.trim();
    }

    // Try to find JSON object directly
    final jsonStart = text.indexOf('{');
    final jsonEnd = text.lastIndexOf('}');
    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      return text.substring(jsonStart, jsonEnd + 1);
    }

    return text;
  }

  /// Suggest recipes based on available ingredients
  Future<List<Recipe>> suggestRecipes(List<String> ingredients) async {
    const systemPrompt = '''Sen bir Turk mutfagi ve dunya mutfagi konusunda
uzman bir asci ve tarif asistanisin. Kullanicinin evindeki malzemelerle
yapabilecegi tarifleri oneriyorsun.

ONEMLI: Yanitini SADECE asagidaki JSON formatinda ver, baska hicbir sey yazma:
{
  "recipes": [
    {
      "name": "Tarif Adi",
      "description": "Kisa aciklama",
      "ingredients": ["malzeme 1", "malzeme 2"],
      "steps": ["Adim 1", "Adim 2"],
      "availableIngredients": ["eldeki malzeme"],
      "missingIngredients": ["eksik malzeme"],
      "prepTimeMinutes": 30,
      "servings": 4
    }
  ]
}''';

    final userMessage =
        'Evimde su malzemeler var: ${ingredients.join(", ")}. '
        'Bu malzemelerle yapabilecegim 3 tarif oner. '
        'Mumkun oldugunca eldeki malzemeleri kullan.';

    final data = await _sendMessage(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
    );

    final recipesJson = data['recipes'] as List<dynamic>;
    return recipesJson
        .map((r) => Recipe.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Search for a specific recipe and check pantry
  Future<Recipe> searchRecipe({
    required String query,
    required List<String> pantryIngredients,
  }) async {
    const systemPrompt = '''Sen bir Turk mutfagi ve dunya mutfagi konusunda
uzman bir asci ve tarif asistanisin. Kullanicinin istedigi yemegi
yapabilmesi icin tarif veriyorsun. Ayrica kullanicinin evindeki
malzemeleri kontrol edip eksikleri belirliyorsun.

ONEMLI: Yanitini SADECE asagidaki JSON formatinda ver, baska hicbir sey yazma:
{
  "name": "Tarif Adi",
  "description": "Kisa aciklama",
  "ingredients": ["tum malzemeler"],
  "steps": ["Adim 1", "Adim 2"],
  "availableIngredients": ["kullanicinin evinde olan malzemeler"],
  "missingIngredients": ["kullanicinin evinde olmayan malzemeler"],
  "prepTimeMinutes": 30,
  "servings": 4
}''';

    final userMessage = 'Su yemegi yapmak istiyorum: $query\n\n'
        'Evimde su malzemeler var: ${pantryIngredients.join(", ")}.\n\n'
        'Tarifi ver ve evimde hangi malzemelerin oldugunu, '
        'hangilerinin eksik oldugunu belirt.';

    final data = await _sendMessage(
      systemPrompt: systemPrompt,
      userMessage: userMessage,
    );

    return Recipe.fromJson(data);
  }
}
