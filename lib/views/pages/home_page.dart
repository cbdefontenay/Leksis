import 'dart:async';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/data/state/folder_state.dart';
import '../../l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';
import 'folder_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {}); // Trigger rebuild to update filtered list
    });
  }

  void _reorderFolders(
    int oldIndex,
    int newIndex,
    List<Folder> filteredFolders,
    List<Folder> allFolders,
  ) async {
    // Get the folder being moved from the filtered list
    final movedFolder = filteredFolders[oldIndex];

    // Find its position in the full list
    final actualOldIndex = allFolders.indexWhere((f) => f.id == movedFolder.id);

    // Calculate new position in full list
    int actualNewIndex;
    if (newIndex >= filteredFolders.length) {
      // Moving to the end
      actualNewIndex = allFolders.length - 1;
    } else if (newIndex == 0) {
      // Moving to the beginning
      actualNewIndex = 0;
    } else {
      // Find the position relative to adjacent items in filtered list
      final referenceFolder =
          filteredFolders[newIndex > oldIndex ? newIndex : newIndex - 1];
      final referenceIndex = allFolders.indexWhere(
        (f) => f.id == referenceFolder.id,
      );
      actualNewIndex =
          newIndex > oldIndex ? referenceIndex : referenceIndex + 1;
    }

    // Adjust if moving to same position
    if (actualOldIndex == actualNewIndex) return;

    // Perform the reorder on the full list
    final newFolders = [...allFolders];
    final item = newFolders.removeAt(actualOldIndex);
    newFolders.insert(actualNewIndex, item);

    // Update state through provider
    ref.read(foldersProvider.notifier).reorderFolders(newFolders);
  }

  void _showAddFolderDialog() {
    final TextEditingController controller = TextEditingController();

    String? errorMessage;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.createFolder),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autocorrect: true,
                      autofocus: true,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.createFolderHint,
                        errorText: errorMessage,
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
                      String folderName = controller.text.trim();
                      if (folderName.isEmpty) {
                        setState(() {
                          errorMessage =
                              AppLocalizations.of(context)!.createFolderError;
                        });
                      } else {
                        ref
                            .read(foldersProvider.notifier)
                            .addFolder(folderName);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.saveButton),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showUpdateFolderDialog(Folder folder) {
    final TextEditingController controller = TextEditingController(
      text: folder.name,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.renameFolder),
            content: TextField(
              autofocus: true,
              autocorrect: true,
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.newFolderName,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    ref
                        .read(foldersProvider.notifier)
                        .updateFolder(
                          Folder(id: folder.id, name: controller.text),
                        );
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.updateButton),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch the folders list
    final folders = ref.watch(foldersProvider);
    // Get filtered folders based on search query
    final filteredFolders = ref.watch(
      filteredFoldersProvider(_searchController.text),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LEKSIS",
          style: GoogleFonts.philosopher(
            fontSize: 35,
            fontWeight: FontWeight.w800,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchFolders,
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                filled: true,
                fillColor: colorScheme.surface,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child:
                  filteredFolders.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 80,
                              color: colorScheme.onSurface,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Text(
                                _searchController.text.isEmpty
                                    ? AppLocalizations.of(context)!.noFolder
                                    : AppLocalizations.of(
                                      context,
                                    )!.noResultsFound,
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (_searchController.text.isEmpty) ...[
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _showAddFolderDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.secondary,
                                  foregroundColor: colorScheme.onSecondary,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.createFolder,
                                ),
                              ),
                            ],
                          ],
                        ),
                      )
                      : ReorderableListView.builder(
                        itemCount: filteredFolders.length,
                        onReorder:
                            (oldIndex, newIndex) => _reorderFolders(
                              oldIndex,
                              newIndex,
                              filteredFolders,
                              folders,
                            ),
                        itemBuilder: (context, index) {
                          final folder = filteredFolders[index];
                          return Padding(
                            key: Key('folder_${folder.id}'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: InkWell(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              FolderPage(folder: folder),
                                    ),
                                  ),
                              borderRadius: BorderRadius.circular(12),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: colorScheme.surfaceContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.folder_copy,
                                        color: colorScheme.primary,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          folder.name,
                                          style: textTheme.headlineSmall
                                              ?.copyWith(
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'update') {
                                            _showUpdateFolderDialog(folder);
                                          } else if (value == 'delete') {
                                            ref
                                                .read(foldersProvider.notifier)
                                                .deleteFolder(folder.id!);
                                          }
                                        },
                                        itemBuilder:
                                            (context) => [
                                              PopupMenuItem(
                                                value: 'update',
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.rename,
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'delete',
                                                child: Text(
                                                  AppLocalizations.of(
                                                    context,
                                                  )!.delete,
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
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          onPressed: _showAddFolderDialog,
          backgroundColor: colorScheme.secondary,
          child: Icon(Icons.add, color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}
