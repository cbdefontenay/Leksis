import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/data/state/create_vocab_state.dart';
import '../../l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class FolderPage extends ConsumerWidget {
  final Folder folder;

  const FolderPage({super.key, required this.folder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(vocabProvider(folder.id!));
    final vocabNotifier = ref.read(vocabProvider(folder.id!).notifier);
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> exportToExcel() async {
      final excel = Excel.createExcel();
      final sheet = excel["Sheet1"];

      sheet.appendRow([TextCellValue("Word"), TextCellValue("Translation")]);

      for (var word in words) {
        sheet.appendRow([
          TextCellValue(word.word),
          TextCellValue(word.translation),
        ]);
      }

      String sanitizedFolderName = folder.name
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

    Future<void> importFromExcel() async {
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

            await vocabNotifier.addWord(
              Word(folderId: folder.id!, word: word, translation: translation),
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

    void showUpdateDialog(Word word) {
      final wordController = TextEditingController(text: word.word);
      final translationController = TextEditingController(
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
                      vocabNotifier.updateWord(
                        word.copyWith(
                          word: wordController.text,
                          translation: translationController.text,
                        ),
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

    void showAddWordDialog() {
      final wordController = TextEditingController();
      final translationController = TextEditingController();

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
                          backgroundColor: colorScheme.error,
                        ),
                      );
                      return;
                    }

                    vocabNotifier.addWord(
                      Word(
                        folderId: folder.id!,
                        word: wordController.text,
                        translation: translationController.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              folder.name,
              style: GoogleFonts.philosopher(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
            Text(
              "${words.length} ${AppLocalizations.of(context)!.words}",
              style: GoogleFonts.firaSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ).copyWith(color: colorScheme.onPrimary),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'import') {
                importFromExcel();
              } else if (value == 'export') {
                exportToExcel();
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
            words.isEmpty
                ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.library_books_outlined,
                        size: 50,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.noWordsYet,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        AppLocalizations.of(context)!.addWordsPrompt,
                        style: GoogleFonts.firaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            word.isLearned ? Icons.star : Icons.star_border,
                            color: word.isLearned ? colorScheme.primary : null,
                          ),
                          onPressed:
                              () => vocabNotifier.toggleLearnStatus(word),
                        ),
                        title: Text(
                          word.word,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(word.translation),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'update') {
                              showUpdateDialog(word);
                            } else if (value == 'delete') {
                              vocabNotifier.deleteWord(word.id!);
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
          backgroundColor: colorScheme.secondary,
          onPressed: showAddWordDialog,
          child: Icon(Icons.add, color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}
