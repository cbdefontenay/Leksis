import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    setState(() {
      _isLoading = true;
    });

    final loadedWords = await dbHelper.getWords(widget.folder.id!);

    setState(() {
      words = loadedWords;
      _isLoading = false;
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

    String sanitizedFolderName = widget.folder.name
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/leksis_$sanitizedFolderName.xlsx";
    final file = File(filePath)..writeAsBytesSync(excel.encode()!);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: AppLocalizations.of(context)!.hereMyVocab);
  }

  Future<void> _importFromExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.path == null) return;
      final bytes = await File(file.path!).readAsBytes();

      if (bytes.length < 4 || !(bytes[0] == 0x50 && bytes[1] == 0x4B)) {
        throw Exception(AppLocalizations.of(context)!.notValidExcel);
      }

      try {
        var excel = Excel.decodeBytes(bytes);
        if (excel.tables.isEmpty) {
          throw Exception(AppLocalizations.of(context)!.successImport);
        }
        final sheet = excel.tables.values.first;
        var importedCount = 0;
        for (int i = 1; i < sheet.rows.length; i++) {
          var row = sheet.rows[i];
          if (row.length < 2) continue;

          final word = row[0]?.value?.toString().trim() ?? '';
          final translation = row[1]?.value?.toString().trim() ?? '';

          if (word.isEmpty || translation.isEmpty) continue;

          await dbHelper.insertWord(
            Word(
              folderId: widget.folder.id!,
              word: word,
              translation: translation,
            ),
          );
          importedCount++;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.successImport} $importedCount ${AppLocalizations.of(context)!.words}',
            ),
          ),
        );
      } catch (e) {
        throw Exception(
          '${AppLocalizations.of(context)!.excelProcessingError} ${e.toString()}',
        );
      }

      _loadWords();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.importFailMessage} ${e.toString()}',
          ),
        ),
      );
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
                    _updateWord(
                      word.id!,
                      wordController.text,
                      translationController.text,
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

  void _deleteWord(int id) async {
    await dbHelper.deleteWord(id);
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.folder.name,
              style: GoogleFonts.philosopher(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              "${words.length} ${AppLocalizations.of(context)!.words}",
              style: GoogleFonts.firaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ).copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 4, 16),
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
                : words.isEmpty
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.noWordsYet,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.addWordsPrompt,
                        style: GoogleFonts.firaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            words[index].isLearned
                                ? Icons.star
                                : Icons.star_border,
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
                                PopupMenuItem(
                                  value: 'update',
                                  child: Text(
                                    AppLocalizations.of(context)!.updateWord,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                  ),
                                ),
                              ],
                        ),
                      ),
                    );
                  },
                ),
      ),

      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: _showAddWordDialog,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
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
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    return;
                  }

                  _addWord(wordController.text, translationController.text);
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.add),
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
