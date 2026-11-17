import 'package:ai_tour_guide/utils/app_route.dart';
import 'package:ai_tour_guide/utils/app_language.dart';
import 'package:ai_tour_guide/view/artifact_details_screen.dart';
import 'package:ai_tour_guide/view/artifact_data.dart';
import 'package:ai_tour_guide/view/artifact_list_screen.dart';
import 'package:ai_tour_guide/view/login_screen.dart';
import 'package:ai_tour_guide/view/scan_error_screen.dart';
import 'package:ai_tour_guide/view/scan_screen.dart';
import 'package:ai_tour_guide/view/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocale,
      builder: (context, locale, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoute.welcomeScreen,
        routes: {
          AppRoute.loginScreen: (context) => LoginScreen(),
          AppRoute.welcomeScreen: (context) => WelcomeScreen(),
          AppRoute.artifactsScreen: (context) =>
              ArtifactListScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.scanScreen: (context) =>
              ScanScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.scanErrorScreen: (context) =>
              ScanErrorScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.artifactDetailsScreen: (context) => ArtifactDetailsScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
        },
      ),
    );
  }
}

String? _routeId(BuildContext context) {
  final argument = ModalRoute.of(context)?.settings.arguments;
  return argument is String ? argument : null;
}
