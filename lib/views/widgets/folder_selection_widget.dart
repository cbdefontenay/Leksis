import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leksis/database/database_helpers.dart';
import 'package:leksis/models/folder_model.dart';

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
    return Column(
      children: [
        TextField(
          controller: _searchController,
          style: GoogleFonts.firaSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: "Search for a folder",
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
                    child: Text(
                      "No folders found",
                      style: GoogleFonts.firaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _filteredFolders.length,
                    itemBuilder: (context, index) {
                      final folder = _filteredFolders[index];

                      return Card(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.folder,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          title: Text(
                            folder.name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () => widget.onFolderSelected(folder),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
