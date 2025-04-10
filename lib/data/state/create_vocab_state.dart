import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leksis/data/state/folder_state.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/word_model.dart';

class VocabNotifier extends StateNotifier<List<Word>> {
  final DatabaseHelper dbHelper;
  final int folderId;

  VocabNotifier(this.dbHelper, this.folderId) : super([]) {
    loadWords();
  }

  Future<void> loadWords() async {
    final words = await dbHelper.getWords(folderId);
    state = words;
  }

  Future<void> addWord(Word word) async {
    await dbHelper.insertWord(word);
    await loadWords();
  }

  Future<void> updateWord(Word word) async {
    await dbHelper.updateWord(word);
    await loadWords();
  }

  Future<void> deleteWord(int id) async {
    await dbHelper.deleteWord(id);
    await loadWords();
  }

  Future<void> toggleLearnStatus(Word word) async {
    final updatedWord = word.copyWith(isLearned: !word.isLearned);
    await dbHelper.updateWord(updatedWord);
    await loadWords();
  }
}

// Provider for vocabulary words
final vocabProvider =
    StateNotifierProvider.family<VocabNotifier, List<Word>, int>((
      ref,
      folderId,
    ) {
      final dbHelper = ref.read(databaseHelperProvider);
      return VocabNotifier(dbHelper, folderId);
    });
