import 'package:assignment_todo/business/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/status.dart';

class TodoListManager extends ChangeNotifier {
  TodoListManager() {
    loadPreferences();
  }

  Map<int, TodoItem> _todoMap = {};

  Map<int, TodoItem> get todoList => _todoMap;

  addTodoItem(
      String todo, String description, Status status, DateTime deadline) {
    TodoItem item = TodoItem(
        id: TodoItem.count++,
        description: description,
        todo: todo,
        deadline: deadline,
        status: status);
    _todoMap[item.id] = item;

    notifyListeners();
    savePreferences();
  }

  removeTodoItem(int id) {
    _todoMap.remove(id);
    notifyListeners();
    savePreferences();
  }

  changeTodoStatus(int id, Status newStatus) {
    TodoItem? item = _todoMap[id];
    item?.status = newStatus;

    if (item != null) {
      _todoMap[id] = item;
    }
    notifyListeners();
    savePreferences();
  }

  sortTodosByDeadline() {
    _todoMap = Map.fromEntries(_todoMap.entries.toList()
      ..sort((a, b) => a.value.deadline.compareTo(b.value.deadline)));
    notifyListeners();
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList("todolist",
        _todoMap.values.map((item) => item.parseToString()).toList());
  }

  void loadPreferences() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? itemStringList = prefs.getStringList("todolist");
    if (itemStringList == null) return;
    for (String itemString in itemStringList) {
      try {
        TodoItem item = TodoItem.parseFromString(itemString);
        _todoMap[item.id] = item;
      } catch (e) {
        print("Parsing failed");
        continue;
      }
    }
    notifyListeners();
  }
}
