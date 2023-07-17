

import 'package:flutter/material.dart';

import 'package:moneymaster/screens/category/expenseCategory.dart';
import 'package:moneymaster/screens/category/incomeCategory.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    
    CategoryDb().refreshUi();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: const [
              Tab(
                text: "INCOME",
              ),
              Tab(
                text: "EXPENSE",
              )
            ]),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: const [IncomeCategoryList(), ExpenseCategoryList()]))
      ],
    );
  }
}
