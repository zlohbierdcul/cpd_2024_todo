import 'package:assignment_todo/business/todo_item.dart';
import 'package:assignment_todo/utils/sort_values.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/status.dart';

class TodoListManager extends ChangeNotifier {
  TodoListManager() {
    loadPreferences();
  }

  Map<int, TodoItem> _todoMap = {};
  SortValues _currentSorting = SortValues.defaultState;

  Map<int, TodoItem> get todoList => _todoMap;

  SortValues get currentSorting => _currentSorting;

  addTodoItem(
      String todo, String description, Status status, DateTime deadline) {
    TodoItem item = TodoItem(
        id: DateTime.now().millisecondsSinceEpoch,
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

  sortTodosByTyp(SortValues value) {
    switch (value) {
      case SortValues.todo:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) => a.value.todo.compareTo(b.value.todo)));
      case SortValues.deadline:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) {
            if (a.value.status == Status.done &&
                b.value.status != Status.done) {
              return 1;
            }
            if (b.value.status == Status.done &&
                a.value.status != Status.done) {
              return -1;
            }
            return a.value.deadline.compareTo(b.value.deadline);
          }));
      case SortValues.status:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) {
            if (a.value.status == Status.done &&
                b.value.status != Status.done) {
              return 1;
            }
            if (b.value.status == Status.done &&
                a.value.status != Status.done) {
              return -1;
            }
            return a.value.status.compareTo(b.value.status);
          }));
      case SortValues.defaultState:
        _todoMap = Map.fromEntries(_todoMap.entries.toList()
          ..sort((a, b) => a.value.id.compareTo(b.value.id)));
    }
    notifyListeners();
    _currentSorting = value;
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
