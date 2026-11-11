import 'package:translator/translator.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();

  // In-memory cache to avoid re-translating identical strings repeatedly
  final Map<String, String> _cache = {};

  /// Translates [text] to [targetLang] (e.g., 'hi', 'mr', 'ar')
  Future<String> translate(String text, String targetLang) async {
    // English or empty strings don't need translation
    if (text.trim().isEmpty || targetLang == 'en') {
      return text;
    }

    final cacheKey = '$targetLang:$text';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final translation = await _translator.translate(text, to: targetLang);
      _cache[cacheKey] = translation.text;
      return translation.text;
    } catch (e) {
      // Fallback to original English on network error or rate limit
      return text;
    }
  }
}