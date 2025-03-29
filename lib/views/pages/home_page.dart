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

  List<Folder> folders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() async {
    setState(() {
      isLoading = true;
    });

    final loadedFolders = await dbHelper.getFolders();

    setState(() {
      folders = loadedFolders;
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

      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : folders.isEmpty
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
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          AppLocalizations.of(context)!.noFolder,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _showAddFolderDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                        ),
                        child: Text(AppLocalizations.of(context)!.createFolder),
                      ),
                    ],
                  ),
                )
                : ReorderableListView.builder(
                  itemCount: folders.length,
                  onReorder: _reorderFolders,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
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
                                        FolderPage(folder: folders[index]),
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
                                    folders[index].name,
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'update') {
                                      _showUpdateFolderDialog(folders[index]);
                                    } else if (value == 'delete') {
                                      _deleteFolder(folders[index].id!);
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
