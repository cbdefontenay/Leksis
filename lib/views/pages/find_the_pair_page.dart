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
  int wordCount = 10;
  int totalPairs = 0;

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
    if (words.isEmpty) {
      Fluttertoast.showToast(
        msg: "This folder has no words to play with",
        backgroundColor: Colors.red,
      );
      return;
    }

    int selectedWordCount = wordCount;
    if (wordCount == 0 || wordCount > words.length) {
      selectedWordCount = words.length;
    }

    if (selectedWordCount > words.length) {
      Fluttertoast.showToast(
        msg: "Not enough words in this folder",
        backgroundColor: Colors.red,
      );
      return;
    }

    gameWords = List.from(words)..shuffle();
    gameWords = gameWords.take(selectedWordCount).toList();
    totalPairs = gameWords.length;
    score = 0;
    correctMatches = 0;
    totalAttempts = 0;
    matchedPairs = 0;
    isGameOver = false;

    setState(() {
      showOptions = false;
      isGameActive = true;
    });

    startRound();
  }

  void startRound() {
    displayedItems = [];

    // Add both words and translations
    for (var word in gameWords) {
      displayedItems.add(word.word);
      displayedItems.add(word.translation);
    }

    displayedItems.shuffle();

    firstSelected = null;
    secondSelected = null;
    matchedPairs = 0;
    timeLeft = difficultyTimes[difficulty]!;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });

      if (timeLeft <= 0) {
        timer.cancel();
        endGame();
      }
    });

    setState(() {});
  }

  void endGame() {
    timer?.cancel();
    isGameActive = false;
    isGameOver = true;
    setState(() {});
  }

  void selectItem(String item) {
    // Don't allow selection if game is over or item already matched
    if (isGameOver || !displayedItems.contains(item)) return;

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

  void checkMatch() {
    totalAttempts++;

    bool isMatch = false;
    Word? matchedWord;

    // Check if the selected pair is a valid word-translation pair
    for (var word in gameWords) {
      if ((word.word == firstSelected && word.translation == secondSelected) ||
          (word.word == secondSelected && word.translation == firstSelected)) {
        isMatch = true;
        matchedWord = word;
        break;
      }
    }

    if (isMatch) {
      correctMatches++;
      matchedPairs++;
      score += 10 * (timeLeft + 1); // Bonus for faster matches

      // Remove the matched items from display
      setState(() {
        displayedItems.remove(firstSelected);
        displayedItems.remove(secondSelected);
      });

      // Check if all pairs are matched
      if (matchedPairs == totalPairs) {
        timer?.cancel();
        Future.delayed(const Duration(milliseconds: 1000), endGame);
      }
    } else {
      // Show incorrect match briefly
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          firstSelected = null;
          secondSelected = null;
        });
      });
    }

    // Reset selection regardless of match
    firstSelected = null;
    secondSelected = null;
  }

  double get accuracy {
    return totalAttempts == 0 ? 0 : (correctMatches / totalAttempts) * 100;
  }

  Color getItemColor(String item) {
    if (firstSelected == item) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
    }

    if (secondSelected == item) {
      bool isMatch = false;
      for (var word in gameWords) {
        if ((word.word == firstSelected && word.translation == item) ||
            (word.word == item && word.translation == firstSelected)) {
          isMatch = true;
          break;
        }
      }
      return isMatch ? Colors.green : Colors.red;
    }

    // Grey out matched items
    if (!displayedItems.contains(item)) {
      return Colors.grey.withOpacity(0.3);
    }

    return Theme.of(context).colorScheme.surface;
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
                    value: matchedPairs / totalPairs,
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
          'Number of word pairs:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        DropdownButton<int>(
          value: wordCount,
          items: [
            ...([5, 10, 20].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value pairs'),
              );
            })),
            if (words.length > 20)
              DropdownMenuItem<int>(
                value: words.length,
                child: Text('All pairs (${words.length})'),
              ),
          ],
          onChanged: (int? newValue) {
            setState(() {
              wordCount = newValue!;
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
            'Matched $matchedPairs/$totalPairs pairs',
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
        Text('Score: $score', style: const TextStyle(fontSize: 18)),
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
            itemCount: gameWords.length * 2, // Words + translations
            itemBuilder: (context, index) {
              // Handle cases where items might be removed after matching
              if (index >= displayedItems.length) {
                return Container(); // Empty container for matched items
              }
              final item = displayedItems[index];
              return Card(
                elevation: 4,
                color: getItemColor(item),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => selectItem(item),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Game Over!', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Text(
            'Final Score: $score',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Accuracy: ${accuracy.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Matched $matchedPairs/$totalPairs pairs',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 40),
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
    );
  }
}
