import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:leksis/models/word_model.dart';
import 'package:leksis/data/state/create_vocab_state.dart';

class WordListTile extends StatelessWidget {
  final Word word;
  final VocabNotifier vocabNotifier;
  final ColorScheme colorScheme;
  final Function(String) onSpeak;
  final Function(Word) onUpdate;
  final Function(int) onDelete;

  const WordListTile({
    super.key,
    required this.word,
    required this.vocabNotifier,
    required this.colorScheme,
    required this.onSpeak,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => onUpdate(word),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            leading: Material(
              color: colorScheme.primaryContainer.withOpacity(0.4),
              shape: const CircleBorder(),
              child: IconButton(
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: colorScheme.primary,
                  size: 24,
                ),
                onPressed: () => onSpeak(word.word),
                tooltip: AppLocalizations.of(context)!.pronounceWord,
              ),
            ),
            title: Text(
              word.word,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                word.translation,
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.2,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    word.isLearned
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: word.isLearned
                        ? Colors.amber[700]
                        : colorScheme.outlineVariant,
                    size: 26,
                  ),
                  onPressed: () => vocabNotifier.toggleLearnStatus(word),
                  tooltip: word.isLearned
                      ? "Mark as unlearned"
                      : "Mark as learned",
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onSelected: (value) {
                    if (value == 'update') {
                      onUpdate(word);
                    } else if (value == 'delete') {
                      if (word.id != null) {
                        onDelete(word.id!);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'update',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(AppLocalizations.of(context)!.updateWord),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_rounded,
                            size: 20,
                            color: colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
