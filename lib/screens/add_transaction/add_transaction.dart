import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';
import 'package:moneymaster/dbfunctions/transactiondb_functions.dart';
import 'package:moneymaster/dbmodel/categorymodel.dart';
import 'package:moneymaster/dbmodel/transaction/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});
  static const routeName = "addTransaction";

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeTextEditingController=TextEditingController();
  final _amountTextEditingController=TextEditingController();
  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

//income or expense
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //purpose
                  children: [
                    TextFormField( //give autovalidation
                      controller: _purposeTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: "Purpose"),
                    ),
                    TextField(
                      controller: _amountTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Amount",
                      ),
                    ),
                    //date

                    TextButton.icon(
                      onPressed: () async {
                        final _selectedDateTemp = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            lastDate: DateTime.now());
                        if (_selectedDateTemp == null) {
                          return;
                        } else {
                          print(_selectedDateTemp.toString());
                          setState(() {
                            _selectedDate = _selectedDateTemp;
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
                        print(selectedValue);
                      },
                    ),

                    ElevatedButton(onPressed: () {
addTransaction();

                    }, 
                    child: const Text("Add"))
                  ],
                ))));
  }
  Future<void>addTransaction()async{
final _purposeText=_purposeTextEditingController.text;
final _amountText=_amountTextEditingController.text;
if(_purposeText.isEmpty){
  return;
}
if (_amountText.isEmpty){
return;
}
if(_categoryId==null){
  return;
}
if(_selectedDate==null){
  return;
}
final _parsedAmount=double.tryParse(_amountText);
if(_parsedAmount==null){
return;
}
if(_selectedCategoryModel==null){
  return;
}
final _model=
TransactionModel(purpose: _purposeText, 
amount: _parsedAmount, 
date: _selectedDate!, 
type:_selectedCategoryType !, 
category: _selectedCategoryModel!);
//select date

//selected category type
//category Id
await TransactionDb.instance.addTransaction(_model);
Navigator.of(context).pop();
  }
}
