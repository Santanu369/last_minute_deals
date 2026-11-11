import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../model/lan_model.dart';

class LanguageState extends Equatable {
  final Locale locale;
  final bool isLoading;
  final List<LanguageModel> languages;
  final String? error;

  const LanguageState({
    required this.locale,
    this.isLoading = false,
    this.languages = const [],
    this.error,
  });

  LanguageState copyWith({
    Locale? locale,
    bool? isLoading,
    List<LanguageModel>? languages,
    String? error,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
      languages: languages ?? this.languages,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        locale,
        isLoading,
        languages,
        error,
      ];
}