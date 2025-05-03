import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        msg: AppLocalizations.of(context)!.noWordForCategory,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Theme.of(context).colorScheme.onError,
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
      msg:
          markAsLearned
              ? "${AppLocalizations.of(context)!.markedAsLearned} ⭐"
              : "${AppLocalizations.of(context)!.markToBeLearned} ❌",
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header with folder name
            Column(
              children: [
                Icon(Icons.school, size: 48, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  "${AppLocalizations.of(context)!.learn} ${widget.folder.name}",
                  style: textTheme.headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      )
                      .merge(GoogleFonts.firaSans()),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Options Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Translation Toggle - Fixed overflow
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.showtranslation,
                              style: textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)
                                  .merge(GoogleFonts.firaSans()),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Switch(
                            value: _showTranslationFirst,
                            activeColor: colorScheme.primary,
                            inactiveThumbColor: colorScheme.tertiary,
                            inactiveTrackColor: colorScheme.onTertiary,
                            activeTrackColor: colorScheme.onPrimary,
                            onChanged: (value) {
                              setState(() {
                                _showTranslationFirst = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Learning Mode Buttons
                    Column(
                      children: [
                        _buildLearningModeButton(
                          context,
                          icon: Icons.all_inclusive,
                          text: AppLocalizations.of(context)!.allWords,
                          onPressed: () => _startLearning('all'),
                        ),
                        const SizedBox(height: 12),
                        _buildLearningModeButton(
                          context,
                          icon: Icons.check_circle,
                          text: AppLocalizations.of(context)!.learnedWords,
                          onPressed: () => _startLearning('learned'),
                        ),
                        const SizedBox(height: 12),
                        _buildLearningModeButton(
                          context,
                          icon: Icons.lightbulb,
                          text: AppLocalizations.of(context)!.wordsToLearn,
                          onPressed: () => _startLearning('notLearned'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningModeButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 2,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outline),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: colorScheme.onSecondary),
          const SizedBox(width: 12),
          Text(
            text,
            style: textTheme.titleMedium
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSecondary,
                )
                .merge(GoogleFonts.firaSans()),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Celebration icon
            Icon(Icons.celebration, size: 72, color: colorScheme.primary),
            const SizedBox(height: 24),

            // Completion message
            Text(
              AppLocalizations.of(context)!.sessionComplete,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Stats card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.library_books,
                      size: 36,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${AppLocalizations.of(context)!.youReviewed} ${_filteredWords.length} ${AppLocalizations.of(context)!.words}",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.replay,
                  text: AppLocalizations.of(context)!.restart,
                  onPressed: _restartSession,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  context,
                  icon: Icons.settings,
                  text: AppLocalizations.of(context)!.goBack,
                  onPressed: _returnToOptions,
                  backgroundColor: colorScheme.surfaceBright,
                  foregroundColor: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)!.flashcards} - ${widget.folder.name}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ).merge(
            GoogleFonts.philosopher(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),

        actions: [
          if (!_showOptionsScreen && !_showCompletionScreen)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _restartSession,
              tooltip: AppLocalizations.of(context)!.reshuffle,
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
                    child: SafeArea(
                      top: false,
                      bottom: true,
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
                                  Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
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
                  ),
                ],
              ),
    );
  }
}
