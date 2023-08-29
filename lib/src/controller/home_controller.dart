import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/src/model/todo_model.dart';
import 'package:todo/src/service/todo_service.dart';
import 'package:todo/src/util/message.dart';

class HomeController extends GetxController {
  final _items = <TodoModel>[].obs;
  List<TodoModel>? _tempItems;

  // Temp items for reset data after search
  final _isLoading = false.obs;
  int? _editIndex;

  final txtController = TextEditingController();
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final TodoService todoService = TodoService();

  RxList<TodoModel> get items => _items;

  bool get isEditing => _editIndex != null;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadTodoItems();
  }

  @override
  void onClose() {
    txtController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  // validate text field first
  // update if edit true and it will dd
  void editOrAdd() {
    if (formKey.currentState?.validate() ?? false) {
      if (isEditing) {
        final oldValue = _items[_editIndex!];
        _items[_editIndex!] = oldValue.copyWith(title: txtController.text);
        todoService.editTodo(_items[_editIndex!]);
        clearEdit();
        clearTextField();
      } else if (!isEditing && !isDuplicated()) {
        add();
      } else if (isDuplicated()) {
        showDuplicatedSnackbar();
      }
    }
  }

  // Get value from controller
  void add() async {
    final result = await todoService.addToDo(txtController.text);
    _items.add(result);
    backuptoTemp();
    clearTextField();
  }

  // what index to update and the new value from controller to update
  void editNameByIndex(int index) {
    final oldValue = items[index];
    txtController.text = oldValue.title;
    focusNode.requestFocus();
    _items[index] = oldValue.copyWith(title: txtController.text);
    _editIndex = index;
  }

  void clearTextField() {
    txtController.clear();
  }

  void focusTextField() {
    focusNode.requestFocus();
  }

  void clearEdit() {
    _editIndex = null;
  }

  // toggle complate by index
  void toggleCompleted(int index) {
    final oldValue = _items[index];
    _items[index] = oldValue.copyWith(isCompleted: !oldValue.isCompleted);
    todoService.editTodo(_items[index]);
  }

  void removeByIndex(int index) {
    todoService.deleteTodo(_items[index].id);
    _items.removeAt(index);
  }

  // make all the to do name to set
  // check the lenght of the origanal item
  // if equal it mean the same name
  // it is not it mean name does not exist before
  // it might be fast to use set
  bool isDuplicated() {
    final setOfTodo = _items.map((element) => element.title).toSet()
      ..add(txtController.text);

    return _items.length == setOfTodo.length;
  }

  void showDuplicatedSnackbar() {
    Get.showSnackbar(const GetSnackBar(
      message: MessagesString.duplicatedItem,
    ));
  }

  void _startLoading() {
    _isLoading.value = true;
  }

  void _stopLoading() {
    _isLoading.value = false;
  }

  void loadTodoItems() async {
    _startLoading();

    _items.value = await todoService.listTodo();
    backuptoTemp();

    _stopLoading();
  }

  void onSearch(String query) {
    if (query.isEmpty) {
        resetData();
    } else {
      resetData();
      _items.value = _items
          .where((p0) => p0.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void resetData() {
    _items.value = _tempItems!.map((e) => e).toList() ;
  }

  void backuptoTemp() {
    _tempItems = items.toList();
  }
}
