import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leksis/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/theme/theme.dart';
import 'package:leksis/views/widget_tree.dart';
import 'package:leksis/data/notifiers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadThemeMode();

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

  void _setDefaultLocale() async {
    final deviceLocale = _getDeviceLocale();
    final supportedLocales = L10n.allLanguages;
    final isSupported = supportedLocales.any(
      (locale) => locale.languageCode == deviceLocale.languageCode,
    );

    setState(() {
      _locale = isSupported ? deviceLocale : const Locale('en');
    });
  }

  Locale _getDeviceLocale() {
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final systemLocales = platformDispatcher.locales;

    return systemLocales.isNotEmpty ? systemLocales.first : const Locale('en');
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leksis',
          theme: MaterialTheme(ThemeData.light().textTheme).light(),
          darkTheme: MaterialTheme(ThemeData.dark().textTheme).dark(),
          scrollBehavior: MaterialScrollBehavior(),
          themeMode: themeMode,
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
      },
    );
  }
}
