import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class FolderPage extends StatefulWidget {
  final Folder folder;

  const FolderPage({super.key, required this.folder});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Word> words = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    final loadedWords = await dbHelper.getWords(widget.folder.id!);
    setState(() {
      words = loadedWords;
    });
  }

  Future<void> _exportToExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel["Sheet1"];

    sheet.appendRow([TextCellValue("Word"), TextCellValue("Translation")]);

    for (var word in words) {
      sheet.appendRow([
        TextCellValue(word.word),
        TextCellValue(word.translation),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/vocabulary_${widget.folder.name}.xlsx";
    final file = File(filePath)..writeAsBytesSync(excel.encode()!);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: "Here is my vocabulary list");
  }

  Future<void> _importFromExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var tableRows = excel.tables[table]?.rows;
        if (tableRows != null && tableRows.length > 1) {
          for (int i = 1; i < tableRows.length; i++) {
            var row = tableRows[i];
            var word = row[0]?.value.toString() ?? "";
            var translation = row[1]?.value.toString() ?? "";
            if (word.isNotEmpty && translation.isNotEmpty) {
              await dbHelper.insertWord(
                Word(
                  folderId: widget.folder.id!,
                  word: word,
                  translation: translation,
                ),
              );
            }
          }
        }
      }
      _loadWords();
    }
  }

  void _updateWord(int id, String newWord, String newTranslation) async {
    await dbHelper.updateWord(
      Word(
        id: id,
        folderId: widget.folder.id!,
        word: newWord,
        translation: newTranslation,
      ),
    );

    _loadWords();
  }

  void _showUpdateDialog(Word word) {
    final TextEditingController wordController = TextEditingController(
      text: word.word,
    );
    final TextEditingController translationController = TextEditingController(
      text: word.translation,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Update Word"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordController,
                  decoration: const InputDecoration(labelText: "Word"),
                ),
                TextField(
                  controller: translationController,
                  decoration: const InputDecoration(labelText: "Translation"),
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
                  if (wordController.text.isNotEmpty &&
                      translationController.text.isNotEmpty) {
                    _updateWord(
                      word.id!,
                      wordController.text,
                      translationController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  void _deleteWord(int id) async {
    await dbHelper.deleteWord(id);
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.folder.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "${words.length} ${AppLocalizations.of(context)!.words}",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'import') {
                _importFromExcel();
              } else if (value == 'export') {
                _exportToExcel();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'import',
                    child: Text(AppLocalizations.of(context)!.importList),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: Text(AppLocalizations.of(context)!.exportList),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  words[index].isLearned ? Icons.star : Icons.star_border,
                  color:
                      words[index].isLearned
                          ? Theme.of(context).colorScheme.primary
                          : null,
                ),
                onPressed: () async {
                  await dbHelper.toggleWordLearnStatus(words[index]);
                  _loadWords();
                },
              ),
              title: Text(
                words[index].word,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(words[index].translation),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'update') {
                    _showUpdateDialog(words[index]);
                  } else if (value == 'delete') {
                    _deleteWord(words[index].id!);
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          onPressed: _showAddWordDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddWordDialog() {
    final TextEditingController wordController = TextEditingController();
    final TextEditingController translationController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("New Word"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordController,
                  decoration: const InputDecoration(labelText: "Word"),
                ),
                TextField(
                  controller: translationController,
                  decoration: const InputDecoration(labelText: "Translation"),
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
                  if (wordController.text.isNotEmpty &&
                      translationController.text.isNotEmpty) {
                    _addWord(wordController.text, translationController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  void _addWord(String word, String translation) async {
    await dbHelper.insertWord(
      Word(folderId: widget.folder.id!, word: word, translation: translation),
    );
    _loadWords();
  }
}
