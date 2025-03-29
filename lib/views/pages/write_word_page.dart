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
  bool _showCorrectAnswer = false;
  String _lastCorrectAnswer = '';

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
      _showCorrectAnswer = false;
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
        _lastCorrectAnswer = _selectedWords[_currentIndex].word;
        _showCorrectAnswer = true;
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            _showCorrectAnswer = false;
            _nextWord();
          });
        });
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
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
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
              ? "${AppLocalizations.of(context)!.allWords} (${widget.words.length})"
              : "$count ${AppLocalizations.of(context)!.words}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.enterTheWord,
          style: TextStyle(color: colorScheme.onPrimary).merge(
            GoogleFonts.philosopher(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.wordToPractice,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.chooseWordCount,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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

  Widget _gameScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        backgroundColor: colorScheme.surface,
                        label: Text(
                          '${_currentIndex + 1}/$_totalWords',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Chip(
                        backgroundColor: colorScheme.surface,
                        label: Text(
                          '${AppLocalizations.of(context)!.score} $_score',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / _totalWords,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: colorScheme.surface,
                    color: colorScheme.primary,
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
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translateThis,
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedWords[_currentIndex].translation,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _answerController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.enterTheWord,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(
                            color: colorScheme.outline,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (value) => _checkAnswer(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          backgroundColor:
                              _attemptsLeft > 1
                                  ? colorScheme.errorContainer
                                  : colorScheme.error,
                          label: Text(
                            "${AppLocalizations.of(context)!.attemptLeft} $_attemptsLeft",
                            style: TextStyle(
                              color:
                                  _attemptsLeft > 1
                                      ? colorScheme.onErrorContainer
                                      : colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: colorScheme.primary,
                          ),
                          onPressed: _checkAnswer,
                          icon: const Icon(Icons.check),
                          label: Text(AppLocalizations.of(context)!.submit),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_showCorrectAnswer)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.correctAnswer,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _lastCorrectAnswer,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

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
                    Icon(
                      Icons.celebration,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),

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
                        color: colorScheme.surface,
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
