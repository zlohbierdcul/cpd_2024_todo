import 'package:assignment_todo/business/todo_list_manager.dart';
import 'package:assignment_todo/presentation/todo_page_headerline.dart';
import 'package:assignment_todo/utils/sort_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.all(8.0), // Padding inside the dropdown menu
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: TodoAppPage(title: 'Todo App'),
    );
  }
}

class TodoAppPage extends StatelessWidget {
  TodoAppPage({super.key, required this.title});

  final String title;

  final TextEditingController _controller =
      TextEditingController(text: "default");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TodoAppHeaderLine(),
                TodoList(),
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
