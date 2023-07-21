import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primaryColor: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.black),
          fillColor: MaterialStateProperty.resolveWith(getCheckboxFillColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
      home: TodoList(),
    );
  }

  Color? getCheckboxFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.green;
    }
    return Colors.grey;
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoTask> tasks = [];
  TextEditingController _taskController = TextEditingController();

  void addTask() {
    setState(() {
      String taskText = _taskController.text;
      TodoTask task = TodoTask(text: taskText, isChecked: false);
      tasks.insert(0, task);
      _taskController.clear();
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isChecked = !tasks[index].isChecked;
      if (tasks[index].isChecked) {
        // Move a tarefa para o final da lista
        TodoTask task = tasks.removeAt(index);
        tasks.add(task);
      } else {
        // Move a tarefa para o início da lista
        TodoTask task = tasks.removeAt(index);
        tasks.insert(0, task);
      }
    });
  }

  Widget buildTaskItem(TodoTask task, int index) {
    return CheckboxListTile(
      title: Text(
        task.text,
        style: TextStyle(
          decoration:
              task.isChecked ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      value: task.isChecked,
      onChanged: (value) {
        toggleTask(index);
      },
      activeColor: Colors.green,
      checkColor: Colors.black,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.grey),
                      child: Icon(Icons.book),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                        hintText: 'Tarefa',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: Text('Cadastrar'),
              onPressed: addTask,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return buildTaskItem(tasks[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoTask {
  String text;
  bool isChecked;

  TodoTask({required this.text, required this.isChecked});
}
