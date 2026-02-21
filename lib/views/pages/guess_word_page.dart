import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import '../../l10n/app_localizations.dart';
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
  List<String?> userAnswers = [];

  @override
  void initState() {
    super.initState();

    _loadWords();
  }

  Future<void> _loadWords() async {
    try {
      words = await dbHelper.getWords(widget.folder.id!);
      if (words.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.emptyFolderError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedLoadWords),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _startGame(int numberOfWords) {
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.emptyFolderError),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (numberOfWords > words.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocalizations.of(context)!.writeWordErrorMessage} ${words.length}",
          ),
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
      userAnswers = List.filled(numberOfWords, null);
      _setNewChoices();
    });
  }

  void _setNewChoices() {
    if (selectedWords.isEmpty || currentIndex >= selectedWords.length) {
      setState(() {
        isTransitioning = false;
        showResults = true;
        gameStarted = false;
      });
      return;
    }

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
    setState(() {
      isTransitioning = true;
      userAnswers[currentIndex] = selectedAnswer;
    });

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
            style: GoogleFonts.firaSans(
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
    child: SizedBox(
      width: double.infinity,
      child: Text(
        selectedWords[currentIndex].word,
        key: ValueKey<int>(currentIndex),
        textAlign: TextAlign.center,
        style: GoogleFonts.firaSans(
          fontSize: 37,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            choice,
            style: GoogleFonts.firaSans(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Widget _buildResultsScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final accuracy =
        totalWords > 0 ? (score / totalWords * 100).toStringAsFixed(1) : '0.0';

    // Get all incorrect answers
    final incorrectAnswers = <Map<String, String>>[];
    for (int i = 0; i < selectedWords.length; i++) {
      if (userAnswers[i] != selectedWords[i].translation) {
        incorrectAnswers.add({
          'word': selectedWords[i].word,
          'userAnswer':
              userAnswers[i] ?? AppLocalizations.of(context)!.noAnswer,
          'correctAnswer': selectedWords[i].translation,
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Results Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Trophy icon with conditional color based on performance
                      Icon(
                        Icons.emoji_events,
                        size: 64,
                        color:
                            (score / totalWords) > 0.7
                                ? Colors.amber
                                : (score / totalWords) > 0.4
                                ? colorScheme.primary
                                : colorScheme.error,
                      ),
                      const SizedBox(height: 16),

                      // Score display
                      Text(
                        AppLocalizations.of(context)!.score,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$score/$totalWords",
                        style: GoogleFonts.firaSans(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Accuracy display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_graph,
                              color:
                                  (score / totalWords) > 0.7
                                      ? Colors.green
                                      : (score / totalWords) > 0.4
                                      ? colorScheme.primary
                                      : colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${AppLocalizations.of(context)!.accuracy} $accuracy%",
                              style: GoogleFonts.firaSans(
                                fontSize: 16,
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

              // Mistakes section - only shown if there are errors
              if (incorrectAnswers.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "${AppLocalizations.of(context)!.mistakes}:",
                      style: GoogleFonts.firaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...incorrectAnswers.map(
                  (mistake) => _buildMistakeCard(mistake),
                ),
                const SizedBox(height: 24),
              ],

              // Action Buttons
              Column(
                children: [
                  // Restart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _startGame(totalWords),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        AppLocalizations.of(context)!.restart,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Change Word Count Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showResults = false;
                          gameStarted = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondaryContainer,
                        foregroundColor: colorScheme.onSecondaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.tune),
                      label: Text(
                        AppLocalizations.of(context)!.changeWordCount,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Exit Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(
                          color: colorScheme.outline,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.exit_to_app),
                      label: Text(
                        AppLocalizations.of(context)!.exit,
                        style: GoogleFonts.firaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMistakeCard(Map<String, String> mistake) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.errorContainer, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word to guess
            _buildAnswerRow(
              icon: Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: colorScheme.primary,
              ),
              label: "${AppLocalizations.of(context)!.word}:",
              value: mistake['word']!,
              valueStyle: GoogleFonts.firaSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // User's answer
            _buildAnswerRow(
              icon: Icon(
                mistake['userAnswer'] == AppLocalizations.of(context)!.noAnswer
                    ? Icons.close
                    : Icons.person_outline,
                size: 18,
                color: colorScheme.error,
              ),
              label: "${AppLocalizations.of(context)!.yourAnswer}:",
              value: mistake['userAnswer']!,
              valueStyle: GoogleFonts.firaSans(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: colorScheme.error,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 12),

            // Correct answer
            _buildAnswerRow(
              icon: Icon(
                Icons.check_circle_outline,
                size: 18,
                color: Colors.green,
              ),
              label: "${AppLocalizations.of(context)!.correctAnswer}:",
              value: mistake['correctAnswer']!,
              valueStyle: GoogleFonts.firaSans(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow({
    required Widget icon,
    required String label,
    required String value,
    required TextStyle valueStyle,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate if the text will fit in one line
        final textSpan = TextSpan(
          text: '$label $value',
          style: GoogleFonts.firaSans(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth: constraints.maxWidth - 26,
        ); // Account for icon and padding

        final fitsInOneLine = !textPainter.didExceedMaxLines;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 3), child: icon),
            const SizedBox(width: 8),
            Expanded(
              child:
                  fitsInOneLine
                      ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: label,
                              style: GoogleFonts.firaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(text: ' $value', style: valueStyle),
                          ],
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            value,
                            style: valueStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStartScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.psychology_alt,
                          size: 60,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.guessTheWord,
                          style: GoogleFonts.firaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.selectNumberWords,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.firaSans(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Word Count Selection Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonSize = constraints.maxWidth / 2 - 24;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                      children:
                          [5, 10, 15, 20].map((count) {
                            return Animate(
                              effects: [
                                FadeEffect(duration: 300.ms),
                                ScaleEffect(
                                  duration: 300.ms,
                                  curve: Curves.easeOutBack,
                                ),
                              ],
                              child: Material(
                                borderRadius: BorderRadius.circular(16),
                                color: colorScheme.secondary,
                                elevation: 4,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _startGame(count),
                                  child: SizedBox(
                                    width: buttonSize,
                                    height: buttonSize,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          count.toString(),
                                          style: GoogleFonts.firaSans(
                                            fontSize: isSmallScreen ? 28 : 36,
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSecondary,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalizations.of(context)!.words,
                                          style: GoogleFonts.firaSans(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            color: colorScheme.onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    );
                  },
                ),

                // All Words Button
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        words.isEmpty ? null : () => _startGame(words.length),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          words.isEmpty
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          words.isEmpty
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.all_inclusive, size: 20),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            "${AppLocalizations.of(context)!.allWords} (${words.length})",
                            style: GoogleFonts.firaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() => Column(
    children: [
      const SizedBox(height: 24),
      _buildProgressIndicator(),
      const Spacer(),
      AnimatedSwitcher(
        duration: 500.ms,
        switchInCurve: Curves.easeOutQuart,
        switchOutCurve: Curves.easeInQuart,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child:
            isTransitioning
                ? const SizedBox(height: 100, key: ValueKey('placeholder'))
                : Column(
                  key: ValueKey('content'),
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
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.loading)),

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
