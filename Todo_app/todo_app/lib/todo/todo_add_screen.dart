import 'package:flutter/material.dart';
import 'package:todo_app/todo/todo_entity.dart';

class TodoAddScreen extends StatelessWidget {
  const TodoAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final idTextCtrler = TextEditingController();
    final titleTextCtrler = TextEditingController();
    final desTextCtrler = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: idTextCtrler,
            decoration: const InputDecoration(
              hintText: 'ID',
            ),
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: titleTextCtrler,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 8,),
          TextFormField(
            controller: desTextCtrler,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
          ),
          const SizedBox(height: 8,),
          ElevatedButton(
            onPressed: () {
              final id = idTextCtrler.text;
              final title = titleTextCtrler.text;
              final description = desTextCtrler.text;

              TodoEntity(id: id, title: title, description: description)
                .save()
                .then((value) => Navigator.pop(context));
            }, 
            child: const Text('Save')
          )
        ],
      ),
    );
  }
}