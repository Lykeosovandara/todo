class TodoModel {
  final String title;
  final bool isCompleted;
  final int id;

  TodoModel({required this.title, this.isCompleted = false, required this.id});

  TodoModel copyWith({String? title, bool? isCompleted}) {
    return TodoModel(
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted, id: id);
  }

  Map<String, dynamic> toMap() {
    return {"title": title, "is_completed": isCompleted};
  }

  factory TodoModel.fromMap(Map<dynamic, dynamic> data) {

  
    return TodoModel(title: data["title"], isCompleted: data["is_completed"], id:data["id"]);
  }
}
