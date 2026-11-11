import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const String _languageKey = 'selectedLanguage';

  LocaleCubit() : super(const Locale('en'));

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final code = prefs.getString(_languageKey);

    if (code != null) {
      emit(Locale(code));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _languageKey,
      languageCode,
    );

    emit(Locale(languageCode));
  }
}