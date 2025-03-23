import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlashcardsPage extends StatefulWidget {
  final Folder folder;

  const FlashcardsPage({super.key, required this.folder});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage>
    with SingleTickerProviderStateMixin {
  List<Word> _words = [];
  int _currentIndex = 0;
  bool _showTranslationFirst = false;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    List<Word> words = await DatabaseHelper.instance.getWordsByFolder(
      widget.folder.id!,
    );
    setState(() {
      _words = words;
      _currentIndex = 0;
    });
  }

  Future<void> _updateLearnStatus(bool learned) async {
    if (_currentIndex < _words.length) {
      Word word = _words[_currentIndex];

      await DatabaseHelper.instance.updateWord(
        Word(
          id: word.id!,
          folderId: word.folderId,
          word: word.word,
          translation: word.translation,
          toBeLearned: learned,
        ),
      );

      Fluttertoast.showToast(
        msg: learned ? "Marked as Learned ⭐" : "Marked as Not Learned ❌",
        backgroundColor: learned ? Colors.green : Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _nextCard(bool learned) {
    if (_currentIndex < _words.length - 1) {
      _updateLearnStatus(learned);
      setState(() {
        _currentIndex++;
        _showFront = true;
      });
    } else {
      _updateLearnStatus(learned);
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showFront = true;
      });
    }
  }

  void _restartFlashcards() {
    setState(() {
      _currentIndex = 0;
      _showFront = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flashcards - ${widget.folder.name}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Translation First"),
                Switch(
                  value: _showTranslationFirst,
                  onChanged: (value) {
                    setState(() {
                      _showTranslationFirst = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _showFront = !_showFront),
                child:
                    _words.isEmpty
                        ? const Center(
                          child: Text("No words found in this folder."),
                        )
                        : _currentIndex < _words.length
                        ? Dismissible(
                          key: ValueKey(_words[_currentIndex].id),
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              _nextCard(false);
                            } else {
                              _nextCard(true);
                            }
                          },
                          child: _buildFlashCard(_currentIndex),
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("No more cards."),
                            ElevatedButton(
                              onPressed: _restartFlashcards,
                              child: const Text("Restart Flashcards"),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _previousCard,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildFlashCard(int index) {
    if (index >= _words.length) return const Text("No more cards.");

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint),
            ),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(_showFront),
        height: 550,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          _showFront
              ? (_showTranslationFirst
                  ? _words[index].translation
                  : _words[index].word)
              : (_showTranslationFirst
                  ? _words[index].word
                  : _words[index].translation),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
