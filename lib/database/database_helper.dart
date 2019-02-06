import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo_item.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    io.Directory todoDirectory = await getApplicationDocumentsDirectory();
    String path = join(todoDirectory.path, "todo.db");

    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskname TEXT NOT NULL,
        isdone INTEGER NOT NULL
      )
      ''');
      print("Table created");
  }

  Future<List<TodoItem>> getTodos() async{
    var dbClient = await db;
    List<Map<String,dynamic>> list = await dbClient.query("Todos");
    List<TodoItem> todoList = list.map((jsonMap)=>TodoItem.fromMap(jsonMap)).toList();
    return todoList;
  }

  void insertTodo(TodoItem todo) async{
    var dbClient = await db;
    var res = await dbClient.insert("Todos", todo.toMap());
    print("insert Result $res");
  }
  
  void deleteTodo(TodoItem todo) async{
    var dbClient = await db;
    var res = await dbClient.delete("Todos", where: "taskname = ?", whereArgs: [todo.taskName]);
    print("delete Res $res");
  }

  void updateTodo(TodoItem todo) async{
    var dbClient = await db;
    var res = await dbClient.update("Todos", todo.toMap(), where: "taskname = ?", whereArgs: [todo.taskName]);
    print("Update res $res");
  }
}
