import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';
import '../models/tag.dart';
import '../models/reminder.dart';
import '../models/attachment.dart';

class NotesDatabase {
  // ================= SINGLETON =================
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  // ================= DB INIT =================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return openDatabase(
        inMemoryDatabasePath,
        version: 7,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 7,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ================= CREATE DB =================
  Future _createDB(Database db, int version) async {
    // NOTES
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        createdAt TEXT,
        isPinned INTEGER DEFAULT 0
      )
    ''');

    // TAGS
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    // NOTE - TAG (N-N)
    await db.execute('''
      CREATE TABLE note_tags (
        noteId INTEGER,
        tagId INTEGER,
        PRIMARY KEY (noteId, tagId)
      )
    ''');

    // REMINDER
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noteId INTEGER,
        remindAt TEXT,
        isDone INTEGER DEFAULT 0,
        notificationId INTEGER
      )

    ''');

    // ATTACHMENTS
    await db.execute('''
      CREATE TABLE attachments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noteId INTEGER,
        fileName TEXT,
        filePath TEXT
      )
    ''');

  }

  // ================= UPGRADE DB =================
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE notes ADD COLUMN isPinned INTEGER DEFAULT 0',
      );
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS tags (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS note_tags (
          noteId INTEGER,
          tagId INTEGER,
          PRIMARY KEY (noteId, tagId)
        )
      ''');
    }

    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS reminders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          noteId INTEGER,
          remindAt TEXT,
          isDone INTEGER DEFAULT 0
        )
      ''');
    }

    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS attachments (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          noteId INTEGER,
          fileName TEXT,
          filePath TEXT
        )
      ''');
    }

    if (oldVersion < 7) {
      await db.execute(
        'ALTER TABLE reminders ADD COLUMN notificationId INTEGER',
      );
    }

    
  }

  // ================= NOTE CRUD =================
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final result = await db.query(
      'notes',
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;

    // Xóa reminder trước
    await db.delete(
      'reminders',
      where: 'noteId = ?',
      whereArgs: [id],
    );

    // Xóa liên kết tag
    await db.delete(
      'note_tags',
      where: 'noteId = ?',
      whereArgs: [id],
    );

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ================= SEARCH =================
  Future<List<Note>> searchNotesWithRange(
    String keyword,
    DateTime fromDate,
  ) async {
    final db = await database;

    final result = await db.query(
      'notes',
      where: '''
        (title LIKE ? OR content LIKE ?)
        AND createdAt >= ?
      ''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        fromDate.toIso8601String(),
      ],
      orderBy: 'isPinned DESC, createdAt DESC',
    );

    return result.map((e) => Note.fromMap(e)).toList();
  }

  // ================= TAG =================
  Future<List<Note>> getNotesByTag(int tagId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT notes.* FROM notes
      INNER JOIN note_tags ON notes.id = note_tags.noteId
      WHERE note_tags.tagId = ?
      ORDER BY notes.isPinned DESC, notes.createdAt DESC
    ''', [tagId]);

    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> createTag(String name) async {
    final db = await database;
    return await db.insert(
      'tags',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Tag>> fetchTags() async {
    final db = await database;
    final result = await db.query('tags');
    return result.map((e) => Tag.fromMap(e)).toList();
  }

  Future<void> addTagToNote(int noteId, int tagId) async {
    final db = await database;
    await db.insert(
      'note_tags',
      {'noteId': noteId, 'tagId': tagId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeTagFromNote(int noteId, int tagId) async {
    final db = await database;
    await db.delete(
      'note_tags',
      where: 'noteId = ? AND tagId = ?',
      whereArgs: [noteId, tagId],
    );
  }

  Future<List<Tag>> getTagsOfNote(int noteId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT tags.* FROM tags
      INNER JOIN note_tags ON tags.id = note_tags.tagId
      WHERE note_tags.noteId = ?
    ''', [noteId]);

    return result.map((e) => Tag.fromMap(e)).toList();
  }



  // ================= REMINDER =================
  Future<int> createReminder(Reminder reminder) async {
    final db = await database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getRemindersOfNote(int noteId) async {
    final db = await database;
    final result = await db.query(
      'reminders',
      where: 'noteId = ? AND isDone = 0',
      whereArgs: [noteId],
      orderBy: 'remindAt ASC',
    );
    return result.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<void> deleteReminder(int reminderId) async {
    final db = await database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }


  // ================= ATTACHMENT =================

  Future<void> addAttachment(Attachment attachment) async {
    final db = await database;
    await db.insert('attachments', attachment.toMap());
  }

  Future<List<Attachment>> getAttachmentsOfNote(int noteId) async {
    final db = await database;
    final result = await db.query(
      'attachments',
      where: 'noteId = ?',
      whereArgs: [noteId],
    );
    return result.map((e) => Attachment.fromMap(e)).toList();
  }

  Future<void> deleteAttachment(int id) async {
    final db = await database;
    await db.delete(
      'attachments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // ================= CLOSE =================
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  
}
