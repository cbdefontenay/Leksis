import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import '../../l10n/app_localizations.dart';
import 'dart:async';

class FindThePairPage extends StatefulWidget {
  final Folder folder;

  const FindThePairPage({super.key, required this.folder});

  @override
  State<FindThePairPage> createState() => _FindThePairPageState();
}

class _FindThePairPageState extends State<FindThePairPage> {
  List<Word> words = [];
  List<Word> gameWords = [];
  List<String> displayedItems = [];
  Set<String> matchedItems = {};
  String? firstSelected;
  String? secondSelected;
  int matchedPairs = 0;
  int score = 0;
  int correctMatches = 0;
  int totalAttempts = 0;
  int timeLeft = 0;
  Timer? timer;
  bool isGameActive = false;
  bool isGameOver = false;
  bool showOptions = true;
  String difficulty = "Normal";
  int wordCount = 5;
  int totalPairs = 5;
  int rounds = 10;
  int currentRound = 0;
  int roundsWon = 0;
  int totalTimeSpent = 0;
  bool showMismatch = false;
  List<String> mismatchedItems = [];

  late Map<String, int> difficultyTimes;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      difficultyTimes = {
        AppLocalizations.of(context)!.easy: 11,
        AppLocalizations.of(context)!.normal: 9,
        AppLocalizations.of(context)!.hard: 7,
      };
      difficulty = AppLocalizations.of(context)!.normal;
      _isInitialized = true;
      loadWords();
    }
  }

  @override
  void initState() {
    super.initState();
    difficultyTimes = {'Easy': 11, 'Normal': 9, 'Hard': 7};
  }

  Future<void> loadWords() async {
    words = await DatabaseHelper.instance.getWordsByFolder(widget.folder.id!);

    setState(() {});
  }

  void startGame() {
    if (words.length < 5) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.needFiveWords,

        backgroundColor: Colors.red,
      );

      return;
    }

    score = 0;
    correctMatches = 0;
    totalAttempts = 0;
    matchedPairs = 0;
    matchedItems.clear();
    isGameOver = false;
    currentRound = 1;
    roundsWon = 0;
    totalTimeSpent = 0;
    showMismatch = false;
    mismatchedItems.clear();

    setState(() {
      showOptions = false;

      isGameActive = true;
    });

    startRound();
  }

  void startRound() {
    if (currentRound > rounds) {
      endGame();

      return;
    }

    matchedPairs = 0;
    matchedItems.clear();
    firstSelected = null;
    secondSelected = null;
    showMismatch = false;
    mismatchedItems.clear();
    gameWords = List.from(words)..shuffle();
    gameWords = gameWords.take(5).toList();
    displayedItems = [];

    for (var word in gameWords) {
      displayedItems.add(word.word);

      displayedItems.add(word.translation);
    }
    displayedItems.shuffle();
    timeLeft = difficultyTimes[difficulty]!;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });

      if (timeLeft <= 0) {
        timer.cancel();

        startNextRound();
      }
    });

    setState(() {});
  }

  void startNextRound() {
    totalTimeSpent += difficultyTimes[difficulty]! - timeLeft;
    timer?.cancel();
    if (currentRound < rounds) {
      currentRound++;

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          startRound();
        } else {
          endGame();
        }
      });
    } else {
      endGame();
    }
  }

  void checkMatch() {
    totalAttempts++;
    var isMatch = false;

    for (var word in gameWords) {
      if ((word.word == firstSelected && word.translation == secondSelected) ||
          (word.word == secondSelected && word.translation == firstSelected)) {
        isMatch = true;

        break;
      }
    }

    if (isMatch) {
      correctMatches++;
      matchedPairs++;
      score += 10 * (timeLeft + 1);
      setState(() {
        matchedItems.add(firstSelected!);
        matchedItems.add(secondSelected!);
        showMismatch = false;
        mismatchedItems.clear();
      });

      if (matchedPairs == totalPairs) {
        roundsWon++;

        startNextRound();
      }
    } else {
      setState(() {
        showMismatch = true;

        mismatchedItems = [firstSelected!, secondSelected!];
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          firstSelected = null;
          secondSelected = null;
          showMismatch = false;
          mismatchedItems.clear();
        });
      });
    }

    firstSelected = null;
    secondSelected = null;
  }

  void endGame() {
    timer?.cancel();
    if (mounted) {
      setState(() {
        isGameActive = false;

        isGameOver = true;
      });
    }
  }

  void selectItem(String item) {
    if (isGameOver || matchedItems.contains(item)) return;
    if (firstSelected == null && showMismatch) {
      setState(() {
        showMismatch = false;

        mismatchedItems.clear();
      });
    }

    if (firstSelected == null) {
      setState(() {
        firstSelected = item;
      });
    } else if (secondSelected == null && item != firstSelected) {
      setState(() {
        secondSelected = item;
      });

      checkMatch();
    }
  }

  double get accuracy {
    try {
      return totalAttempts > 0 ? (correctMatches / totalAttempts) * 100 : 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Color getItemColor(String item) {
    if (matchedItems.contains(item)) {
      return Colors.green;
    }

    if (mismatchedItems.contains(item)) {
      return Colors.red;
    }

    if (item == firstSelected || item == secondSelected) {
      return Theme.of(context).colorScheme.secondary;
    }

    return Theme.of(context).colorScheme.tertiary;
  }

  Color getTextColor(String item) {
    if (matchedItems.contains(item)) {
      return Colors.white;
    }

    if (mismatchedItems.contains(item)) {
      return Colors.white;
    }

    if (item == firstSelected || item == secondSelected) {
      return Theme.of(context).colorScheme.onSecondary;
    }

    return Theme.of(context).colorScheme.onTertiary;
  }

  void restartGame() {
    setState(() {
      isGameOver = false;

      showOptions = true;
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.findThePair,
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
        bottom:
            isGameActive
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(4),
                  child: LinearProgressIndicator(
                    value: totalPairs > 0 ? matchedPairs / totalPairs : 0,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            showOptions
                ? buildOptionsScreen()
                : isGameActive
                ? buildGameScreen()
                : buildGameOverScreen(),
      ),
    );
  }

  Widget buildOptionsScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Icon(Icons.phone_android, size: 48, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.gameOptions,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 32),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.difficulty,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value:
                        AppLocalizations.of(
                          context,
                        )!.normal, // Use localized value
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: AppLocalizations.of(context)!.easy,
                        child: Text(
                          AppLocalizations.of(context)!.easy,
                          style: textTheme.titleMedium,
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: AppLocalizations.of(context)!.normal,
                        child: Text(
                          AppLocalizations.of(context)!.normal,
                          style: textTheme.titleMedium,
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: AppLocalizations.of(context)!.hard,
                        child: Text(
                          AppLocalizations.of(context)!.hard,
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        difficulty = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.repeat, color: colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.numberOfRounds,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: rounds,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items:
                        [5, 10, 20].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              AppLocalizations.of(context)!.roundsCount(value),
                              style: textTheme.titleMedium,
                            ),
                          );
                        }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        rounds = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                textStyle: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.startGame),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '${AppLocalizations.of(context)!.round} $currentRound/$rounds - ${AppLocalizations.of(context)!.matched} $matchedPairs/$totalPairs ${AppLocalizations.of(context)!.pairs}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          '${AppLocalizations.of(context)!.time}: $timeLeft ${AppLocalizations.of(context)!.seconds}',
          style: TextStyle(
            fontSize: 18,
            color: timeLeft <= 3 ? Colors.red : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: displayedItems.length,
            itemBuilder: (context, index) {
              final item = displayedItems[index];
              return Card(
                elevation: 4,
                color: getItemColor(item),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap:
                      matchedItems.contains(item)
                          ? null
                          : () => selectItem(item),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: getTextColor(item)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildGameOverScreen() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accuracyValue = accuracy.isNaN ? 0.0 : accuracy;
    final accuracyColor =
        accuracyValue > 70
            ? Colors.green
            : accuracyValue > 40
            ? Colors.orange
            : Colors.red;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Reduced padding
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * 0.9, // Limit max width
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_esports, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLocalizations.of(context)!.gameOver,
                  style: textTheme.headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      )
                      .merge(GoogleFonts.firaSans()),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_events,
                              color: colorScheme.secondary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${AppLocalizations.of(context)!.roundsWon}: $roundsWon/$rounds',
                                style: textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w500)
                                    .merge(GoogleFonts.firaSans()),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.accuracy}:',
                            style: textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: accuracyValue / 100,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                            color: accuracyColor,
                            backgroundColor: colorScheme.surface,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${accuracyValue.toStringAsFixed(1)}%',
                            style: textTheme.titleLarge?.copyWith(
                              color: accuracyColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color: colorScheme.secondary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context)!.totalTime}: $totalTimeSpent${AppLocalizations.of(context)!.secondsAbbr}',
                            style: textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600)
                                .merge(GoogleFonts.firaSans()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SafeArea(
                top: false,
                bottom: true,
                minimum: const EdgeInsets.only(
                  bottom: 16,
                ), // Add some extra padding
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 400) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.arrow_back,
                            text: AppLocalizations.of(context)!.goBack,
                            onPressed: () => Navigator.of(context).pop(),
                            isPrimary: false,
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            context,
                            icon: Icons.replay,
                            text: AppLocalizations.of(context)!.playAgain,
                            onPressed: restartGame,
                            isPrimary: true,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildActionButton(
                            context,
                            icon: Icons.arrow_back,
                            text: AppLocalizations.of(context)!.goBack,
                            onPressed: () => Navigator.of(context).pop(),
                            isPrimary: false,
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            context,
                            icon: Icons.replay,
                            text: AppLocalizations.of(context)!.playAgain,
                            onPressed: restartGame,
                            isPrimary: true,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? colorScheme.primary : colorScheme.surface,
          foregroundColor:
              isPrimary ? colorScheme.onPrimary : colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:
                isPrimary
                    ? BorderSide.none
                    : BorderSide(color: colorScheme.outline, width: 1),
          ),
          elevation: isPrimary ? 2 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color:
                  isPrimary
                      ? colorScheme
                          .onPrimary // Use onPrimary color for icon when primary
                      : colorScheme
                          .onSurface, // Keep original color for secondary
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: textTheme.titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          isPrimary
                              ? colorScheme
                                  .onPrimary // Use onPrimary color for text when primary
                              : colorScheme
                                  .onSurface, // Keep original color for secondary
                    )
                    .merge(GoogleFonts.firaSans()),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
