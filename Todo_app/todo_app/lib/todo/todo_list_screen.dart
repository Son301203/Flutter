import 'package:flutter/material.dart';
import 'package:todo_app/todo/todo_add_screen.dart';
import 'package:todo_app/todo/todo_controller.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = TodoController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, 
                MaterialPageRoute(builder: (_) => const TodoAddScreen())
              );
            }, 
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: todoController.getTodoList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              final todos = snapshot.data!;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index){
                  final todo = todos.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.task),
                    title: Text(todo.title),
                    trailing: IconButton(
                      onPressed: () {
                        
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}