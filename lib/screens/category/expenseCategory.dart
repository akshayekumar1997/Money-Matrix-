import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';

import '../../dbmodel/categorymodel.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb.instance.expenseCategoryListner,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = newList[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDb.instance.deleteCategories(index);
                      }, icon: const Icon(Icons.delete_forever),
                      color: Colors.red,),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: newList.length);
      },
    );
  }
}
