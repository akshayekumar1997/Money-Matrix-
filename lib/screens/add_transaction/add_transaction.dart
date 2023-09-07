import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbfunctions/transactiondb_functions.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:moneymaster/dbmodel/transaction/transaction_model.dart';
import 'package:moneymaster/model/sum_update_provider.dart';
import 'package:provider/provider.dart';
bool _isClicked=false;
class AddTransactionScreen extends StatefulWidget {
   AddTransactionScreen({super.key});
  static const routeName = "addTransaction";
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}
class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formkey=GlobalKey<FormState>();
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();
   
  @override
  void initState() {
    
    _selectedCategoryType = CategoryType.income;
     // Add a WillPopScope to update the totalSum when navigating back
    
    super.initState();
  }
  


   
  @override
  Widget build(BuildContext context) {
    final transactionState = Provider.of<TransactionState>(context);
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: 
                Form(
                  key: _formkey,
                  child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //purpose
                  children: [
                    TextFormField(
                      validator: (value) {
                        if(value!.isEmpty||value==null){
return "Enter purpose";
                        }
                      },
                      controller: _purposeTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: "Purpose"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if(value!.isEmpty){
return "Enter amount";
                        }
                      },
                      controller: _amountTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Amount",
                      ),
                    ),
                    //date

                    TextButton.icon(
                      onPressed: () async {
                         _isClicked=true;
                        final selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now());
                        if (selectedDateTemp == null||_isClicked==false) {
                         
                           return; 
                        } else {
                          _isClicked=true;
                          setState(() {
                            _selectedDate = selectedDateTemp;
                           
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDate == null
                          ? "Select Date"
                          : _selectedDate.toString()),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [
                          Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.income;
                                _categoryId = null;
                              });
                            },
                          ),
                          const Text("Income")
                        ]),
                        Row(children: [
                          Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.expense;
                                _categoryId = null;
                              });
                            },
                          ),
                          const Text("Expense")
                        ]),
                      ],
                    ),
                    DropdownButton<String>(
                      hint: const Text("Select Category"),
                      value: _categoryId,
                      items: (_selectedCategoryType == CategoryType.income
                              ? CategoryDb().incomeCategoryListner
                              : CategoryDb().expenseCategoryListner)
                          .value
                          .map((e) {
                        return DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.name),
                          onTap: () {
                            print(e.toString());
                            _selectedCategoryModel = e;
                          },
                        );
                      }).toList(),
                      onChanged: (selectedValue) {
                        setState(() {
                          _categoryId = selectedValue;
                        });
                       
                      },
                    ),

                    ElevatedButton(
                        onPressed: ()async {
                           if (_formkey.currentState!.validate()&&_isClicked==true) {
    await addTransaction();
   final transactions= await TransactionDb.instance.getAllTransactions();
  transactionState.calculateSums(transactions);
        
      } 
      else{
 showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Please select date'),
                    // Set the icon to close the dialog
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                

                }
 );
      }
                 },
                        child: const Text("Add"))
                  ],
                )))
    ));
  }

  Future<void> addTransaction() async {
    final purposeText = _purposeTextEditingController.text;
    final amountText = _amountTextEditingController.text;
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (_categoryId == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final model = TransactionModel(
        purpose: purposeText,
        amount: parsedAmount,
        date: _selectedDate!,
        type: _selectedCategoryType!,
        category: _selectedCategoryModel!);

  Navigator.of(context).pop();
    await TransactionDb.instance.addTransaction(model);
    
  }
   //Function to calculate Total Sum , Total expense
//     Future <void>calculateSum()async{
//        double totalSums=0;
//     double totalExpense=0;
//        double totalIncome=0;
//        // Fetch tramsactions from the database
//  final transactions= await TransactionDb.instance.getAllTransactions();
 



// for (var transaction in transactions) {
// transaction.type==CategoryType.income?totalSum+=transaction.amount:totalSum-=transaction.amount;

//     if (transaction.type == CategoryType.income) {
//       totalIncome += transaction.amount;
//     } else if (transaction.type == CategoryType.expense) {
//       totalExpense += transaction.amount;
//     }
//     Sum(totalSum: totalSums, incomeSum: totalIncome, expenseSum: totalExpense);
//   }
// TransactionDb.instance.transactionListNotifier.value = transactions;
//   setState(() {});
//  }

  
   
    }

