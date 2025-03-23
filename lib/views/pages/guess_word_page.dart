import 'package:flutter/material.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/models/word_model.dart';
import 'dart:math';

class GuessWordPage extends StatefulWidget {
  final Folder folder;
  const GuessWordPage({super.key, required this.folder});

  @override
  State<GuessWordPage> createState() => _GuessWordPageState();
}

class _GuessWordPageState extends State<GuessWordPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Word> words = [];
  List<Word> selectedWords = [];
  int currentIndex = 0;
  int score = 0;
  bool showResults = false;
  bool answered = false;
  List<String> currentChoices = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() async {
    final loadedWords = await dbHelper.getWords(widget.folder.id!);
    setState(() {
      words = loadedWords;
    });
  }

  void _startGame(int numberOfWords) {
    if (words.length < numberOfWords) {
      _showMessage("Not enough words! Only ${words.length} available.");
      return;
    }

    setState(() {
      selectedWords = List.from(words)..shuffle();
      selectedWords = selectedWords.take(numberOfWords).toList();
      currentIndex = 0;
      score = 0;
      showResults = false;
      answered = false;
      _setNewChoices();
    });
  }

  void _setNewChoices() {
    Word currentWord = selectedWords[currentIndex];
    List<String> choices = {currentWord.translation}.toList();

    final random = Random();
    final otherTranslations =
        words
            .where((w) => w.id != currentWord.id)
            .map((w) => w.translation)
            .toSet()
            .toList();
    otherTranslations.shuffle(random);
    choices.addAll(otherTranslations.take(2));
    choices.shuffle(random);

    setState(() {
      currentChoices = choices;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (!answered) {
      setState(() {
        answered = true;
        if (selectedAnswer == selectedWords[currentIndex].translation) {
          score++;
        }
      });
    }
  }

  void _nextWord() {
    if (currentIndex < selectedWords.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        _setNewChoices();
      });
    } else {
      setState(() {
        showResults = true;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showResults) {
      return Scaffold(
        appBar: AppBar(title: const Text("Game Over")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score: $score / ${selectedWords.length}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _startGame(selectedWords.length),
                child: const Text("Restart"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Exit"),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Select Word Count")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _startGame(5),
                child: const Text("5 Words"),
              ),
              ElevatedButton(
                onPressed: () => _startGame(10),
                child: const Text("10 Words"),
              ),
              ElevatedButton(
                onPressed: () => _startGame(20),
                child: const Text("20 Words"),
              ),
              ElevatedButton(
                onPressed: () => _startGame(words.length),
                child: const Text("All Words"),
              ),
            ],
          ),
        ),
      );
    }

    Word currentWord = selectedWords[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Guess the Word")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  currentWord.word,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...currentChoices.map(
              (choice) => GestureDetector(
                onTap: () => _checkAnswer(choice),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        answered
                            ? (choice == currentWord.translation
                                ? Colors.green
                                : Colors.red)
                            : Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      choice,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: answered ? 1.0 : 0.0,
              child: ElevatedButton(
                onPressed: answered ? _nextWord : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 40), // Extra space for UI stability
          ],
        ),
      ),
    );
  }
}
