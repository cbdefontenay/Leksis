import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:leksis/database/database_helpers.dart';

import 'package:leksis/models/folder_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:leksis/models/word_model.dart';

class WriteWordPage extends StatefulWidget {
  final Folder folder;

  const WriteWordPage({super.key, required this.folder});

  @override
  State<WriteWordPage> createState() => _WriteWordPageState();
}

class _WriteWordPageState extends State<WriteWordPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  late Future<List<Word>> _wordsFuture;

  @override
  void initState() {
    super.initState();

    _wordsFuture = _dbHelper.getWords(widget.folder.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Word>>(
      future: _wordsFuture,

      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,

            body: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,

                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          );
        }

        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.error),

              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),

            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.error_outline,

                      size: 64,

                      color: Theme.of(context).colorScheme.error,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      snapshot.data!.isEmpty
                          ? AppLocalizations.of(context)!.emptyFolderError
                          : AppLocalizations.of(context)!.failedLoadWords,

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.w500,

                        color: Theme.of(context).colorScheme.onSurface,
                      ),

                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,

                          vertical: 16,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () => Navigator.pop(context),

                      child: Text(AppLocalizations.of(context)!.goBack),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _GameScreen(words: snapshot.data!);
      },
    );
  }
}

class _GameScreen extends StatefulWidget {
  final List<Word> words;

  const _GameScreen({required this.words});

  @override
  State<_GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<_GameScreen> {
  final _answerController = TextEditingController();

  late List<Word> _selectedWords = [];

  int _currentIndex = 0, _attemptsLeft = 3, _score = 0, _totalWords = 0;

  bool _showResults = false, _showSelection = true;

  @override
  void dispose() {
    _answerController.dispose();

    super.dispose();
  }

  void _startGame(int count) {
    _answerController.clear();

    setState(() {
      _selectedWords = List.from(widget.words)..shuffle();

      if (count < _selectedWords.length) {
        _selectedWords = _selectedWords.sublist(0, count);
      }

      _currentIndex = _score = 0;

      _attemptsLeft = 3;

      _totalWords = count;

      _showResults = false;

      _showSelection = false;
    });
  }

  void _checkAnswer() {
    final answer = _answerController.text.trim();

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validAnswer),

          behavior: SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),

          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      return;
    }

    final correct = _selectedWords[_currentIndex].word.toLowerCase().replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),

      '',
    );

    final userAnswer = answer.toLowerCase().replaceAll(
      RegExp(r'[^a-zA-Z0-9]'),

      '',
    );

    setState(() {
      if (userAnswer == correct) {
        _score++;

        _nextWord();
      } else if (--_attemptsLeft == 0) {
        _nextWord();
      }
    });
  }

  void _nextWord() {
    setState(() {
      if (_currentIndex + 1 < _selectedWords.length) {
        _currentIndex++;

        _attemptsLeft = 3;

        _answerController.clear();
      } else {
        _showResults = true;
      }
    });
  }

  Widget _wordButton(int count, {bool all = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

    child: SizedBox(
      width: double.infinity,

      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: () {
          if (!all && count > widget.words.length) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalizations.of(context)!.writeWordErrorMessage} ${widget.words.length}',
                ),

                behavior: SnackBarBehavior.floating,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );

            return;
          }

          _startGame(all ? widget.words.length : count);
        },

        child: Text(
          all
              ? "All (${widget.words.length})"
              : "$count ${AppLocalizations.of(context)!.words}",

          style: const TextStyle(fontSize: 18),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.enterTheWord,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ).merge(
            GoogleFonts.philosopher(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body:
          _showSelection
              ? _selectionScreen()
              : _showResults
              ? _resultsScreen()
              : _gameScreen(),
    );
  }

  Widget _selectionScreen() => Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.wordToPractice,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 32),
            _wordButton(5),
            _wordButton(10),
            _wordButton(20),
            _wordButton(widget.words.length, all: true),
          ],
        ),
      ),
    ),
  );

  Widget _gameScreen() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.words} ${_currentIndex + 1}/$_totalWords',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.score} $_score',
                  style: TextStyle(
                    fontSize: 16,

                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: (_currentIndex + 1) / _totalWords,

              minHeight: 8,

              borderRadius: BorderRadius.circular(4),

              backgroundColor: Theme.of(context).colorScheme.surface,

              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),

      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedWords[_currentIndex].translation,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterTheWord,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) => _checkAnswer(),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.attemptLeft} $_attemptsLeft",

                    style: TextStyle(
                      fontSize: 16,

                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),

                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,

                        vertical: 16,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _checkAnswer,
                    child: Text(AppLocalizations.of(context)!.submit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _resultsScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accuracy = (_score / _totalWords * 100).toStringAsFixed(1);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Result Card with celebration
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Celebration icon with animated confetti effect
                    Icon(
                      Icons.celebration,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),

                    // Quiz completed text
                    Text(
                      AppLocalizations.of(context)!.quizCompleted,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Score display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Score
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: colorScheme.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${AppLocalizations.of(context)!.score} $_score/$_totalWords",
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Accuracy meter
                          LinearProgressIndicator(
                            value: _score / _totalWords,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                            color:
                                _score / _totalWords > 0.7
                                    ? Colors.green
                                    : _score / _totalWords > 0.4
                                    ? Colors.orange
                                    : Colors.red,
                            backgroundColor: colorScheme.surfaceVariant,
                          ),
                          const SizedBox(height: 8),

                          // Accuracy percentage
                          Text(
                            "${AppLocalizations.of(context)!.accuracy} $accuracy%",
                            style: textTheme.titleMedium?.copyWith(
                              color:
                                  _score / _totalWords > 0.7
                                      ? Colors.green
                                      : _score / _totalWords > 0.4
                                      ? Colors.orange[700]
                                      : Colors.red[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Column(
              children: [
                // Try Again button
                ElevatedButton(
                  onPressed: () => _startGame(_totalWords),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.tryAgain,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Return to folder button
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: colorScheme.outline, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.returnToFolder,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
