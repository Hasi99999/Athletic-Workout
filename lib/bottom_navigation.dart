import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  BottomNavigationWidget({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue, // Set the background color to blue
      currentIndex: currentIndex,
      onTap: onTabTapped,
      selectedItemColor: Colors.white, // Selected item color
      unselectedItemColor: Colors.white70, // Unselected item color
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home ,color:Colors.black),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center, color:Colors.black),
          label: 'Exercise',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run, color:Colors.black),
          label: 'Warm Up',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color:Colors.black),
          label: 'Profile',
        ),
      ],
    );
  }
}
