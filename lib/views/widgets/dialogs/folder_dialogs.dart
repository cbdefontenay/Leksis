import 'package:flutter/material.dart';
import 'package:leksis/l10n/app_localizations.dart';
import 'package:leksis/models/folder_model.dart';

class FolderDialogs {
  static void showAddFolderDialog(
    BuildContext context,
    Function(String) onAdd,
  ) {
    final TextEditingController controller = TextEditingController();
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String? errorMessage;
          return AlertDialog(
            title: Text(loc.createFolder),
            content: TextField(
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                hintText: loc.createFolderHint,
                errorText: errorMessage,
              ),
              onSubmitted: (value) =>
                  _handleSave(context, controller, onAdd, setState, loc),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancelButton),
              ),
              ElevatedButton(
                onPressed: () =>
                    _handleSave(context, controller, onAdd, setState, loc),
                child: Text(loc.saveButton),
              ),
            ],
          );
        },
      ),
    );
  }

  static void showRenameFolderDialog(
    BuildContext context,
    Folder folder,
    Function(Folder) onUpdate,
  ) {
    final TextEditingController controller = TextEditingController(
      text: folder.name,
    );
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.renameFolder),
        content: TextField(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(hintText: loc.newFolderName),
          onSubmitted: (value) =>
              _handleRename(context, controller, folder, onUpdate),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancelButton),
          ),
          ElevatedButton(
            onPressed: () =>
                _handleRename(context, controller, folder, onUpdate),
            child: Text(loc.updateButton),
          ),
        ],
      ),
    );
  }

  static void _handleSave(
    BuildContext context,
    TextEditingController controller,
    Function(String) onAdd,
    StateSetter setState,
    AppLocalizations loc,
  ) {
    String folderName = controller.text.trim();
    if (folderName.isEmpty) {
      setState(() {
        // errorMessage should be managed by the StatefulBuilder state
      });
    } else {
      onAdd(folderName);
      Navigator.pop(context);
    }
  }

  static void _handleRename(
    BuildContext context,
    TextEditingController controller,
    Folder folder,
    Function(Folder) onUpdate,
  ) {
    if (controller.text.isNotEmpty) {
      onUpdate(Folder(id: folder.id, name: controller.text.trim()));
      Navigator.pop(context);
    }
  }
}
