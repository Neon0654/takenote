import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/note.dart';
import '../models/tag.dart';
import '../models/reminder.dart';
import '../models/attachment.dart';
import '../models/folder.dart';



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
        version: 9,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 9,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ================= CREATE DB =================
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        createdAt TEXT,
        isPinned INTEGER DEFAULT 0,
        isDeleted INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE note_tags (
        noteId INTEGER,
        tagId INTEGER,
        PRIMARY KEY (noteId, tagId)
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noteId INTEGER,
        remindAt TEXT,
        isDone INTEGER DEFAULT 0,
        notificationId INTEGER
      )
    ''');


    

    await db.execute('''
      CREATE TABLE attachments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noteId INTEGER,
        fileName TEXT,
        filePath TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        color INTEGER,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE folder_notes (
        folderId INTEGER,
        noteId INTEGER,
        PRIMARY KEY (folderId, noteId)
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

    if (oldVersion < 8) {
      await db.execute(
        'ALTER TABLE notes ADD COLUMN isDeleted INTEGER DEFAULT 0',
      );
    }

        if (oldVersion < 9) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS folders (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          color INTEGER,
          createdAt TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS folder_notes (
          folderId INTEGER,
          noteId INTEGER,
          PRIMARY KEY (folderId, noteId)
        )
      ''');
    }

  }

  // ================= NOTE =================

  /// CREATE
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  /// FETCH NORMAL NOTES
  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'isDeleted = 0',
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  /// FETCH TRASH
  Future<List<Note>> fetchTrashNotes() async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: 'isDeleted = 1',
      orderBy: 'createdAt DESC',
    );
    return result.map((e) => Note.fromMap(e)).toList();
  }

  /// GET BY ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final result =
        await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Note.fromMap(result.first);
    return null;
  }

  /// UPDATE
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  /// MOVE TO TRASH (XÓA MỀM)
  Future<void> moveNoteToTrash(int id) async {
    final db = await database;
    await db.update(
      'notes',
      {'isDeleted': 1, 'isPinned': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// RESTORE
  Future<void> restoreNote(int id) async {
    final db = await database;
    await db.update(
      'notes',
      {'isDeleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// DELETE PERMANENT
  Future<void> deleteNotePermanently(int id) async {
    final db = await database;

    await db.delete('reminders',
        where: 'noteId = ?', whereArgs: [id]);
    await db.delete('note_tags',
        where: 'noteId = ?', whereArgs: [id]);
    await db.delete('attachments',
        where: 'noteId = ?', whereArgs: [id]);

    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ================= SEARCH =================
  Future<List<Note>> searchNotesWithRange(
      String keyword, DateTime fromDate) async {
    final db = await database;
    final result = await db.query(
      'notes',
      where: '''
        isDeleted = 0 AND
        (title LIKE ? OR content LIKE ?) AND
        createdAt >= ?
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
      WHERE note_tags.tagId = ? AND notes.isDeleted = 0
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
    final result =
        await db.query('attachments', where: 'noteId = ?', whereArgs: [noteId]);
    return result.map((e) => Attachment.fromMap(e)).toList();
  }

  Future<void> deleteAttachment(int id) async {
    final db = await database;
    await db.delete('attachments', where: 'id = ?', whereArgs: [id]);
  }

  // ================= CLOSE =================
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
  // ================= FOLDER =================

  Future<int> createFolder(Folder folder) async {
    final db = await database;
    return await db.insert('folders', folder.toMap());
  }

  Future<List<Folder>> fetchFolders() async {
    final db = await database;
    final result = await db.query(
      'folders',
      orderBy: 'color ASC, createdAt DESC',
    );
    return result.map((e) => Folder.fromMap(e)).toList();
  }


  Future<int> countNotesInFolder(int folderId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM folder_notes WHERE folderId = ?',
      [folderId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> addNoteToFolder(int folderId, int noteId) async {
    final db = await database;
    await db.insert(
      'folder_notes',
      {'folderId': folderId, 'noteId': noteId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> deleteFolder(int folderId) async {
  final db = await database;

    // Xóa liên kết note – folder trước
    await db.delete(
      'folder_notes',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );

    // Xóa folder
    await db.delete(
      'folders',
      where: 'id = ?',
      whereArgs: [folderId],
    );
  }
  // ================= FOLDER NOTES =================

  Future<List<Note>> fetchNotesByFolder(int folderId) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT notes.* FROM notes
      INNER JOIN folder_notes
        ON notes.id = folder_notes.noteId
      WHERE folder_notes.folderId = ?
        AND notes.isDeleted = 0
      ORDER BY notes.isPinned DESC, notes.createdAt DESC
    ''', [folderId]);

    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> linkNoteToFolder(int noteId, int folderId) async {
    final db = await database;

    await db.insert(
      'folder_notes',
      {
        'noteId': noteId,
        'folderId': folderId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // ================= HOME NOTES (KHÔNG THUỘC FOLDER) =================
  Future<List<Note>> fetchNotesWithoutFolder() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT * FROM notes
      WHERE isDeleted = 0
        AND id NOT IN (
          SELECT noteId FROM folder_notes
        )
      ORDER BY isPinned DESC, createdAt DESC
    ''');

    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> updateFolderName(int id, String name) async {
    final db = await database;
    await db.update(
      'folders',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

Future<Map<int, int>> countNotesByFolder() async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT fn.folderId, COUNT(fn.noteId) as total
    FROM folder_notes fn
    INNER JOIN notes n ON n.id = fn.noteId
    WHERE n.isDeleted = 0
    GROUP BY fn.folderId
  ''');

  final Map<int, int> map = {};
  for (final row in result) {
    map[row['folderId'] as int] = row['total'] as int;
  }

  return map;
}

Future<void> moveNoteToFolder({
  required int noteId,
  int? folderId, // null = đưa ra ngoài folder
}) async {
  final db = await database;

  // 🔥 Xóa liên kết cũ
  await db.delete(
    'folder_notes',
    where: 'noteId = ?',
    whereArgs: [noteId],
  );

  // 🔥 Nếu có folder mới → thêm lại
  if (folderId != null) {
    await db.insert(
      'folder_notes',
      {
        'noteId': noteId,
        'folderId': folderId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}







  
}
