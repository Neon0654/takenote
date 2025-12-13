import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class NotesDatabase {
  // Singleton
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return openDatabase(
        inMemoryDatabasePath,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Tạo bảng notes lần đầu tiên
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE notes ADD COLUMN createdAt TEXT');
    }
  }

  // CREATE
  Future<int> createNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  // READ (all)
  Future<List<Note>> fetchNotes() async {
    final db = await instance.database;
    final result = await db.query('notes', orderBy: 'id DESC');

    return result.map((map) => Note.fromMap(map)).toList();
  }

  // READ (by id)
  Future<Note?> getNoteById(int id) async {
    final db = await instance.database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Note>> searchNotes(String keyword) async {
    final db = await instance.database;

    final result = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'createdAt DESC',
    );

    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<List<Note>> searchNotesWithRange(
    String keyword,
    DateTime fromDate,
  ) async {
    final db = await instance.database;

    final result = await db.query(
      'notes',
      where: '''
      (title LIKE ? OR content LIKE ?)
      AND createdAt >= ?
    ''',
      whereArgs: ['%$keyword%', '%$keyword%', fromDate.toIso8601String()],
      orderBy: 'createdAt DESC',
    );

    return result.map((e) => Note.fromMap(e)).toList();
  }
}
