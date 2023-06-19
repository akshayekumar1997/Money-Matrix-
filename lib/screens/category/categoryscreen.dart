// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:moneymaster/screens/category/expenseCategory.dart';
import 'package:moneymaster/screens/category/incomeCategory.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin{
 late TabController _tabController;

  @override
  void initState() {
   _tabController=TabController(length: 2, vsync: this);
    CategoryDb().refreshUi();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: [Tab(text: "INCOME",),
          Tab(text: "EXPENSE",)]),
          Expanded(child:  
           TabBarView(
            controller: _tabController,
            children: [
           IncomeCategoryList(),
           ExpenseCategoryList()
          ])
          )
      ],
    
    );
  }
}