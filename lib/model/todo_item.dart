class TodoItem {
  String taskName;
  bool isDone ;

  TodoItem({String taskname, bool isDone}) {
    this.taskName = taskname;
    this.isDone = isDone;
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) =>
      TodoItem(taskname: map['taskname'], isDone: map['isdone']==1);

  Map<String, dynamic> toMap() =>
      {"taskname": taskName, "isdone": isDone ? 1 : 0};
}
