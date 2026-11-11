import 'package:lmd_app/features/language/model/lan_model.dart';

/// Maps backend or server language identification codes to app locale codes.
const Map<String, String> localeCodeMap = {
  'en': 'en',
  'hi': 'hi',
  'mr': 'mr',
  'ar': 'ar',
  'es': 'es',
  'fr': 'fr',
  'en_US': 'en', // If your backend sends 'en_US', map it to your 'en' local JSON file
  'ar_SA': 'ar', // If your backend sends 'ar_SA', map it to your 'ar' local JSON file
  'es_ES': 'es',
  'fr_FR': 'fr',
  // Alternatively, if your backend uses simpler IDs or strings:
  '1': 'en',
  '2': 'ar',
};

/// Locales that have translation files bundled with the application.
const List<LanguageModel> supportedLanguages = [
  LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
  LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
  LanguageModel(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
  LanguageModel(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
  LanguageModel(code: 'es', name: 'Spanish', nativeName: 'Español'),
  LanguageModel(code: 'fr', name: 'French', nativeName: 'Français'),
];
