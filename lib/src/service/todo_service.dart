import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo/src/model/todo_model.dart';

final supabase = Supabase.instance.client;

class TodoService {
  SupabaseQueryBuilder get _table => supabase.from("items");

  Future<TodoModel> addToDo(String title) async {
    final result =
        await _table.insert({"title": title}).select<PostgrestList>();

    return TodoModel.fromMap(result[0]);
  }

  Future<List<TodoModel>> listTodo() async {
    final result = await _table.select<PostgrestList>();

    return result.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<void> editTodo(TodoModel item) async {
    await _table.update(item.toMap()).eq("id", item.id);
  }

  Future<void> deleteTodo(int id) async {
    await _table.delete().eq("id", id);
  }
}
