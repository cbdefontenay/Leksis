import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/models/word_model.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GuessWordPage extends StatefulWidget {
  final Folder folder;

  const GuessWordPage({super.key, required this.folder});

  @override
  State<GuessWordPage> createState() => _GuessWordPageState();
}

class _GuessWordPageState extends State<GuessWordPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Word> words = [], selectedWords = [];

  int currentIndex = 0, score = 0, totalWords = 0;

  bool showResults = false,
      isLoading = true,
      gameStarted = false,
      isTransitioning = false;

  List<String> currentChoices = [];

  @override
  void initState() {
    super.initState();

    _loadWords();
  }

  Future<void> _loadWords() async {
    words = await dbHelper.getWords(widget.folder.id!);

    setState(() => isLoading = false);
  }

  void _startGame(int numberOfWords) {
    if (words.length < numberOfWords) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Not enough words! Only ${words.length} available."),

          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      return;
    }

    setState(() {
      selectedWords = List.from(words)..shuffle();
      selectedWords = selectedWords.take(numberOfWords).toList();
      totalWords = selectedWords.length;
      currentIndex = score = 0;
      showResults = gameStarted = false;
      isTransitioning = true;
      gameStarted = true;
      _setNewChoices();
    });
  }

  void _setNewChoices() {
    final currentWord = selectedWords[currentIndex];

    final random = Random();

    final otherTranslations =
        words
            .where((w) => w.id != currentWord.id)
            .map((w) => w.translation)
            .toSet()
            .toList()
          ..shuffle(random);

    setState(() {
      currentChoices =
          {currentWord.translation, ...otherTranslations.take(2)}.toList()
            ..shuffle(random);

      isTransitioning = false;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() => isTransitioning = true);

    if (selectedAnswer == selectedWords[currentIndex].translation) score++;

    Future.delayed(600.ms, () {
      if (currentIndex < selectedWords.length - 1) {
        setState(() => currentIndex++);

        _setNewChoices();
      } else {
        setState(() {
          showResults = true;

          gameStarted = false;
        });
      }
    });
  }

  Widget _buildNumberButton(int number) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),

    child: ElevatedButton(
      onPressed: () => _startGame(number),

      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: Color.lerp(
          Theme.of(context).colorScheme.primary,

          Colors.transparent,

          0.7,
        ),
      ),

      child: SizedBox(
        width: double.infinity,

        child: Center(
          child: Text(
            "$number ${AppLocalizations.of(context)!.words}",

            style: GoogleFonts.firaSans(
              fontSize: 20,

              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildProgressIndicator() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),

    child: Row(
      children: [
        Container(
          width: 40,

          alignment: Alignment.center,

          child: Text(
            "${currentIndex + 1}",

            style: GoogleFonts.firaSans(
              fontSize: 16,

              fontWeight: FontWeight.w600,

              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: (currentIndex + 1) / totalWords,

              backgroundColor: Theme.of(context).colorScheme.outline,

              color: Theme.of(context).colorScheme.tertiary,

              minHeight: 12,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          width: 40,

          alignment: Alignment.center,

          child: Text(
            "$totalWords",

            style: GoogleFonts.poppins(
              fontSize: 16,

              fontWeight: FontWeight.w600,

              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildWordDisplay() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),

    child: Text(
      selectedWords[currentIndex].word,

      key: ValueKey<int>(currentIndex),

      textAlign: TextAlign.center,

      style: GoogleFonts.firaSans(
        fontSize: 37,

        fontWeight: FontWeight.bold,

        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    ),
  );

  Widget _buildChoiceButton(String choice) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),

    child: ElevatedButton(
      onPressed: () => _checkAnswer(choice),

      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,

        foregroundColor: Theme.of(context).colorScheme.onPrimary,

        padding: const EdgeInsets.symmetric(vertical: 18),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        elevation: 4,

        shadowColor: Color.lerp(
          Theme.of(context).colorScheme.primary,

          Colors.transparent,

          0.7,
        ),
      ),

      child: SizedBox(
        width: double.infinity,

        child: Center(
          child: Text(
            choice,

            style: GoogleFonts.firaSans(
              fontSize: 18,

              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildResultsScreen() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Text(
          "${AppLocalizations.of(context)!.score} $score/$totalWords",

          style: GoogleFonts.firaSans(
            fontSize: 24,

            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 32),

        _buildNumberButton(totalWords),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,

              foregroundColor: Theme.of(context).colorScheme.onSurface,

              padding: const EdgeInsets.symmetric(vertical: 18),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              elevation: 2,
            ),

            child: SizedBox(
              width: double.infinity,

              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.exit,

                  style: GoogleFonts.poppins(
                    fontSize: 18,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildStartScreen() => Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            "Select number of words",

            style: GoogleFonts.poppins(
              fontSize: 22,

              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 32),

          ...List.generate(4, (i) => _buildNumberButton([5, 10, 15, 20][i])),
        ],
      ),
    ),
  );

  Widget _buildGameScreen() => Column(
    children: [
      const SizedBox(height: 24),

      _buildProgressIndicator(),

      const Spacer(),

      AnimatedSwitcher(
        duration: 500.ms,

        transitionBuilder:
            (child, animation) => FadeTransition(
              opacity: animation,

              child: ScaleTransition(scale: animation, child: child),
            ),

        child:
            isTransitioning
                ? const SizedBox(height: 100)
                : Column(
                  children: [
                    _buildWordDisplay(),

                    const SizedBox(height: 40),

                    ...currentChoices.map(_buildChoiceButton),
                  ],
                ),
      ),

      const Spacer(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),

        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.guessTheWord,

          style: GoogleFonts.philosopher(
            fontSize: 28,

            fontWeight: FontWeight.w500,
          ).copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),

        centerTitle: true,

        backgroundColor: Theme.of(context).colorScheme.primary,

        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),

      body:
          showResults
              ? _buildResultsScreen()
              : gameStarted
              ? _buildGameScreen()
              : _buildStartScreen(),
    );
  }
}
