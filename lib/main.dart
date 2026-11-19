import 'package:ai_tour_guide/utils/app_route.dart';
import 'package:ai_tour_guide/utils/app_language.dart';
import 'package:ai_tour_guide/view/create_account.dart';
import 'package:ai_tour_guide/view/home_screen.dart';
import 'package:ai_tour_guide/view/artifact_details_screen.dart';
import 'package:ai_tour_guide/view/artifact_data.dart';
import 'package:ai_tour_guide/view/artifact_list_screen.dart';
import 'package:ai_tour_guide/view/artifact_location_screen.dart';
import 'package:ai_tour_guide/view/ask_bast_screen.dart';
import 'package:ai_tour_guide/view/related_artifacts_screen.dart';
import 'package:ai_tour_guide/view/ai_reconstruction_screen.dart';
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
        scrollBehavior: const _SmoothScrollBehavior(),
        // Keep the Navigator's exposed area dark during route transitions so
        // a white frame never flashes between the dark screens.
        theme: ThemeData(
          canvasColor: const Color(0xff111110),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xffc49b50),
            selectionColor: Color(0x66c49b50),
            selectionHandleColor: Color(0xffc49b50),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _SoftFadePageTransitionsBuilder(),
              TargetPlatform.iOS: _SoftFadePageTransitionsBuilder(),
              TargetPlatform.macOS: _SoftFadePageTransitionsBuilder(),
              TargetPlatform.windows: _SoftFadePageTransitionsBuilder(),
              TargetPlatform.linux: _SoftFadePageTransitionsBuilder(),
              TargetPlatform.fuchsia: _SoftFadePageTransitionsBuilder(),
            },
          ),
        ),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppRoute.welcomeScreen,
        routes: {
          AppRoute.loginScreen: (context) => LoginScreen(),
          AppRoute.welcomeScreen: (context) => WelcomeScreen(),
          AppRoute.createAccount: (context) => const CreateAccount(),
          AppRoute.homeScreen: (context) => const HomeScreen(),
          AppRoute.artifactsScreen: (context) =>
              ArtifactListScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.scanScreen: (context) =>
              ScanScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.scanErrorScreen: (context) =>
              ScanErrorScreen(museumId: _routeId(context) ?? mockMuseumId),
          AppRoute.artifactDetailsScreen: (context) => ArtifactDetailsScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
          AppRoute.relatedArtifactsScreen: (context) => RelatedArtifactsScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
          AppRoute.artifactLocationScreen: (context) => ArtifactLocationScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
          AppRoute.askBastScreen: (context) => AskBastScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
          AppRoute.aiReconstructionScreen: (context) => AiReconstructionScreen(
            artifact: artifactForId(ModalRoute.of(context)?.settings.arguments),
          ),
        },
      ),
    );
  }
}

class _SoftFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _SoftFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.012, 0),
      end: Offset.zero,
    ).animate(curvedAnimation);

    return FadeTransition(
      opacity: curvedAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }
}

class _SmoothScrollBehavior extends MaterialScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

String? _routeId(BuildContext context) {
  final argument = ModalRoute.of(context)?.settings.arguments;
  return argument is String ? argument : null;
}
