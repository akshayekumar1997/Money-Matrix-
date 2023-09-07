import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:moneymaster/model/sum_update_provider.dart';
import 'package:moneymaster/screens/homescreen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'dbmodel/categorymodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/add_transaction/add_transaction.dart';
import 'dbmodel/transaction/transaction_model.dart';

Future<void> main() async {
  // Ensure flutter frame work is properly initialised before any code is excecuted
  // implementation of the binding between the Flutter framework and the underlying platform, which allows Flutter
  // to interact with the operating system and handle events.

  WidgetsFlutterBinding.ensureInitialized();
  //  Initialises hive and set up nessesary components for database operations
  await Hive.initFlutter();

// Checks if Custom adaapter with Id is already registered in Hive
// If not registered the adapter is registered

// Checks if Category type adapter is registered
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
// Checks if Category Model adapter is registered
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  // Checks if Transaction Model Adapter is registered
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    ChangeNotifierProvider(
      create: (context) => TransactionState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF6A00FF)),
        home: SplashScreen(),
        routes: {
          AddTransactionScreen.routeName: (ctxt) =>  AddTransactionScreen()
        },
      ),
    );
  }
}
