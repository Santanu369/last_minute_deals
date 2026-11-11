import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lmd_app/app/app.dart';
import 'package:lmd_app/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No logs (tokens, response bodies, PII) in release builds
  if (kReleaseMode) debugPrint = (String? message, {int? wrapWidth}) {};

  const String env = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  // Notice the "assets/" prefix here
  await dotenv.load(fileName: 'assets/.env/.env.$env');
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('ar'),
        Locale('es'),
        Locale('fr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      saveLocale: true,
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
  // const MyApp());
}
