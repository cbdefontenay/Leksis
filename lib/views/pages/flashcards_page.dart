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

class _FlashcardsPageState extends State<FlashcardsPage> {
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  int _currentIndex = 0;
  bool _showFront = true;
  bool _showTranslationFirst = false;
  bool _showOptionsScreen = true;
  bool _showCompletionScreen = false;

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
    });
  }

  void _startLearning(String mode) {
    List<Word> filtered = [];

    switch (mode) {
      case 'all':
        filtered = List.from(_words);

        break;

      case 'learned':
        filtered = _words.where((word) => word.isLearned).toList();

        break;

      case 'notLearned':
        filtered = _words.where((word) => !word.isLearned).toList();

        break;
    }

    if (filtered.isEmpty) {
      Fluttertoast.showToast(
        msg: "No words found in this category",

        backgroundColor: Colors.red,

        textColor: Colors.white,
      );

      return;
    }

    setState(() {
      _filteredWords = List.from(filtered)..shuffle();

      _currentIndex = 0;

      _showFront = true;

      _showOptionsScreen = false;

      _showCompletionScreen = false;
    });
  }

  Future<void> _updateLearnStatus(bool markAsLearned) async {
    if (_currentIndex >= _filteredWords.length) return;

    Word word = _filteredWords[_currentIndex];

    Word updatedWord = Word(
      id: word.id!,

      folderId: word.folderId,

      word: word.word,

      translation: word.translation,

      isLearned: markAsLearned,
    );

    await DatabaseHelper.instance.updateWord(updatedWord);

    setState(() {
      if (_currentIndex < _filteredWords.length) {
        _filteredWords[_currentIndex] = updatedWord;
      }

      int index = _words.indexWhere((w) => w.id == word.id);

      if (index != -1) {
        _words[index] = updatedWord;
      }
    });

    Fluttertoast.showToast(
      msg: markAsLearned ? "Marked as Learned ⭐" : "Marked to Learn ❌",

      backgroundColor: markAsLearned ? Colors.lightGreen : Colors.teal,

      textColor: Colors.white,
    );
  }

  void _nextCard(bool markAsLearned) async {
    await _updateLearnStatus(markAsLearned);

    if (_currentIndex < _filteredWords.length - 1) {
      setState(() {
        _currentIndex++;

        _showFront = true;
      });
    } else {
      setState(() {
        _showCompletionScreen = true;
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

  void _restartSession() {
    setState(() {
      _currentIndex = 0;

      _showFront = true;

      _showCompletionScreen = false;

      _filteredWords.shuffle();
    });
  }

  void _returnToOptions() {
    setState(() {
      _showOptionsScreen = true;

      _showCompletionScreen = false;
    });
  }

  Widget _buildOptionsScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            "Learn ${widget.folder.name}",

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: 250,

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text("Show Translation First"),

                    Switch(
                      value: _showTranslationFirst,

                      activeColor: Theme.of(context).colorScheme.primary,

                      onChanged: (value) {
                        setState(() {
                          _showTranslationFirst = value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => _startLearning('all'),

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),

                  child: const Text("All Words"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () => _startLearning('learned'),

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),

                  child: const Text("Learned Words"),
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _startLearning('notLearned'),

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Words to Learn"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashCard(int index) {
    final word = _filteredWords[index];

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
        key: ValueKey('${word.id}_$_showFront'),

        height: 500,

        width: 350,

        decoration: BoxDecoration(
          color:
              word.isLearned
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,

          borderRadius: BorderRadius.circular(16),

          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
          ],
        ),

        alignment: Alignment.center,

        padding: const EdgeInsets.all(20),

        child: Text(
          _showFront
              ? (_showTranslationFirst ? word.translation : word.word)
              : (_showTranslationFirst ? word.word : word.translation),

          style: TextStyle(
            fontSize: 36,

            fontWeight: FontWeight.bold,

            color: Theme.of(context).colorScheme.onTertiary,
          ),

          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Text(
            "Session Complete!",

            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Text(
            "You've reviewed all ${_filteredWords.length} words",

            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(
                onPressed: _restartSession,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,

                    vertical: 15,
                  ),
                ),

                child: const Text("Restart"),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: _returnToOptions,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,

                    vertical: 15,
                  ),
                ),

                child: const Text("Change Mode"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flashcards - ${widget.folder.name}"),

        actions: [
          if (!_showOptionsScreen && !_showCompletionScreen)
            IconButton(
              icon: const Icon(Icons.refresh),

              onPressed: _restartSession,

              tooltip: "Reshuffle",
            ),
        ],
      ),

      body:
          _showOptionsScreen
              ? _buildOptionsScreen()
              : _showCompletionScreen
              ? _buildCompletionScreen()
              : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => setState(() => _showFront = !_showFront),

                        child: Dismissible(
                          key: ValueKey(_filteredWords[_currentIndex].id),

                          direction: DismissDirection.horizontal,

                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              _nextCard(false);
                            } else {
                              _nextCard(true);
                            }
                          },

                          child: _buildFlashCard(_currentIndex),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        FloatingActionButton(
                          onPressed: _previousCard,

                          heroTag: 'prevBtn',

                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,

                          child: Icon(
                            Icons.arrow_back,

                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),

                        const SizedBox(width: 20),

                        FloatingActionButton(
                          onPressed: () => _nextCard(false),

                          heroTag: 'nextBtnFalse',

                          backgroundColor:
                              Theme.of(context).colorScheme.onError,

                          child: Icon(
                            Icons.close,

                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),

                        const SizedBox(width: 20),

                        FloatingActionButton(
                          onPressed: () => _nextCard(true),

                          heroTag: 'nextBtnTrue',

                          backgroundColor: Colors.lightGreen[700],

                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
