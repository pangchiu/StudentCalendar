import 'package:app/model/task.dart';
import 'package:app/model/session.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null)
      return _database!;
    else {
      _database = await _initDB('schedule.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Tạo bảng tasks
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT)
    ''');

    // tạo bảng sessions
    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        code TEXT,
        location TEXT,
        teacher TEXT,
        time TEXT,
        type TEXT,
        node TEXT,
        idTask INTEGER NOT NULL)
    ''');
  }

  void insetAll(List<dynamic> schedule) async {
    final db = await instance.database;

    //   //thêm cái này để tránh lỗi locked do yêu cầu đợi quá nhiều
    //   Batch batch = db.batch();

    //   schedule.forEach((e) async {
    //     final dateOfTask = (e['date'] as DateTime).toIso8601String();

    //     final List<dynamic> sessions = (e['sessions'] as List);

    //     // chèn phần tử bảng tasks
    //     int idTask =
    //         await db.rawInsert('INSERT INTO tasks(date) VALUES("$dateOfTask")');

    //     sessions.forEach((s) {
    //       var json = Session.fromJson(s).toJson();
    //       json["idTask"] = idTask;
    //       batch.insert('sessions', json,
    //           conflictAlgorithm: ConflictAlgorithm.replace);
    //     });
    //   });

    //  batch.commit();
    await db.transaction((txn) async {
      var batch = txn.batch();
      schedule.forEach((e) async {
        final dateOfTask = (e['date'] as DateTime).toIso8601String();

        final List<dynamic> sessions = (e['sessions'] as List);

        // chèn phần tử bảng tasks
        int idTask =
            await db.rawInsert('INSERT INTO tasks(date) VALUES("$dateOfTask")');

        sessions.forEach((s) {
          var json = Session.fromJson(s).toJson();
          json["idTask"] = idTask;
          batch.insert('sessions', json,
              conflictAlgorithm: ConflictAlgorithm.replace);
        });
      });

      await batch.commit();

      //  ...
    });
  }

  Future<List<Task>> allTask() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> mapsOfTask = await db.query('tasks');
    List<Task> tasks = [];
    mapsOfTask.forEach((e) async {
      final List<Map<String, Object?>> mapsOfSessions =
          await db.query('sessions', where: 'idTask = ?', whereArgs: [e["id"]]);
      List<Session> sessions = List.generate(mapsOfSessions.length, (index) {
        return Session.fromJson(mapsOfSessions[index]);
      });
      tasks.add(Task(date: DateTime.parse(e["date"]), sessions: sessions));
    });
    return tasks;
  }
}
