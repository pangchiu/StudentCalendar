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

    var batch = db.batch();
    var batchId = db.batch();

    schedule.forEach((e) async {
      final dateOfTask = (e['date'] as DateTime).toIso8601String();

      final List<dynamic> sessions = (e['sessions'] as List);

      batchId.rawInsert('INSERT INTO tasks(date) VALUES("$dateOfTask")');
      var id = await batchId.commit(noResult: false);

      sessions.forEach((s) {
        var json = Session.fromJson(s).toJson();
        json["idTask"] = int.parse(id[0].toString());
        batch.insert('sessions', json,
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    });

    await batch.commit(noResult: true);
  }

  Future<List<Task>> allTask() async {
    final db = await instance.database;
    var batchTasks = db.batch();
    var batchSessions = db.batch();

    batchTasks.query('tasks');
    var m = await batchTasks.commit(noResult: false);
    m.cast<Map<String,dynamic>?>();
    List<Task> tasks = [];
    // m.forEach((e) async {
    //   print(e);
    //   print(e.toString());
    //   batchSessions.query('sessions',
    //       where: 'idTask = ?', whereArgs: [int.parse(e!.toString())]);
    //   var m1 = await batchSessions.commit(noResult: false);
    //   var mapsOfSessions = m1.cast<Map<String, dynamic>>();
    //   List<Session> sessions = List.generate(mapsOfSessions.length, (index) {
    //     return Session.fromJson((mapsOfSessions as Map)[index]);
    //   });
    //   String a = "idTouch";
    //   tasks.add(Task(date: DateTime.parse(a), sessions: sessions));
    // });

    return tasks;
  }
}
