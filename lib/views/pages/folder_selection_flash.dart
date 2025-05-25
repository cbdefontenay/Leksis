import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/pages/flashcards_page.dart';
import 'package:leksis/views/widgets/folder_selection_widget.dart';
import '../../l10n/app_localizations.dart';

class FolderSelectionFlashPage extends StatelessWidget {
  const FolderSelectionFlashPage({super.key});

  void _navigateToFlashcards(BuildContext context, Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlashcardsPage(folder: folder)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          AppLocalizations.of(context)!.selectAFolder,
          style: GoogleFonts.philosopher(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FolderSelectionWidget(
          title: AppLocalizations.of(context)!.selectAFolder,
          onFolderSelected: (folder) => _navigateToFlashcards(context, folder),
        ),
      ),
    );
  }
}
