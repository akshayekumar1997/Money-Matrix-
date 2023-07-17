import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
Future<void> showCategoryPopUp(BuildContext context) async {
  final nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text("Add Category"),
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                controller: nameEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Category Name"),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    RadioButton(title: "Income", type: CategoryType.income),
                    RadioButton(title: "Expense", type: CategoryType.expense)
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                    onPressed: () {
                      final name = nameEditingController.text;
                      if (name.isEmpty) {
                        return;
                      }
                      final type = selectedCategoryNotifier
                          .value; // Get the selected category type
                      final category = CategoryModel(
                        name: name,
                        type: type,
                        id: DateTime.now().microsecondsSinceEpoch,
                      ); CategoryDb.instance.insertCategory(category).then((_) {
                  CategoryDb.instance.getCategories(); // Update the categories
                });
                
                  
                  
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Add")))
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  final String title;
  final CategoryType type;



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext context, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: selectedCategoryNotifier.value,
              onChanged: (value) {
                if (value == null) return;
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title)
      ],
    );
  }
}
