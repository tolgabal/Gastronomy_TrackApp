import 'package:gastrobluecheckapp/color.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: bigWidgetColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Process',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: "Admin Panel",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: bigWidgetColor, // bigWidgetColor yerine örnek bir renk
      unselectedItemColor: Colors.grey,
      onTap: onTap,
    );
  }
}