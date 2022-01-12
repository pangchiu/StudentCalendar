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
    // Tạo bảng DAYS
    await db.execute('''
      CREATE TABLE DAYS(
        idDay INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT)
    ''');

    // tạo bảng MISSIONS
    await db.execute('''
      CREATE TABLE MISSIONS(
        idMissions INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        code TEXT,
        location TEXT,
        teacher TEXT,
        time TEXT,
        type TEXT,
        node TEXT,
        idDay INTEGER NOT NULL)
    ''');
  }

  Future<void> insetAll(List<dynamic> schedule) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      schedule.forEach((s) async {
        final date = (s['date'] as DateTime).toIso8601String();
        int id = await txn.rawInsert('INSERT INTO DAYS(date) VALUES("$date")');
        final List<dynamic> missions = (s['sessions'] as List);

        missions.forEach((m) async {
          var map = Session.fromJson(m).toJson();
          map["idDay"] = id;
         await  txn.insert('MISSIONS', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        });
      });
    });
  }

  Future<List<Task>> allTask() async {
    final db = await instance.database;
    List<Task> tasks = [];
    await db.transaction((txn) async {
      var days = await txn.query('DAYS');
      days.forEach((e) async {
        var jsonMissions = await txn
            .query('MISSIONS', where: 'idDay = ?', whereArgs: [e["idDay"]]);

        List<Session> sessions = List.generate(jsonMissions.length, (index) {
          return Session.fromJson(jsonMissions[index]);
        });
        tasks.add(Task(idDay: int.parse(e["idDay"].toString()),
            date: DateTime.parse(e["date"].toString()), sessions: sessions));
      });
    });
    return tasks;
  }

  Future<void> updateNode (Session s,dynamic value) async {
    final db =  await instance.database;
    await db.transaction((txn) async {
      var map = {'node' : value};
      txn.update('MISSIONS', map, where: 'idDay = ? AND idMissions = ?',whereArgs: [s.idDay,s.idMissions]);
    });
  }


  Future<void> deleteNode (Session s) async {
    final db =  await instance.database;
    await db.transaction((txn) async {
      txn.delete('MISSIONS',  where: 'idDay = ? AND idMissions = ?',whereArgs: [s.idDay,s.idMissions]);
    });
  }


  Future<void> deleteAll () async {
    final db =  await instance.database;    
    await db.transaction((txn) async {
      txn.delete("DAYS");
      txn.delete("MISSIONS");
    });
  }
}
