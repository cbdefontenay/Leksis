import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:leksis/views/widgets/empty_state_view.dart';
import 'package:leksis/data/state/create_vocab_state.dart';
import 'package:leksis/service/tts_service.dart';
import 'package:leksis/views/widgets/language_selection_dialog.dart';
import '../../l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:leksis/views/widgets/word_dialogs.dart';
import 'package:leksis/views/widgets/word_list_tile.dart';

class FolderPage extends ConsumerStatefulWidget {
  final Folder folder;

  const FolderPage({super.key, required this.folder});

  @override
  ConsumerState<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends ConsumerState<FolderPage> {
  late final TTSService _ttsService;
  late TTSLanguage _currentLanguage;
  final loc = AppLocalizations.of;

  @override
  void initState() {
    super.initState();
    // Convert the int ID to string
    _ttsService = TTSService(widget.folder.id!.toString());
    _currentLanguage = TTSLanguage.english;
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    try {
      await _ttsService.initialize();
      if (mounted) {
        setState(() {
          _currentLanguage = _ttsService.currentLanguage;
        });
      }
    } catch (e) {
      print('TTS Initialization error: $e');
    }
  }

  Future<void> _showLanguageSelection() async {
    try {
      final selectedLanguage = await showDialog<TTSLanguage>(
        context: context,
        builder: (context) =>
            LanguageSelectionDialog(currentLanguage: _currentLanguage),
      );

      if (selectedLanguage != null && mounted) {
        await _ttsService.setLanguage(selectedLanguage);
        setState(() {
          _currentLanguage = selectedLanguage;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc(context)!.pronounciationMessageSet(selectedLanguage.name),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc(context)!.errorChangingLanguage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _speakWord(String word) async {
    try {
      await _ttsService.speak(word);
    } catch (e) {
      String errorMessage = loc(context)!.unableSpeakWord;

      if (e.toString().contains('NO_TTS_ENGINE')) {
        errorMessage = loc(context)!.noTtsEngineFound;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 4),
            action: e.toString().contains('NO_TTS_ENGINE')
                ? SnackBarAction(
                    label: "Help",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(loc(context)!.ttsHelpTitle),
                          content: Text(loc(context)!.ttsHelpMessage),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      }

      if (!e.toString().contains('NO_TTS_ENGINE')) {
        // Try to reinitialize and speak again for other errors
        await _initializeTTS();
        try {
          await _ttsService.speak(word);
        } catch (e2) {
          print('Second attempt failed: $e2');
        }
      }
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(vocabProvider(widget.folder.id!));
    final vocabNotifier = ref.read(vocabProvider(widget.folder.id!).notifier);
    final colorScheme = Theme.of(context).colorScheme;

    String getSanitizedFolderName() {
      return widget.folder.name
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), '_')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    }

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

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          "${directory.path}/leksis_${getSanitizedFolderName()}.xlsx";
      final file = File(filePath)..writeAsBytesSync(excel.encode()!);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: AppLocalizations.of(context)!.hereMyVocab);
    }

    Future<void> exportToJson() async {
      final List<Map<String, dynamic>> jsonList = words
          .map((w) => {'word': w.word, 'translation': w.translation})
          .toList();

      final String jsonString = jsonEncode(jsonList);
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          "${directory.path}/leksis_${getSanitizedFolderName()}.json";
      final file = File(filePath)..writeAsStringSync(jsonString);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: AppLocalizations.of(context)!.hereMyVocab);
    }

    Future<void> exportToCsv() async {
      final StringBuffer buffer = StringBuffer();
      buffer.writeln("Word,Translation");
      for (var word in words) {
        String escape(String text) {
          if (text.contains(',') || text.contains('"') || text.contains('\n')) {
            return '"${text.replaceAll('"', '""')}"';
          }
          return text;
        }

        buffer.writeln("${escape(word.word)},${escape(word.translation)}");
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          "${directory.path}/leksis_${getSanitizedFolderName()}.csv";
      final file = File(filePath)..writeAsStringSync(buffer.toString());

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

    Future<void> importFromJsonOrCsv() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json', 'csv'],
          allowMultiple: false,
        );

        if (result == null || result.files.isEmpty) return;
        final file = result.files.first;
        if (file.path == null) return;

        final String content = await File(file.path!).readAsString();
        int importedCount = 0;

        if (file.extension == 'json') {
          final List<dynamic> jsonList = jsonDecode(content);
          for (var item in jsonList) {
            if (item is Map<String, dynamic>) {
              final word = item['word']?.toString().trim() ?? '';
              final translation = item['translation']?.toString().trim() ?? '';
              if (word.isNotEmpty && translation.isNotEmpty) {
                await vocabNotifier.addWord(
                  Word(
                    folderId: widget.folder.id!,
                    word: word,
                    translation: translation,
                  ),
                );
                importedCount++;
              }
            }
          }
        } else if (file.extension == 'csv') {
          final List<String> lines = content.split('\n');
          for (int i = 1; i < lines.length; i++) {
            final line = lines[i].trim();
            if (line.isEmpty) continue;

            // basic csv parsing
            List<String> parts = [];
            bool inQuotes = false;
            String currentPart = "";
            for (int j = 0; j < line.length; j++) {
              if (line[j] == '"') {
                inQuotes = !inQuotes;
              } else if (line[j] == ',' && !inQuotes) {
                parts.add(currentPart);
                currentPart = "";
              } else {
                currentPart += line[j];
              }
            }
            parts.add(currentPart);

            if (parts.length >= 2) {
              final word = parts[0].trim();
              final translation = parts.sublist(1).join(',').trim();
              if (word.isNotEmpty && translation.isNotEmpty) {
                await vocabNotifier.addWord(
                  Word(
                    folderId: widget.folder.id!,
                    word: word,
                    translation: translation,
                  ),
                );
                importedCount++;
              }
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.successImport} $importedCount ${AppLocalizations.of(context)!.words}',
            ),
          ),
        );
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

    void showFormatSelection(bool isExport) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.table_chart),
                  title: Text(AppLocalizations.of(context)!.formatExcel),
                  onTap: () {
                    Navigator.pop(context);
                    isExport ? exportToExcel() : importFromExcel();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.data_object),
                  title: Text(AppLocalizations.of(context)!.formatJson),
                  onTap: () {
                    Navigator.pop(context);
                    isExport ? exportToJson() : importFromJsonOrCsv();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt),
                  title: Text(AppLocalizations.of(context)!.formatCsv),
                  onTap: () {
                    Navigator.pop(context);
                    isExport ? exportToCsv() : importFromJsonOrCsv();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.folder.name,
              style: GoogleFonts.philosopher(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${words.length} ${AppLocalizations.of(context)!.words}",
                style: GoogleFonts.firaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate_rounded),
            onPressed: _showLanguageSelection,
            tooltip: AppLocalizations.of(context)!.changePronunciationLanguage,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings_rounded),
            onSelected: (value) {
              if (value == 'import') {
                showFormatSelection(false);
              } else if (value == 'export') {
                showFormatSelection(true);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    const Icon(Icons.download_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.importList),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.upload_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.exportList),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.primaryContainer.withOpacity(0.05),
            ],
          ),
        ),
        child: words.isEmpty
            ? EmptyStateView(
                icon: Icons.menu_book_rounded,
                title: AppLocalizations.of(context)!.noWordsYet,
                description: AppLocalizations.of(context)!.addWordsPrompt,
              ).animate().fadeIn()
            : ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 80),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return WordListTile(
                        word: word,
                        vocabNotifier: vocabNotifier,
                        colorScheme: colorScheme,
                        onSpeak: _speakWord,
                        onUpdate: (w) => WordDialogs.showUpdateDialog(
                          context,
                          w,
                          vocabNotifier,
                        ),
                        onDelete: (id) => vocabNotifier.deleteWord(id),
                      )
                      .animate()
                      .fadeIn(delay: (index * 30).ms)
                      .slideX(begin: 0.05);
                },
              ),
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          backgroundColor: colorScheme.secondary,
          onPressed: () => WordDialogs.showAddWordDialog(
            context,
            widget.folder.id!,
            vocabNotifier,
            colorScheme,
          ),
          child: Icon(Icons.add, color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}
