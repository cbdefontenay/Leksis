import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leksis/l10n/l10n.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  Locale _selectedLocale = const Locale('de');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('selected_locale') ?? 'de';
    setState(() {
      _selectedLocale = Locale(localeCode);
    });
    widget.onLocaleChange(_selectedLocale);
  }

  Future<void> _changeLanguage(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale', newLocale.languageCode);
    setState(() {
      _selectedLocale = newLocale;
    });
    widget.onLocaleChange(newLocale);
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'nl':
        return 'Nederlands';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _selectedLocale,
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          _changeLanguage(newLocale);
        }
      },
      items:
          L10n.allLanguages.map((locale) {
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Text(_getLanguageName(locale.languageCode)),
            );
          }).toList(),
    );
  }
}
