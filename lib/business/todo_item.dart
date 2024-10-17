import 'dart:convert';
import 'dart:core';
import 'dart:math';

import '../utils/status.dart';

class TodoItem {
  static int count = Random().nextInt(1000000000);
  int id;
  String todo;
  String description;
  Status status;
  DateTime deadline;

  TodoItem(
      {required this.id,
      required this.description,
      required this.todo,
      required this.deadline,
      required this.status});

  String parseToString() {
    return '{"id": "$id","todo": "$todo","description": "$description","deadline": "$deadline","status": "${status.label}"}';
  }

  static TodoItem parseFromString(String itemString) {
    var data = jsonDecode(itemString);
    int id = int.parse(data["id"]);
    String todo = data["todo"];
    String description = data["description"];
    String deadlineString = data["deadline"];
    String statusString = data["status"];

    DateTime time = DateTime.parse(deadlineString);

    Status status = Status.values.firstWhere((s) => statusString == s.label);

    return TodoItem(
        id: id,
        description: description,
        todo: todo,
        deadline: time,
        status: status);
  }
}
