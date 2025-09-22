import 'package:flutter/material.dart';
import 'package:leksis/l10n/app_localizations.dart';
import 'package:leksis/service/tts_service.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final TTSLanguage currentLanguage;

  const LanguageSelectionDialog({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.selectPronounciationWord,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300, // Fixed height for the list
              width: 300, // Fixed width for the dialog
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: TTSLanguage.values.length,
                itemBuilder: (context, index) {
                  final language = TTSLanguage.values[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Radio<TTSLanguage>(
                        value: language,
                        groupValue: currentLanguage,
                        onChanged: (TTSLanguage? value) {
                          if (value != null) {
                            Navigator.of(context).pop(value);
                          }
                        },
                      ),
                      title: Text(language.name),
                      onTap: () {
                        Navigator.of(context).pop(language);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(loc.cancelButton),
            ),
          ],
        ),
      ),
    );
  }
}
