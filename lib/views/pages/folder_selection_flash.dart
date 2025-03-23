import 'package:flutter/material.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/pages/flashcards_page.dart';
import 'package:leksis/views/widgets/folder_selection_widget.dart';

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
      appBar: AppBar(title: const Text("Select a Folder"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FolderSelectionWidget(
          title: "Select a Folder",
          onFolderSelected: (folder) => _navigateToFlashcards(context, folder),
        ),
      ),
    );
  }
}
