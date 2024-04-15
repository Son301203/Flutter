import 'package:localstore/localstore.dart';
import 'package:todo_app/todo/todo_entity.dart';

class TodoController {
  Future<List<TodoEntity>> getTodoList() async {
    final db = Localstore.instance;
    final result = await db.collection('todos').get() ?? {}; 
    final List<TodoEntity> todos = [];
    // print(result);

    for(final item in result.values) {
      final todo = TodoEntity.fromMap(item);
      todos.add(todo);
    }
    return todos;
  }
}