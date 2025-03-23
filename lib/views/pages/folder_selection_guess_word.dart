import 'package:flutter/material.dart';
import 'package:leksis/models/folder_model.dart';
import 'package:leksis/views/pages/guess_word_page.dart';
import 'package:leksis/views/widgets/folder_selection_widget.dart';

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
      appBar: AppBar(title: const Text("Select a Folder"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FolderSelectionWidget(
          title: "Select a Folder",
          onFolderSelected:
              (folder) => _navigateToGuessTheWord(context, folder),
        ),
      ),
    );
  }
}
