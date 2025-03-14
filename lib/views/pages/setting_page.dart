import 'package:flutter/material.dart';
import 'package:leksis/views/widgets/language_selector_widget.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.onLocaleChange});

  final Function(Locale) onLocaleChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Setting Page"),
        LanguageSelector(onLocaleChange: onLocaleChange),
      ],
    );
  }
}
