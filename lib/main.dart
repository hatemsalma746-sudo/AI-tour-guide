import 'package:ai_tour_guide/utils/app_route.dart';
import 'package:ai_tour_guide/view/login_screen.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("en"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoute.loginScreen,
      routes: {
        AppRoute.loginScreen : (context) => LoginScreen(),
      },
    );
  }
}

