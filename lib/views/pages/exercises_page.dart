import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/views/pages/folder_selection_flash.dart';
import 'package:leksis/views/pages/folder_selection_guess_word.dart';
import 'package:leksis/views/pages/folder_selection_link.dart';
import 'package:leksis/views/pages/folder_selection_write.dart';
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
        title: Text(
          AppLocalizations.of(context)!.exercices,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ).merge(
            GoogleFonts.philosopher(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 16),
        child: Column(
          children: [
            CardExerciseWidget(
              icon: Icons.games_rounded,
              iconColor: Theme.of(context).colorScheme.onPrimary,
              name: AppLocalizations.of(context)!.flashcards,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionFlashPage(),
                  ),
                );
              },

              color: Theme.of(context).colorScheme.onPrimary,
            ),

            const SizedBox(height: 20),

            CardExerciseWidget(
              icon: Icons.speaker_notes,
              iconColor: Theme.of(context).colorScheme.onPrimaryFixed,
              name: AppLocalizations.of(context)!.guessTheWord,

              backgroundColor: Theme.of(context).colorScheme.primaryFixed,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionGuessWordPage(),
                  ),
                );
              },

              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),

            const SizedBox(height: 20),

            CardExerciseWidget(
              icon: Icons.line_style,
              iconColor: Theme.of(context).colorScheme.onTertiary,
              name: AppLocalizations.of(context)!.writeTheWord,
              backgroundColor: Theme.of(context).colorScheme.tertiary,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionWrite(),
                  ),
                );
              },

              color: Theme.of(context).colorScheme.onTertiary,
            ),

            const SizedBox(height: 20),

            CardExerciseWidget(
              icon: Icons.unfold_less_double,
              iconColor: Theme.of(context).colorScheme.onTertiary,
              name: AppLocalizations.of(context)!.findThePair,
              backgroundColor: Theme.of(context).colorScheme.onSurface,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => const FolderSelectionLink(),
                  ),
                );
              },

              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
