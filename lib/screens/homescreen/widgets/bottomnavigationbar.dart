import 'package:moneymaster/screens/homescreen/homescreen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndexNotifier,
      builder: (BuildContext, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            currentIndex: updatedIndex,
            unselectedItemColor: Colors.blueGrey,
            onTap: (newIndex) {
              HomeScreen.selectedIndexNotifier.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Transactions"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: "Categories")
            ]);
      },
    );
  }
}
