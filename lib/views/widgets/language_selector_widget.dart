import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leksis/l10n/l10n.dart';

class LanguageSelector extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChange,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();

    _selectedLocale = _findMatchingLocale(widget.currentLocale);

    _loadLocale();
  }

  Locale _findMatchingLocale(Locale locale) {
    final exactMatch = L10n.allLanguages.firstWhere(
      (l) =>
          l.languageCode == locale.languageCode &&
          (l.countryCode == null || l.countryCode == locale.countryCode),

      orElse: () => const Locale('en'),
    );

    if (exactMatch.languageCode == 'en' && locale.languageCode != 'en') {
      return L10n.allLanguages.firstWhere(
        (l) => l.languageCode == locale.languageCode,

        orElse: () => const Locale('en'),
      );
    }

    return exactMatch;
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('selected_locale');

    if (localeCode != null && localeCode != _selectedLocale.languageCode) {
      final newLocale = Locale(localeCode);

      if (mounted) {
        setState(() {
          _selectedLocale = _findMatchingLocale(newLocale);
        });

        widget.onLocaleChange(_selectedLocale);
      }
    }
  }

  Future<void> _changeLanguage(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selected_locale', newLocale.languageCode);

    if (mounted) {
      setState(() {
        _selectedLocale = newLocale;
      });

      widget.onLocaleChange(newLocale);
    }
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

      // case 'no':
      //   return 'Norsk';

      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,

        borderRadius: BorderRadius.circular(8),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: _selectedLocale,

          dropdownColor: Theme.of(context).colorScheme.onSecondary,

          icon: Icon(
            Icons.arrow_drop_down,

            color: Theme.of(context).colorScheme.secondary,
          ),

          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,

            fontSize: 16,
          ),

          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              _changeLanguage(newLocale);
            }
          },

          items:
              L10n.allLanguages.map((locale) {
                return DropdownMenuItem<Locale>(
                  value: locale,

                  child: Text(
                    _getLanguageName(locale.languageCode),

                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
