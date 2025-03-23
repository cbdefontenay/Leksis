import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/views/pages/folder_selection_flash.dart';
import 'package:leksis/views/pages/folder_selection_guess_word.dart';
import 'package:leksis/views/widgets/card_exercise_widget.dart';

class ExercicesPage extends StatefulWidget {
  const ExercicesPage({super.key});

  @override
  State<ExercicesPage> createState() => _ExercicesPageState();
}

class _ExercicesPageState extends State<ExercicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exercices),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 16),
        child: Column(
          children: [
            CardExerciseWidget(
              icon: Icons.card_membership,
              name: AppLocalizations.of(context)!.flashcards,
              backgroundColor: Colors.brown,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionFlashPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CardExerciseWidget(
              icon: Icons.play_arrow,
              name: AppLocalizations.of(context)!.guessTheWord,
              backgroundColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionGuessWordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CardExerciseWidget(
              icon: Icons.book,
              name: "Write the word",
              backgroundColor: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionFlashPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
