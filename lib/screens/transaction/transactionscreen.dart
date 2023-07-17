

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbfunctions/transactiondb_functions.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:intl/intl.dart';
import '../../dbmodel/transaction/transaction_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
typedef void TransactionDeletedCallback(double totalSum, double incomeSum, double expenseSum);
class TransactionScreen extends StatefulWidget {
  
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  
  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refreshUi();
    CategoryDb.instance.refreshUi();
    return ValueListenableBuilder(
        valueListenable: TransactionDb.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget?_) {
        return  ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                
                final _value=newList[index];
                return 
                Slidable(
                  key: Key(_value.transactionId!),
                  startActionPane: ActionPane(motion: 
                  const ScrollMotion(), children: [
                    SlidableAction(onPressed: (context) async{
                      await TransactionDb.instance.deleteTransaction(_value.transactionId!);
        
    calculateSumDelete();
    TransactionDb.instance.refreshUi();
    setState(() {});
                    },
                    icon: Icons.delete_forever,
                    label: "delete",
                    backgroundColor: Colors.red,)
                  ]),
                  child: 
                   Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundColor: _value.type==CategoryType.income?Colors.purple:Colors.redAccent,
                        child: Text(
                         parseDate(_value.date
                    ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Text("Rs ${_value.amount}"),
                      subtitle: Text(_value.category.name),
                    
                       ),
                   ),
                  
                              );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ), 
              itemCount: newList.length);
        
        });
  }

  String parseDate(DateTime date){
    final _date =DateFormat.MMMd().format(date);
    
    final _splitDate=_date.split(" ");
   return "${_splitDate.last}\n${_splitDate.first}";
   
  }
  Future<void> calculateSumDelete()async{
    double totalSum=0;
    double incomeSum=0;
    double expenseSum=0;
    final transactions=await TransactionDb.instance.getAllTransactions();
    for (var transaction in transactions){
      transaction.type==CategoryType.income?totalSum-=transaction.amount:totalSum-=transaction.amount;
      
      if (transaction.type == CategoryType.income) {
        incomeSum -= transaction.amount;
      } else if (transaction.type == CategoryType.expense) {
        expenseSum -= transaction.amount;
      }
    }
 
  TransactionDb.instance.transactionListNotifier.value = transactions;
  setState(() {
    
  }); // Update the state to trigger UI rebuild
    }

  }

