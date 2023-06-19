import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymaster/dbmodel/transaction/transaction_model.dart';
import 'package:moneymaster/dbmodel/transactiondb.dart';
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
final _db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);
_db.put(obj.transactionId, obj);
  }

  Future<void>refreshUi()async{
    final _list=await getAllTransactions();
   _list.sort((first, second) => second.date.compareTo(first.date),);         // compares the two adjacent list like i=1 & i=i+1
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }
  
  @override
  Future<List<TransactionModel>> getAllTransactions() async{
   final _db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);

 return _db.values.toList();
  }
  
  @override
  Future<void> deleteTransaction(String id)async {
   final _db= await Hive.openBox<TransactionModel>(TRANSACTIONDB);
   await  _db.delete(id);
   refreshUi();
  }

}