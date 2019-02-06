import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'package:todo_app/model/todo_item.dart';

class NewTodoScreen extends StatelessWidget {
  DBHelper dbHelper;
  NewTodoScreen() {
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new Todo"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            autofocus: true,
            onSubmitted: (text) {
              dbHelper.insertTodo(TodoItem(taskname: text,isDone: false));
              Navigator.of(context).pop();
            },
            decoration: InputDecoration(
              hintText: "Enter Something to do ...",
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );
  }
}
