class Folder {
  int? id;

  String name;

  Folder({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(id: map['id'], name: map['name']);
  }
}
