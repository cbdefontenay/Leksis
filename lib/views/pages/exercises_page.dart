import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/views/pages/flashcards_page.dart';
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
              name: "Flashcards",
              backgroundColor: Colors.brown,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlashcardsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            CardExerciseWidget(
              icon: Icons.play_arrow,
              name: "Align words",
              backgroundColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlashcardsPage(),
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
                    builder: (context) => const FlashcardsPage(),
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
