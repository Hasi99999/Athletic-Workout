import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart' as color;

class VideoGuidePage extends StatelessWidget {
  const VideoGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Guide",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome to the Video Guide",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // First Scrollable Container
            Container(
              height: 200,  // Adjust the height as needed
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(20, (index) {
                    return ListTile(
                      title: Text('Video ${index + 1}'),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Second Scrollable Container
            Container(
              height: 200,  // Adjust the height as needed
              color: Colors.grey[300],
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(20, (index) {
                    return ListTile(
                      title: Text('Guide ${index + 1}'),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set initial index to Exercise Page
        onTap: (index) {
          // Handle navigation here based on index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/exercise');
              break;
            case 2:
              Navigator.pushNamed(context, '/warmUp');
              break;
            case 3:
              Navigator.pushNamed(context, '/userProfile');
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, color: Colors.black),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run, color: Colors.black),
            label: 'Warm Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
