import 'dart:async';

import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';
import 'folder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Folder> folders = [];
  List<Folder> filteredFolders = [];
  bool isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadFolders();
    _searchController.addListener(_filterFolders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFolders() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredFolders =
            folders.where((folder) {
              return folder.name.toLowerCase().contains(query);
            }).toList();
      });
    });
  }

  void _loadFolders() async {
    setState(() {
      isLoading = true;
    });

    final loadedFolders = await dbHelper.getFolders();

    setState(() {
      folders = loadedFolders;
      filteredFolders = List.from(folders);
      isLoading = false;
    });
  }

  void _reorderFolders(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final Folder item = folders.removeAt(oldIndex);
    folders.insert(newIndex, item);

    await dbHelper.updateFolderOrder(folders);

    setState(() {});
  }

  void _addFolder(String name) async {
    await dbHelper.insertFolder(Folder(name: name));

    _loadFolders();
  }

  void _deleteFolder(int id) async {
    await dbHelper.deleteFolder(id);

    _loadFolders();
  }

  void _updateFolder(int id, String newName) async {
    await dbHelper.updateFolder(Folder(id: id, name: newName));

    _loadFolders();
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
                        _addFolder(folderName);
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
                    _updateFolder(folder.id!, controller.text);
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
          // Add the search bar at the top
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
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredFolders.isEmpty
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
                        onReorder: (oldIndex, newIndex) {
                          // Need to adjust indices since we're working with filtered list
                          final actualOldIndex = folders.indexWhere(
                            (f) => f.id == filteredFolders[oldIndex].id,
                          );
                          int actualNewIndex = folders.indexWhere(
                            (f) => f.id == filteredFolders[newIndex].id,
                          );
                          if (actualOldIndex < actualNewIndex) {
                            actualNewIndex--;
                          }
                          _reorderFolders(actualOldIndex, actualNewIndex);
                        },
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
                                            _deleteFolder(folder.id!);
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
