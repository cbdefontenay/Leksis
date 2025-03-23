import 'package:flutter/material.dart';
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
                  ? const Center(child: Text("No folders found"))
                  : ListView.builder(
                    itemCount: _filteredFolders.length,
                    itemBuilder: (context, index) {
                      final folder = _filteredFolders[index];

                      return Card(
                        color: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.folder,
                            color: Colors.white,
                          ),
                          title: Text(
                            folder.name,
                            style: const TextStyle(
                              color: Colors.white,
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
