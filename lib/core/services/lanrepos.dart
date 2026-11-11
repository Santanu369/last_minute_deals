import 'package:lmd_app/features/language/constant/app_languages.dart';
import 'package:lmd_app/features/language/model/lan_model.dart';

class LanguageRepository {
  Future<List<LanguageModel>> getLanguages() async {
    return supportedLanguages;
  }
}