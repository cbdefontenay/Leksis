import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
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
  List<String> mismatchedItems = []; // Track mismatched items

  final Map<String, int> difficultyTimes = {"Easy": 11, "Normal": 9, "Hard": 7};

  @override
  void initState() {
    super.initState();

    loadWords();
  }

  Future<void> loadWords() async {
    words = await DatabaseHelper.instance.getWordsByFolder(widget.folder.id!);

    setState(() {});
  }

  void startGame() {
    if (words.length < 5) {
      Fluttertoast.showToast(
        msg: "You need at least 5 words to play.",

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

    currentRound = 1; // Start at round 1

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

    // Only proceed if we haven't completed all rounds

    if (currentRound < rounds) {
      currentRound++; // Move to next round

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

    bool isMatch = false;

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

        startNextRound(); // Directly call without delay
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

    // Clear mismatch state when selecting a new item

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
        title: Text('Find The Pair - ${widget.folder.name}'),

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          'Game Options',

          style: Theme.of(context).textTheme.headlineSmall,

          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        Text('Difficulty:', style: Theme.of(context).textTheme.titleMedium),

        DropdownButton<String>(
          value: difficulty,

          items:
              ["Easy", "Normal", "Hard"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,

                  child: Text(value),
                );
              }).toList(),

          onChanged: (String? newValue) {
            setState(() {
              difficulty = newValue!;
            });
          },
        ),

        const SizedBox(height: 20),

        Text(
          'Number of rounds:',

          style: Theme.of(context).textTheme.titleMedium,
        ),

        DropdownButton<int>(
          value: rounds,

          items:
              [5, 10, 20].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,

                  child: Text('$value rounds'),
                );
              }).toList(),

          onChanged: (int? newValue) {
            setState(() {
              rounds = newValue!;
            });
          },
        ),

        const SizedBox(height: 40),

        ElevatedButton(onPressed: startGame, child: const Text('Start Game')),
      ],
    );
  }

  Widget buildGameScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),

          child: Text(
            'Round $currentRound/$rounds - Matched $matchedPairs/$totalPairs pairs',

            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        Text(
          'Time: $timeLeft sec',

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
    // Ensure we have valid values to display

    final accuracyValue = accuracy.isNaN ? 0.0 : accuracy;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              'Game Over!',

              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 20),

            Text(
              'Rounds Won: $roundsWon/$rounds',

              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Text(
              'Accuracy: ${accuracyValue.toStringAsFixed(1)}%',

              style: const TextStyle(fontSize: 20),
            ),

            Text(
              'Total Time: ${totalTimeSpent}s',

              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },

                  child: const Text('Go Back'),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: restartGame,

                  child: const Text('Play Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
