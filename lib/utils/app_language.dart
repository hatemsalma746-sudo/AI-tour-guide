import 'package:flutter/material.dart';

final appLocale = ValueNotifier<Locale>(const Locale('en'));

bool isArabic(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ar';

String tourText(BuildContext context, String english, String arabic) =>
    isArabic(context) ? arabic : english;

void toggleAppLanguage() {
  appLocale.value = appLocale.value.languageCode == 'en'
      ? const Locale('ar')
      : const Locale('en');
}
