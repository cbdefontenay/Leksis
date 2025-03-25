import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/pages/find_the_pair_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leksis/views/widgets/folder_selection_widget.dart';

class FolderSelectionLink extends StatelessWidget {
  const FolderSelectionLink({super.key});

  void _navigauteToFindThePair(BuildContext context, Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindThePairPage(folder: folder)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.selectAFolder,
          style: GoogleFonts.philosopher(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FolderSelectionWidget(
          title: AppLocalizations.of(context)!.selectAFolder,

          onFolderSelected:
              (folder) => _navigauteToFindThePair(context, folder),
        ),
      ),
    );
  }
}
