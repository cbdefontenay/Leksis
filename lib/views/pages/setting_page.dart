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

          body: SingleChildScrollView(
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
                  title: AppLocalizations.of(context)!.modus,
                  child: _buildThemeSelector(context, themeMode),
                ),
                const SizedBox(height: 16),
                _buildAboutButton(context),
                const SizedBox(height: 16), // Add extra space at bottom
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutButton(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: InkWell(
        onTap: () => _showAboutDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
                AppLocalizations.of(context)!.aboutTheApp,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.aboutTitle,
                        style: GoogleFonts.philosopher(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.aboutContent1,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.aboutContent2,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.aboutContent3,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
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
                              ? AppLocalizations.of(context)!.system
                              : mode == ThemeMode.light
                              ? AppLocalizations.of(context)!.light
                              : AppLocalizations.of(context)!.dark,
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
