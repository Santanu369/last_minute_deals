import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lmd_app/core/services/translation_service.dart';

class TranslatedMainCard extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  const TranslatedMainCard({super.key, required this.text, this.style, required this.maxLines, required this.overflow});

  

  @override
  Widget build(BuildContext context) {
    String  currentLang = context.locale.languageCode;
    if (currentLang == 'en') {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    return FutureBuilder<String>(
      future: TranslationService().translate(text, currentLang),
      builder: (context, snapshot) {
        final displayText = snapshot.data ?? text; // Show English while loading
        return Text(
          displayText,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}