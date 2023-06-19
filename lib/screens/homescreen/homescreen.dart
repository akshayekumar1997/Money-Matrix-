import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:moneymaster/dbmodel/transactiondb.dart';
import 'package:moneymaster/screens/add_transaction/add_transaction.dart';
import 'widgets/bottomnavigationbar.dart';
import 'package:moneymaster/screens/transaction/transactionscreen.dart';
import 'package:moneymaster/screens/category/categoryscreen.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/screens/category/categoryAddPopUp.dart';
class HomeScreen extends StatelessWidget {

  HomeScreen({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final pages = [TransactionScreen(), CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 232, 232),
      appBar: AppBar(
        title: Text("MONEY MASTER"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: selectedIndexNotifier,
        builder: (BuildContext context, int updatedIndex, Widget? _) {
          return pages[updatedIndex];
        },
      )),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print("Add transaction");
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
            showCategoryPopUp(context);
          }
          // showCategoryPopUp(context);
  //         final _sample = CategoryModel(
  //             name: "akshay",
  //             CategoryType: CategoryType.expense,
  //             id: DateTime.now().millisecondsSinceEpoch);
  // CategoryDb().insertCategory(_sample);    
       
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
