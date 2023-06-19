import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../dbfunctions/categorydb/categorydb.dart';
import '../../dbmodel/categorymodel.dart';
import 'package:moneymaster/dbfunctions/categorydb/categorydb.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
 
    return ValueListenableBuilder(valueListenable: CategoryDb.instance.incomeCategoryListner
, builder: (BuildContext ctx, List<CategoryModel> newList, Widget?_) {
  return ListView.separated(itemBuilder: (ctx, index) {
    final category=newList[index];
    return Card(
      child: ListTile(
        title: Text(category.name),
        trailing: IconButton(onPressed: () {
          
        }, icon:Icon( Icons.delete_forever)),
      ),
      
    );
  }, separatorBuilder: (context, index) {
    return const SizedBox(height: 10);
  }, itemCount:newList.length );
},);
  }
}