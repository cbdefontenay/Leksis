class Folder {
  final int? id;
  final String name;
  final int sortOrder;

  Folder({this.id, required this.name, this.sortOrder = 0});

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      sortOrder: map['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'sortOrder': sortOrder};
  }
}
