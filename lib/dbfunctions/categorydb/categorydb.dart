import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneymaster/dbmodel/transactiondb.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
const CATEGORY_DB_NAME="category_db";

abstract class CategoryDbFunctions{
 Future< List <CategoryModel>>getCategories();
Future<void>insertCategory (CategoryModel value);

}
class CategoryDb implements CategoryDbFunctions{
  CategoryDb._internal();
  static CategoryDb instance=CategoryDb._internal();
  factory CategoryDb(){
    return instance;
  }
 ValueNotifier<List<CategoryModel>>incomeCategoryListner=ValueNotifier([]);
  ValueNotifier<List<CategoryModel>>expenseCategoryListner=ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value)async {
  final _category_DB=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
  await _category_DB.add(value);
  
  }
  
  @override
 Future <List<CategoryModel>> getCategories() async{
final _category_DB=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
return _category_DB.values.toList();
  }
 
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
}