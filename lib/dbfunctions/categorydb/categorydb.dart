
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:moneymaster/dbmodel/categorymodel.dart';

const CATEGORY_DB_NAME = "category_db";

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb._internal();
  static CategoryDb instance = CategoryDb._internal();
  factory CategoryDb() {
    return instance;
  }
  ValueNotifier<List<CategoryModel>> incomeCategoryListner = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListner = ValueNotifier([]);
  Future<void> refreshUi() async {
  final _allCategories = await getCategories();
  final incomeCategories = <CategoryModel>[];
  final expenseCategories = <CategoryModel>[];
 
  for (final category in _allCategories) {
    if (category.type == CategoryType.income) {
      incomeCategories.add(category);
    } else {
      expenseCategories.add(category);
    }
  }

  incomeCategoryListner.value = incomeCategories;
  expenseCategoryListner.value = expenseCategories;
  
  incomeCategoryListner.notifyListeners();
  expenseCategoryListner.notifyListeners();
}

  @override
@override
Future<void> insertCategory(CategoryModel value) async {
  final categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
  await categoryDb.add(value);

  // Update the listeners immediately after adding to the database
  if (value.type == CategoryType.income) {
    incomeCategoryListner.value = [...incomeCategoryListner.value, value];
    incomeCategoryListner.notifyListeners();
  } else {
    expenseCategoryListner.value = [...expenseCategoryListner.value, value];
    expenseCategoryListner.notifyListeners();
  }
}



  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDb.values.toList();

  }
  Future <void>deleteCategories(int id)async{
    final categoryDb=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDb.deleteAt(id);
  await  refreshUi();
  }

  
}

  

