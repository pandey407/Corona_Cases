import 'package:covid/providers/data_changer.dart';
import 'package:covid/translator/language_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:covid/constants.dart';
import 'package:covid/providers/following_data.dart';
import 'package:covid/screens/index.dart';
import 'package:provider/provider.dart';
import 'package:covid/providers/theme_changer.dart';
import 'package:covid/translator/app_translations.dart';

void main() => runApp(CoronaVirusApp());

class CoronaVirusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FollowingData()),
        ChangeNotifierProvider(create: (_) => ThemeChanger()),
        ChangeNotifierProvider(create: (_) => LanguageChanger()),
        ChangeNotifierProvider(create: (_) => DataChanger()),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final language = Provider.of<LanguageChanger>(context);
    return MaterialApp(
      locale: language.isNepali ? Locale('hi', '') : Locale('en', ''),
      supportedLocales: [
        //List all of the app's supported locales here
        Locale('en', 'US'),
        Locale('hi', ''),
      ],
      localizationsDelegates: [
        //These delegates make sure that the localization data for the proper language is loaded
        AppLocalizations
            .delegate, //A class which loads the translations from JSON files
        GlobalMaterialLocalizations
            .delegate, //Buiilt-in localization of basic text for material widgets
        GlobalWidgetsLocalizations
            .delegate, //Buiilt-in localization for text direction LTR/RTL
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Returns a locale which will be used by the app
        for (var supportedLocale in supportedLocales) {
          // Check if the current device locale is supported
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      theme: theme.darkTheme ? kDarkTheme : kLightTheme,
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
