import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';

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

  void _addWord(String word, String translation) async {
    await dbHelper.insertWord(
      Word(folderId: widget.folder.id!, word: word, translation: translation),
    );

    _loadWords();
  }

  void _deleteWord(int id) async {
    await dbHelper.deleteWord(id);

    _loadWords();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.name)),

      body: ListView.builder(
        itemCount: words.length,

        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

            elevation: 3,

            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  words[index].toBeLearned ? Icons.star : Icons.star_border,

                  color: words[index].toBeLearned ? Colors.amber : null,
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
}
