import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:leksis/views/widgets/language_selector_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({
    super.key,

    required this.currentLocale,

    required this.onLocaleChange,
  });

  final Locale currentLocale;

  final Function(Locale) onLocaleChange;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,

      builder: (BuildContext context, ThemeMode themeMode, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.settings,

              style: GoogleFonts.philosopher(
                fontSize: 26,

                fontWeight: FontWeight.w600,
              ).copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            elevation: 4,
            shadowColor: Theme.of(context).colorScheme.scrim,
          ),

          body: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                _buildSettingItem(
                  context,
                  title: AppLocalizations.of(context)!.changeLanguage,
                  child: LanguageSelector(
                    currentLocale: currentLocale,
                    onLocaleChange: onLocaleChange,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  context,
                  title: AppLocalizations.of(context)!.changeMode,
                  child: _buildThemeSelector(context, themeMode),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.scrim,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeMode themeMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(8),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeMode>(
          value: themeMode,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.secondary,
          ),

          onChanged: (ThemeMode? newThemeMode) {
            if (newThemeMode != null) {
              themeModeNotifier.value = newThemeMode;

              saveThemeMode(newThemeMode);
            }
          },

          items:
              ThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          mode == ThemeMode.system
                              ? Icons.brightness_auto
                              : mode == ThemeMode.light
                              ? Icons.wb_sunny
                              : Icons.nightlight_round,

                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          mode == ThemeMode.system
                              ? "System"
                              : mode == ThemeMode.light
                              ? "Light"
                              : "Dark",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
