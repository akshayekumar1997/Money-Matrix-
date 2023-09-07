import 'package:flutter/material.dart';
import 'package:moneymaster/dbfunctions/transactiondb_functions.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:moneymaster/dbmodel/transaction/transaction_model.dart';

class TransactionState extends ChangeNotifier {
  double totalSum = 0.0;
  double incomeSum = 0.0;
  double expenseSum = 0.0;

  void calculateSums(List<TransactionModel> transactions)async {
    totalSum = 0;
    incomeSum = 0;
    expenseSum = 0;
 final transactions= await TransactionDb.instance.getAllTransactions();
    for (var transaction in transactions) {
      if (transaction.type == CategoryType.income) {
        incomeSum += transaction.amount;
      } else if (transaction.type == CategoryType.expense) {
        expenseSum += transaction.amount;
      }
      totalSum += transaction.amount;
    }

    notifyListeners(); // Notify listeners about the updated sums
  }
}
