import 'dart:async';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/data/state/folder_state.dart';
import 'package:leksis/theme/app_styles.dart';
import 'package:leksis/views/widgets/cards/folder_card.dart';
import 'package:leksis/views/widgets/custom_search_bar.dart';
import 'package:leksis/views/widgets/dialogs/folder_dialogs.dart';
import 'package:leksis/views/widgets/empty_state_view.dart';
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
      if (mounted) setState(() {});
    });
  }

  void _reorderFolders(
    int oldIndex,
    int newIndex,
    List<Folder> filteredFolders,
    List<Folder> allFolders,
  ) async {
    final movedFolder = filteredFolders[oldIndex];
    final actualOldIndex = allFolders.indexWhere((f) => f.id == movedFolder.id);

    int actualNewIndex;
    if (newIndex >= filteredFolders.length) {
      actualNewIndex = allFolders.length - 1;
    } else if (newIndex == 0) {
      actualNewIndex = 0;
    } else {
      final referenceFolder =
          filteredFolders[newIndex > oldIndex ? newIndex : newIndex - 1];
      final referenceIndex = allFolders.indexWhere(
        (f) => f.id == referenceFolder.id,
      );
      actualNewIndex = newIndex > oldIndex
          ? referenceIndex
          : referenceIndex + 1;
    }

    if (actualOldIndex == actualNewIndex) return;

    final newFolders = [...allFolders];
    final item = newFolders.removeAt(actualOldIndex);
    newFolders.insert(actualNewIndex, item);

    ref.read(foldersProvider.notifier).reorderFolders(newFolders);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final folders = ref.watch(foldersProvider);
    final filteredFolders = ref.watch(
      filteredFoldersProvider(_searchController.text),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.appTitle,
          style: GoogleFonts.philosopher(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.pageGradient(context)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                controller: _searchController,
                hintText: loc.searchFolders,
                onClear: () => setState(() {}),
              ),
            ),
            Expanded(
              child: filteredFolders.isEmpty
                  ? EmptyStateView(
                          icon: Icons.folder_open_rounded,
                          title: _searchController.text.isEmpty
                              ? loc.noFolder
                              : loc.noResultsFound,
                          description: _searchController.text.isEmpty
                              ? loc.addWordsPrompt
                              : loc.searchNoResultsDescription,
                          action: _searchController.text.isEmpty
                              ? ElevatedButton.icon(
                                  onPressed: () =>
                                      FolderDialogs.showAddFolderDialog(
                                        context,
                                        (name) => ref
                                            .read(foldersProvider.notifier)
                                            .addFolder(name),
                                      ),
                                  icon: const Icon(Icons.add_rounded),
                                  label: Text(loc.createFolder),
                                )
                              : null,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .moveY(begin: 20, end: 0)
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredFolders.length,
                      onReorder: (old, newVal) => _reorderFolders(
                        old,
                        newVal,
                        filteredFolders,
                        folders,
                      ),
                      itemBuilder: (context, index) {
                        final folder = filteredFolders[index];
                        return FolderCard(
                              folder: folder,
                              renameLabel: loc.rename,
                              deleteLabel: loc.delete,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FolderPage(folder: folder),
                                ),
                              ),
                              onAction: (val) {
                                if (val == 'update') {
                                  FolderDialogs.showRenameFolderDialog(
                                    context,
                                    folder,
                                    (upd) => ref
                                        .read(foldersProvider.notifier)
                                        .updateFolder(upd),
                                  );
                                } else if (val == 'delete') {
                                  ref
                                      .read(foldersProvider.notifier)
                                      .deleteFolder(folder.id!);
                                }
                              },
                            )
                            .animate(key: Key('folder_${folder.id}'))
                            .fadeIn(delay: (index * 50).ms)
                            .slideX(begin: 0.1, duration: 400.ms);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton.extended(
          onPressed: () => FolderDialogs.showAddFolderDialog(
            context,
            (name) => ref.read(foldersProvider.notifier).addFolder(name),
          ),
          backgroundColor: colorScheme.secondary,
          icon: Icon(Icons.add_rounded, color: colorScheme.onSecondary),
          label: Text(
            loc.createFolder,
            style: TextStyle(color: colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
