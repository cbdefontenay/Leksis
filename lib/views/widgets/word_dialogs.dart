import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:leksis/models/word_model.dart';
import 'package:leksis/data/state/create_vocab_state.dart';

class WordDialogs {
  static void showUpdateDialog(
    BuildContext context,
    Word word,
    VocabNotifier vocabNotifier,
  ) {
    final wordController = TextEditingController(text: word.word);
    final translationController = TextEditingController(text: word.translation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.updateWord),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.word,
              ),
            ),
            TextField(
              controller: translationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translation,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () {
              if (wordController.text.isNotEmpty &&
                  translationController.text.isNotEmpty) {
                vocabNotifier.updateWord(
                  word.copyWith(
                    word: wordController.text,
                    translation: translationController.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.updateWord),
          ),
        ],
      ),
    );
  }

  static void showAddWordDialog(
    BuildContext context,
    int folderId,
    VocabNotifier vocabNotifier,
    ColorScheme colorScheme,
  ) {
    final wordController = TextEditingController();
    final translationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.newWordName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.word,
              ),
            ),
            TextField(
              controller: translationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translation,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () {
              if (wordController.text.isEmpty ||
                  translationController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.fillFieldsError,
                    ),
                    backgroundColor: colorScheme.error,
                  ),
                );
                return;
              }

              vocabNotifier.addWord(
                Word(
                  folderId: folderId,
                  word: wordController.text,
                  translation: translationController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      ),
    );
  }
}
