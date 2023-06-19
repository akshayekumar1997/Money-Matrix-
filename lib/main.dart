import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneymaster/dbmodel/transactiondb.dart';
import 'screens/homescreen/homescreen.dart';
import 'dbmodel/categorymodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/add_transaction/add_transaction.dart';
import 'dbmodel/transaction/transaction_model.dart';
Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();


if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
  Hive.registerAdapter(CategoryTypeAdapter());
 }

 if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
  Hive.registerAdapter(CategoryModelAdapter());
 }
  if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
  Hive.registerAdapter(TransactionModelAdapter());
 }
  runApp(MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
theme: ThemeData(primarySwatch: Colors.green),
home: HomeScreen(),
routes:{
  AddTransactionScreen.routeName:(ctxt) =>AddTransactionScreen() 
} ,
    );
  }
}