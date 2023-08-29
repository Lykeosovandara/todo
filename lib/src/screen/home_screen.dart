import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/src/controller/home_controller.dart';
import 'package:todo/src/util/message.dart';
import 'package:todo/src/widget/tile_item.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearch,
                decoration: const InputDecoration(
                  labelText: MessagesString.search,
                  hintText: MessagesString.search,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            ObxValue((dta) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, i) {
                    final item = controller.items[i];
                    return TileItem(
                      toggleCheckBox: () => controller.toggleCompleted(i),
                      todo: item,
                      onEditing: () => controller.editNameByIndex(i),
                      onRemove: () => controller.removeByIndex(i),
                    );
                  },
                ),
              );
            }, [].obs),
            Form(
              key: controller.formKey,
              child: TextFormField(
                focusNode: controller.focusNode,
                controller: controller.txtController,
                onEditingComplete: () => controller.editOrAdd(),
                decoration: const InputDecoration(
                    labelText: MessagesString.whatDoU2GetDone),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return MessagesString.cantBeEmpty;
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
