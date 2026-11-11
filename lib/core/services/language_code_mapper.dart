class LanguageCodeMapper {
  static const Map<String, String> countryToLocale = {
    'eng': 'en',
    'hin': 'hi',
    'mar': 'mr',
    'spa': 'es',
    'fra': 'fr',
    'deu': 'de',
    'ita': 'it',
    'por': 'pt',
    'ara': 'ar',
    'jpn': 'ja',
    'kor': 'ko',
    'rus': 'ru',
    'chi': 'zh',
    'zho': 'zh',
  };

  static String toLocale(String code) {
    return countryToLocale[code] ?? code;
  }
}