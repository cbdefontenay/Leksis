import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/data/state/folder_state.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/theme/app_styles.dart';
import 'package:leksis/views/widgets/cards/folder_card.dart';
import 'package:leksis/views/widgets/empty_state_view.dart';
import '../../l10n/app_localizations.dart';

class GenericFolderSelectionPage extends ConsumerWidget {
  final String title;
  final Function(BuildContext, Folder) onFolderSelected;

  const GenericFolderSelectionPage({
    super.key,
    required this.title,
    required this.onFolderSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(foldersProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.philosopher(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppStyles.pageGradient(context)),
        child: folders.isEmpty
            ? EmptyStateView(
                icon: Icons.folder_off_rounded,
                title: loc.noFolder,
                description: loc.noFolderExercisesPrompt,
              ).animate().fadeIn()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return FolderCard(
                    folder: folder,
                    onTap: () => onFolderSelected(context, folder),
                    onAction: (_) {}, // Actions not needed in selection mode
                    renameLabel: "",
                    deleteLabel: "",
                  ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
                },
              ),
      ),
    );
  }
}
