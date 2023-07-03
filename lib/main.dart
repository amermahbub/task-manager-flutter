import 'package:flutter/material.dart';

void main() => runApp(TaskManagementApp());

class TaskManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskPage(),
    );
  }
}

class Task {
  String title;
  String description;
  DateTime deadline;

  Task(
      {required this.title, required this.description, required this.deadline});
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> _taskList = [];

  Future<void> _displayAddTaskDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String title = '', description = '';
    DateTime? deadline;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a new task'),
            content: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) => description = value!,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2025),
                      );
                      deadline = date;
                    },
                    child: Text('Select Deadline'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate() && deadline != null) {
                    _formKey.currentState!.save();
                    setState(() {
                      _taskList.add(Task(
                          title: title,
                          description: description,
                          deadline: deadline!));
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTaskDetails(BuildContext context, Task task) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text('Title: ${task.title}'),
                Text('Description: ${task.description}'),
                Text('Deadline: ${task.deadline}'),
                TextButton(
                  child: Text('Delete'),
                  onPressed: () {
                    setState(() {
                      _taskList.remove(task);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: ListView.builder(
        itemCount: _taskList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_taskList[index].title),
            subtitle: Text(_taskList[index].description),
            onLongPress: () {
              _displayTaskDetails(context, _taskList[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayAddTaskDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
