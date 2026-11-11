import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lmd_app/core/services/translation_service.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const TranslatedText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  Widget _text(String value) => Text(
    value,
    style: style,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
  );

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    // Fast path for English: render directly without async overhead
    if (currentLang == 'en') return _text(text);

    return FutureBuilder<String>(
      future: TranslationService().translate(text, currentLang),
      // Show English while loading
      builder: (context, snapshot) => _text(snapshot.data ?? text),
    );
  }
}