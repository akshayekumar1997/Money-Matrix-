import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
Future<void> showCategoryPopUp(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text("Add Category"),
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Category Name"),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    RadioButton(title: "Income", type: CategoryType.income),
                    RadioButton(title: "Expense", type: CategoryType.expense)
                  ],
                )),
            Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                    onPressed: () {
                      final _name = _nameEditingController.text;
                      if (_name.isEmpty) {
                        return;
                      }
                      final _type = selectedCategoryNotifier.value;
                     final _category= CategoryModel(
                          name: _name,
                          type: _type,
                          id: DateTime.now().microsecondsSinceEpoch);
                          CategoryDb.instance.insertCategory(_category );
                          Navigator.of(ctx).pop();
                    },
                    child: Text("Add")))
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  RadioButton({super.key, required this.title, required this.type});
  final String title;
  final CategoryType type;

  CategoryType? _type;

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
