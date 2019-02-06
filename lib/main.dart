import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_item.dart';
import 'new_todo.dart';
import 'database/database_helper.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Todo List",
        home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> _todoItems = [];
  DBHelper dbhelper;
  _TodoListState() {
    dbhelper = DBHelper();
  }

  void _addTodoItem(String taskname) {
    setState(() {
      _todoItems.add(TodoItem(taskname: taskname));
    });
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
      },
    );
  }

  Widget _buildTodoItem(TodoItem task) {
    print("building item is Done ${task.taskName}, ${task.isDone}");
    return ListTile(
      title: Text(task.taskName),
      trailing: Checkbox(
        onChanged: (status) {
          setState(() {
            task.isDone = !task.isDone;
            dbhelper.updateTodo(task);
          });
        },
        value: task.isDone,
      ),
      onLongPress: () {
        _displayDeleteDialog(task);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dbhelper.getTodos().then((todoList) {
      setState(() {
        _todoItems = todoList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Todo List"),
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: _pushAddNewTodoScreen,
      ),
    );
  }

  void _displayDeleteDialog(TodoItem todo) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete TODO"),
            content: Text("Do you want to delete \"${todo.taskName}\"?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: Navigator.of(context).pop,
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  _removeTodoItem(todo);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _removeTodoItem(TodoItem todo) {
    dbhelper.deleteTodo(todo);
    dbhelper.getTodos().then((todoList) {
      setState(() {
        _todoItems = todoList;
      });
    });
  }

  void _pushAddNewTodoScreen() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return NewTodoScreen();
    }));

    dbhelper.getTodos().then((todoList) {
      setState(() {
        _todoItems = todoList;
      });
    });
  }
}
