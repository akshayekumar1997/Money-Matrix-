import 'package:hive_flutter/hive_flutter.dart';
part 'categorymodel.g.dart';

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final bool isDeleted;
  @HiveField(2)
  final CategoryType type;
  @HiveField(3)
  final int id;

  CategoryModel(
      {required this.name,
      required this.type ,
      this.isDeleted = false,
      required this.id});

  
      @override
  String toString() {
   return "{$name  $CategoryType}";
  }
}

