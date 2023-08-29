import 'package:flutter/material.dart';
import 'package:todo/src/model/todo_model.dart';
import 'package:todo/src/util/message.dart';

class TileItem extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onEditing;
  final VoidCallback onRemove;
  final VoidCallback? toggleCheckBox;

  const TileItem({
    super.key,
    required this.todo,
    required this.onEditing,
    required this.onRemove,
    required this.toggleCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: toggleCheckBox,
        child: Icon(
          todo.isCompleted
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank,
          size: 32,
        ),
      ),
      title: Text(todo.title, style: TextStyle(
        decoration: todo.isCompleted ?  TextDecoration.lineThrough : TextDecoration.none
      ),),
      trailing: IconButton(
          onPressed: () => showActionSheet(context),
          icon: const Icon(Icons.more_vert)),
    );
  }

  void showActionSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text(MessagesString.update),
                    onTap: () {
                      Navigator.pop(context);
                      onEditing();

                    },
                  ),
                  ListTile(
                    title: const Text(MessagesString.remove),
                    onTap: () {
                       Navigator.pop(context);
                       onRemove();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
