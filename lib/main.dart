import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leksis/l10n/l10n.dart';
import '../l10n/app_localizations.dart';
import 'package:leksis/theme/theme.dart';
import 'package:leksis/views/widget_tree.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadThemeMode();

  runApp(ProviderScope(child: LeksisApp()));
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
    if (_locale == null) {
      _setDefaultLocale();
    }
  }

  Future<void> _setDefaultLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString('selected_locale');
    Locale newLocale;

    if (savedLocaleCode != null) {
      final parts = savedLocaleCode.split('_');
      newLocale = parts.length > 1
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);
    } else {
      final deviceLocale = _getDeviceLocale();

      final supportedLocales = L10n.allLanguages;

      final isSupported = supportedLocales.any(
        (locale) => locale.languageCode == deviceLocale.languageCode,
      );

      newLocale = isSupported ? deviceLocale : const Locale('en');
    }

    setState(() {
      _locale = newLocale;
    });
  }

  void _setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();

    final localeCode = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await prefs.setString('selected_locale', localeCode);

    setState(() {
      _locale = locale;
    });
  }

  Locale _getDeviceLocale() {
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final systemLocales = platformDispatcher.locales;
    return systemLocales.isNotEmpty ? systemLocales.first : const Locale('en');
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
          home: Scaffold(
            body: WidgetTree(
              currentLocale: _locale ?? const Locale('en'),

              onLocaleChange: _setLocale,
            ),
          ),
        );
      },
    );
  }
}
