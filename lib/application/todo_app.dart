import 'package:assignment_todo/business/todo_list_manager.dart';
import 'package:flutter/material.dart';

import '../presentation/todo_add_modal.dart';
import '../presentation/todo_list.dart';

class TodoApp extends StatelessWidget {
  final TodoListManager manager = TodoListManager();

  TodoApp({super.key}) {
    manager.loadPreferences();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const TodoAppPage(title: 'Todo App'),
    );
  }
}

class TodoAppPage extends StatelessWidget {
  const TodoAppPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 16),
                child: const Text(
                  "Todos:",
                  style: TextStyle(
                    backgroundColor: Colors.transparent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )),
            const TodoList(),
          ]),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TodoAddModalFloatingButton(),
          ],
        ));
  }
}
