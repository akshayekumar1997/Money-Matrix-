import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbfunctions/transactiondb_functions.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:intl/intl.dart';
import '../../dbmodel/transaction/transaction_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

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
                  ScrollMotion(), children: [
                    SlidableAction(onPressed: (context) {
                      TransactionDb.instance.deleteTransaction(_value.transactionId!);
                    },
                    icon: Icons.delete_forever,
                    label: "delete",)
                  ]),
                  child: 
                   Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 50,
                        child: Text(
                         parseDate(_value.date
                    ),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: _value.type==CategoryType.income?Colors.green:Colors.redAccent,
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
    // return "${date.day}\n ${date.month}";
  }
  }
