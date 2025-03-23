import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import '../models/folder_model.dart';

import '../models/word_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  int _deleteCount = 0;

  final int _vacuumThreshold = 10;

  Future<void> _maybeVacuum() async {
    _deleteCount++;

    if (_deleteCount >= _vacuumThreshold) {
      final db = await database;

      await db.execute('VACUUM');

      _deleteCount = 0;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('vocabulary.db');

    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('PRAGMA auto_vacuum = INCREMENTAL');

    await db.execute('''  

    CREATE TABLE folders (

      id INTEGER PRIMARY KEY AUTOINCREMENT,

      name TEXT NOT NULL

    )

  ''');

    await db.execute('''  

    CREATE TABLE words (

      id INTEGER PRIMARY KEY AUTOINCREMENT,

      folderId INTEGER NOT NULL,

      word TEXT NOT NULL,

      translation TEXT NOT NULL,

      toBeLearned INTEGER DEFAULT 0,

      FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE

    )

  ''');
  }

  Future<int> insertFolder(Folder folder) async {
    final db = await database;

    return await db.insert('folders', folder.toMap());
  }

  Future<List<Folder>> getFolders() async {
    final db = await database;

    final result = await db.query('folders');

    return result.map((map) => Folder.fromMap(map)).toList();
  }

  Future<int> deleteFolder(int id) async {
    final db = await database;

    int result = await db.delete('folders', where: 'id = ?', whereArgs: [id]);

    await _maybeVacuum();

    return result;
  }

  Future<List<Word>> getWordsOverview() async {
    final db = await database;

    final result = await db.query('words');

    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<int> insertWord(Word word) async {
    final db = await database;

    return await db.insert('words', word.toMap());
  }

  Future<List<Word>> getWords(int folderId) async {
    final db = await database;

    final result = await db.query(
      'words',

      where: 'folderId = ?',

      whereArgs: [folderId],
    );

    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<int> deleteWord(int id) async {
    final db = await database;

    int result = await db.delete('words', where: 'id = ?', whereArgs: [id]);

    await _maybeVacuum();

    return result;
  }

  Future<int> updateWord(Word word) async {
    final db = await database;

    return await db.update(
      'words',

      word.toMap(),

      where: 'id = ?',

      whereArgs: [word.id],
    );
  }

  Future<int> updateFolder(Folder folder) async {
    final db = await database;

    return await db.update(
      'folders',

      folder.toMap(),

      where: 'id = ?',

      whereArgs: [folder.id],
    );
  }

  Future<void> toggleWordLearnStatus(Word word) async {
    final db = await database;
    int newStatus = word.toBeLearned == 1 ? 0 : 1;
    await db.update(
      'words',
      {'toBeLearned': newStatus},
      where: 'id = ?',
      whereArgs: [word.id],
    );
  }

  Future<List<Word>> getWordsByFolder(int folderId) async {
    final db = await database;
    final result = await db.query(
      'words',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return result.map((map) => Word.fromMap(map)).toList();
  }
}
