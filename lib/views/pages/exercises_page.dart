import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/views/pages/flashcards_page.dart';
import 'package:leksis/views/pages/generic_folder_selection_page.dart';
import 'package:leksis/views/pages/guess_word_page.dart';
import 'package:leksis/views/pages/write_word_page.dart';
import 'package:leksis/views/pages/find_the_pair_page.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/widgets/card_exercise_widget.dart';

import 'package:leksis/theme/app_styles.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExercicesPage extends StatefulWidget {
  const ExercicesPage({super.key});
  @override
  State<ExercicesPage> createState() => _ExercicesPageState();
}

class _ExercicesPageState extends State<ExercicesPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.exercices,
          style: GoogleFonts.philosopher(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.pageGradient(context)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children:
                [
                      _buildExerciseCard(
                        context,
                        icon: Icons.school_rounded,
                        name: loc.flashcards,
                        color: colorScheme.primary,
                        onTap: () => _navigateToSelection(
                          context,
                          loc.flashcards,
                          (ctx, folder) => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => FlashcardsPage(folder: folder),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildExerciseCard(
                        context,
                        icon: Icons.psychology_alt_rounded,
                        name: loc.guessTheWord,
                        color: colorScheme.secondary,
                        onTap: () => _navigateToSelection(
                          context,
                          loc.guessTheWord,
                          (ctx, folder) => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => GuessWordPage(folder: folder),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildExerciseCard(
                        context,
                        icon: Icons.edit_note_rounded,
                        name: loc.writeTheWord,
                        color: colorScheme.tertiary,
                        onTap: () => _navigateToSelection(
                          context,
                          loc.writeTheWord,
                          (ctx, folder) => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => WriteWordPage(folder: folder),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildExerciseCard(
                        context,
                        icon: Icons.unfold_less_double_rounded,
                        name: loc.findThePair,
                        color: colorScheme.surfaceVariant,
                        onTap: () => _navigateToSelection(
                          context,
                          loc.findThePair,
                          (ctx, folder) => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => FindThePairPage(folder: folder),
                            ),
                          ),
                        ),
                        textColor: colorScheme.onSurfaceVariant,
                      ),
                    ]
                    .animate(interval: 100.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, {
    required IconData icon,
    required String name,
    required Color color,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return CardExerciseWidget(
      icon: icon,
      iconColor: textColor ?? Colors.white,
      name: name,
      backgroundColor: color,
      onTap: onTap,
      color: textColor ?? Colors.white,
    );
  }

  void _navigateToSelection(
    BuildContext context,
    String title,
    void Function(BuildContext, Folder) onSelected,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericFolderSelectionPage(
          title: title,
          onFolderSelected: onSelected,
        ),
      ),
    );
  }
}
