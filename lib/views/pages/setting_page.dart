import 'package:flutter/material.dart';
import 'package:leksis/data/notifiers.dart';
import 'package:leksis/views/widgets/language_selector_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (BuildContext context, ThemeMode themeMode, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Settings"), elevation: 0),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Settings Page",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                LanguageSelector(onLocaleChange: onLocaleChange),
                const SizedBox(height: 20),
                _buildThemeSelector(context, themeMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(BuildContext context, ThemeMode themeMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          themeMode == ThemeMode.system
              ? Icons.brightness_auto
              : themeMode == ThemeMode.light
              ? Icons.wb_sunny
              : Icons.nightlight_round,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text(
          "App Theme",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: PopupMenuButton<ThemeMode>(
          onSelected: (ThemeMode newThemeMode) {
            themeModeNotifier.value = newThemeMode;
            saveThemeMode(newThemeMode);
          },
          itemBuilder: (BuildContext context) {
            return ThemeMode.values.map((mode) {
              return PopupMenuItem(
                value: mode,
                child: Row(
                  children: [
                    Icon(
                      mode == ThemeMode.system
                          ? Icons.brightness_auto
                          : mode == ThemeMode.light
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      mode == ThemeMode.system
                          ? "System"
                          : mode == ThemeMode.light
                          ? "Light"
                          : "Dark",
                      style: TextStyle(
                        fontWeight:
                            themeMode == mode
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                    if (themeMode == mode) const Spacer(),
                    if (themeMode == mode) const Icon(Icons.check, size: 16),
                  ],
                ),
              );
            }).toList();
          },
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }
}
