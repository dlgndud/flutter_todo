import 'package:flutter_todo/data/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final todoTable = "todo";

  DataBaseHelper._privateConstructor();

  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXSITS $todoTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      title String,
      memo String,
      color INTEGER,
      category String,
      done INTEGER
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // todo create
  // todo update
  // todo read

  Future<int> insertTodo(Todo todo) async {
    Database db = await instance.database;
    if (todo.id == null) {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done
      };
      return await db.insert(todoTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": todo.title,
        "date": todo.date,
        "memo": todo.memo,
        "color": todo.color,
        "category": todo.category,
        "done": todo.done
      };

      return await db
          .update(todoTable, row, where: "id = ?", whereArgs: [todo.id]);
    }
  }

  Future<List<Todo>> getAllTodo() async {
    Database db = await instance.database;
    List<Todo> todos = [];

    var query = await db.query(todoTable);

    for (var q in query) {
      todos.add(Todo(
          id: q["id"],
          title: q["title"],
          date: q["date"],
          memo: q["memo"],
          color: q["color"],
          category: q["category"],
          done: q["done"]));
    }
    return todos;
  }

  Future<List<Todo>> getTodoByDate(int date) async {
    Database db = await instance.database;
    List<Todo> todos = [];

    var query = await db.query(todoTable, where: "date = ?", whereArgs: [date]);

    for (var q in query) {
      todos.add(Todo(
          id: q["id"],
          title: q["title"],
          date: q["date"],
          memo: q["memo"],
          color: q["color"],
          category: q["category"],
          done: q["done"]));
    }
    return todos;
  }
}
