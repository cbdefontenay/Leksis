import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  void _loadFolders() async {
    final loadedFolders = await dbHelper.getFolders();
    setState(() {
      folders = loadedFolders;
    });
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
                    child: const Text("Cancel"),
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
                    child: const Text("Add"),
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
            title: const Text("Rename Folder"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "New Folder Name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _updateFolder(folder.id!, controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
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
        title: Text("LEKSIS", style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: InkWell(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FolderPage(folder: folders[index]),
                    ),
                  ),
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: colorScheme.surface,
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
                          style: textTheme.headlineMedium?.copyWith(
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
                              const PopupMenuItem(
                                value: 'update',
                                child: Text('Rename'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFolderDialog,
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }
}
