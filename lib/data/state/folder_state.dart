import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';

class FolderNotifier extends StateNotifier<List<Folder>> {
  final DatabaseHelper dbHelper;

  FolderNotifier(this.dbHelper) : super([]) {
    loadFolders();
  }

  Future<void> loadFolders() async {
    final folders = await dbHelper.getFolders();
    state = folders;
  }

  Future<void> addFolder(String name) async {
    await dbHelper.insertFolder(Folder(name: name));
    await loadFolders();
  }

  Future<void> deleteFolder(int id) async {
    await dbHelper.deleteFolder(id);
    await loadFolders();
  }

  Future<void> updateFolder(Folder folder) async {
    await dbHelper.updateFolder(folder);
    await loadFolders();
  }

  Future<void> reorderFolders(List<Folder> newOrder) async {
    // Update sortOrder for all folders
    final updatedFolders =
        newOrder.asMap().entries.map((entry) {
          final index = entry.key;
          final folder = entry.value;
          return Folder(id: folder.id, name: folder.name, sortOrder: index);
        }).toList();

    await dbHelper.updateFolderOrder(updatedFolders);
    state = updatedFolders;
  }
}

// Provider for DatabaseHelper
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// Provider for FolderNotifier
final foldersProvider = StateNotifierProvider<FolderNotifier, List<Folder>>((
  ref,
) {
  final dbHelper = ref.read(databaseHelperProvider);
  return FolderNotifier(dbHelper);
});

// Provider for filtered folders
final filteredFoldersProvider = Provider.family<List<Folder>, String>((
  ref,
  searchQuery,
) {
  final folders = ref.watch(foldersProvider);
  if (searchQuery.isEmpty) return folders;

  return folders.where((folder) {
    return folder.name.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
});
