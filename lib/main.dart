import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leksis/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/views/widget_tree.dart';

void main() {
  runApp(const LeksisApp());
}

class LeksisApp extends StatefulWidget {
  const LeksisApp({super.key});

  @override
  State<LeksisApp> createState() => _LeksisAppState();
}

class _LeksisAppState extends State<LeksisApp> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setDefaultLocale();
  }

  // Function to set the default locale based on the device's locale
  void _setDefaultLocale() async {
    final deviceLocale = _getDeviceLocale();
    final supportedLocales = L10n.allLanguages;

    // Check if the device's locale is supported
    final isSupported = supportedLocales.any(
      (locale) => locale.languageCode == deviceLocale.languageCode,
    );

    setState(() {
      _locale =
          isSupported
              ? deviceLocale
              : const Locale('en'); // Fallback to 'en' if not supported
    });
  }

  // Function to get the device's locale using PlatformDispatcher
  Locale _getDeviceLocale() {
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final systemLocales = platformDispatcher.locales;

    // Use the first locale from the system locales list
    return systemLocales.isNotEmpty ? systemLocales.first : const Locale('en');
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      supportedLocales: L10n.allLanguages,
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: WidgetTree(onLocaleChange: _setLocale)),
    );
  }
}
