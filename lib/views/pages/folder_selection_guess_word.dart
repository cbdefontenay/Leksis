import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/pages/guess_word_page.dart';
import 'package:leksis/views/widgets/folder_selection_widget.dart';
import '../../l10n/app_localizations.dart';

class FolderSelectionGuessWordPage extends StatelessWidget {
  const FolderSelectionGuessWordPage({super.key});

  void _navigateToGuessTheWord(BuildContext context, Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GuessWordPage(folder: folder)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.selectAFolder,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ).merge(
            GoogleFonts.philosopher(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FolderSelectionWidget(
          title: AppLocalizations.of(context)!.selectAFolder,
          onFolderSelected:
              (folder) => _navigateToGuessTheWord(context, folder),
        ),
      ),
    );
  }
}
