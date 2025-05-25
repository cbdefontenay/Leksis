import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';
import '../../l10n/app_localizations.dart';

class FolderSelectionWidget extends StatefulWidget {
  final String title;
  final Function(Folder) onFolderSelected;

  const FolderSelectionWidget({
    super.key,
    required this.title,
    required this.onFolderSelected,
  });

  @override
  State<FolderSelectionWidget> createState() => _FolderSelectionWidgetState();
}

class _FolderSelectionWidgetState extends State<FolderSelectionWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Folder> _folders = [];
  List<Folder> _filteredFolders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await DatabaseHelper.instance.getFolders();
    setState(() {
      _folders = folders;
      _filteredFolders = folders;
    });
  }

  void _filterFolders(String query) {
    setState(() {
      _filteredFolders =
          _folders
              .where(
                (folder) =>
                    folder.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        TextField(
          controller: _searchController,
          style: GoogleFonts.firaSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.selectAFolder,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: _filterFolders,
        ),
        const SizedBox(height: 16),

        Expanded(
          child:
              _filteredFolders.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 80,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.createYourFirstFolder,
                          style: GoogleFonts.firaSans(
                            fontSize: 20,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: _filteredFolders.length,
                    itemBuilder: (context, index) {
                      final folder = _filteredFolders[index];

                      return Card(
                        color: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Icon(
                              Icons.folder,
                              color: colorScheme.onPrimary,
                            ),
                            title: Text(
                              folder.name,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () => widget.onFolderSelected(folder),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
