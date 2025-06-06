import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/folder_model.dart';
import '../models/word_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  int _deleteCount = 0;

  final int _vacuumThreshold = 100;

  Future<void> _maybeVacuum() async {
    _deleteCount++;

    if (_deleteCount >= _vacuumThreshold) {
      final db = await database;
      Future.delayed(const Duration(milliseconds: 300), () async {
        await db.execute('PRAGMA incremental_vacuum(100)');
        _deleteCount = 0;
      });
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

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute('PRAGMA incremental_vacuum(100)');

    await db.execute(''' 
  CREATE TABLE folders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    sortOrder INTEGER NOT NULL DEFAULT 0
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

    final maxOrderResult = await db.rawQuery(
      'SELECT MAX(sortOrder) as max FROM folders',
    );
    final maxOrder = maxOrderResult.first['max'] as int? ?? -1;

    return await db.insert('folders', {
      'name': folder.name,
      'sortOrder': maxOrder + 1,
    });
  }

  Future<int> updateFolderOrder(List<Folder> folders) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var folder in folders) {
        await txn.update(
          'folders',
          {'sortOrder': folders.indexOf(folder)},
          where: 'id = ?',
          whereArgs: [folder.id],
        );
      }
    });
    return folders.length;
  }

  Future<List<Folder>> getFolders() async {
    final db = await database;
    final result = await db.query('folders', orderBy: 'sortOrder ASC');
    return result.map((map) => Folder.fromMap(map)).toList();
  }

  Future<int> deleteFolder(int id) async {
    final db = await database;
    await db.delete('words', where: 'folderId = ?', whereArgs: [id]);
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

    await db.update(
      'words',
      {'toBeLearned': word.isLearned ? 0 : 1},
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
