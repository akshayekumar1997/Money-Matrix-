import 'package:flutter/material.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';

import 'package:moneymaster/screens/add_transaction/add_transaction.dart';
import '../../dbfunctions/transactiondb_functions.dart';
import 'widgets/bottomnavigationbar.dart';
import 'package:moneymaster/screens/transaction/transactionscreen.dart';
import 'package:moneymaster/screens/category/categoryscreen.dart';
import 'package:moneymaster/screens/category/categoryAddPopUp.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pages = [const TransactionScreen(), const CategoryScreen()];
 double totalSum = 0.0;
  double incomeSum = 0.0;
  double expenseSum = 0.0;

  @override
  void initState() {
    calculateSum(); // Call calculateSum function in initState
    super.initState();
  }

  // Rest of your code...

  // Function to calculate Total Sum, Total expense, and Total income
  Future<void> calculateSum() async {
    totalSum = 0;
    expenseSum = 0;
    incomeSum = 0;

    // Fetch transactions from the database
    final transactions = await TransactionDb.instance.getAllTransactions();

    for (var transaction in transactions) {
     transaction.type==CategoryType.income?totalSum+=transaction.amount:totalSum-=transaction.amount;

      if (transaction.type == CategoryType.income) {
        incomeSum += transaction.amount;
      } else if (transaction.type == CategoryType.expense) {
        expenseSum += transaction.amount;
      }
    }

    setState(() {}); // Update the state to trigger UI rebuild
  }
  @override
  Widget build(BuildContext context) {

   
   

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 232, 232),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A00FF),
        title: const Text("MONEY MATRIX"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.88,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(60, 219, 210, 210)
                                  .withOpacity(0.02),
                              spreadRadius: 8,
                              blurRadius: 8,
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromARGB(255, 202, 196, 196),
                            width: 2,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Total Balance",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 14),
                             Text(
                              "₹ ${totalSum.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 86.2,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.1, 0.8, 0.95],
                                        colors: [
                                          Color.fromARGB(255, 255, 255, 255),
                                          Color(0xFFCFA2FF),
                                          Color(0xFF9148FF),
                                        ],
                                      ),
                                    ),
                                    child:  
                                    Column(children:[
                                      const SizedBox(height: 25,),
                                    const Row(
                                      children: [
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Color(0xff324149),
                                          size: 18,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Income",
                                          style: TextStyle(
                                            color: Color(0xff324149),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                       
                                      
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Text("₹ ${incomeSum.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900
                                    ),)
                          
                                    ]
                                    )
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 86.2,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.1, 0.8, 0.95],
                                        colors: [
                                          Color(0x00FF6969),
                                          Color(0x32FF6969),
                                          Color(0x88FF6969),
                                        ],
                                      ),
                                    ),
                                    child: 
                                    Column(
                                      children :[
                                        const SizedBox(height: 25,),
                                    const Row(
                                      children: [
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.arrow_downward,
                                          color: Color(0xff324149),
                                          size: 18,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Expense",
                                          style: TextStyle(
                                            color: Color(0xff324149),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Rs ₹ ${expenseSum.toStringAsFixed(2)}"
                                    ,style: const TextStyle(
                                      fontWeight: FontWeight.w900
                                    ),)
                                      ]
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: HomeScreen.selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, Widget? _) {
                return pages[updatedIndex];
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A00FF),
        onPressed: () {
          if (HomeScreen.selectedIndexNotifier.value == 0) {
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
            showCategoryPopUp(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  
  }
   
}
