import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo_model.dart';

class DatabaseController {
  static final DatabaseController db = DatabaseController._init(); //singleton

  DatabaseController._init();

  Future<Database> get database async {
    return await initDB();
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');
    await deleteDatabase(path); //depois comenta essa parte

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE todos (uid INTEGER PRIMARY KEY, title TEXT, description TEXT, status TEXT, creatioDate TEXT)');
      },
      version: 1,
    );
  }

  Future<void> insertTodo(TodoModel todo) async {
    debugPrint("---------Cheguei no insert");
    final db = await database;
    await db.insert(
      'todos',
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await database;
    await db.update(
      'todos',
      todo.toJson(),
      where: 'uid = ?',
      whereArgs: [todo.uid],
    );
  }

  Future<void> deleteTodo(TodoModel todo) async {
    final db = await database;
    await db.delete(
      'todos',
      where: 'uid = ?',
      whereArgs: [todo.uid],
    );
  }

  Future<List<TodoModel>> getAllTodos() async {
    final db = await database;
    var response = await db.query('todos');
    debugPrint("--------- Estou no Load");
    return response.isEmpty
        ? []
        : response.map((json) => TodoModel.fromJson(json)).toList();
  }
}
