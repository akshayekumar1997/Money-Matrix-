import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymaster/dbmodel/transaction/transaction_model.dart';

const TRANSACTIONDB="Transaction_db";

abstract class TransactionFunctions{
  Future<void>addTransaction(TransactionModel obj);
 Future <List<TransactionModel>>getAllTransactions();
 
Future<void>deleteTransaction(String id);
}
class TransactionDb implements TransactionFunctions{
 TransactionDb._internal();
 static  TransactionDb instance=TransactionDb._internal();
  factory TransactionDb(){
    return instance;
  }
  ValueNotifier <List<TransactionModel>>transactionListNotifier=ValueNotifier([]);
  @override
  Future<void> addTransaction(TransactionModel obj) async{
final db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);
db.put(obj.transactionId, obj);
  }

  Future<void>refreshUi()async{
    final list=await getAllTransactions();
   list.sort((first, second) => second.date.compareTo(first.date),);         // compares the two adjacent list like i=1 & i=i+1
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();
  }
  
  @override
  Future<List<TransactionModel>> getAllTransactions() async{
   final db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);

 return db.values.toList();
  }
  
  @override
  Future<void> deleteTransaction(String id)async {
   final db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);
   await  db.delete(id);
   refreshUi();
  }

}