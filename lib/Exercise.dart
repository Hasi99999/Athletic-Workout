import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart' as color;

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  // Sign out function
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/signIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Athletic Workout",
          style: TextStyle(
            fontSize: 30,
            color: color.AppColor.homePageTitle,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _signOut(context),
            child: Text(
              "Sign Out",
              style: TextStyle(
                color: color.AppColor.homePageIcons,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: 1000,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.AppColor.gradientFirst,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Let's do some workout",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),

                // Today's workout
            Container(
              height: 400,
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.homePageTitle,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Make this part scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('workouts')
                            .where('event', isEqualTo: '800m')
                            .where('duration', isEqualTo: '3months')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No workout data available'));
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(snapshot.data!.docs.length, (index) {
                              var workout = snapshot.data!.docs[index];

                              // Convert 'day01' field as list to string
                              List<dynamic> nameList = workout['day01'];
                              String nameString = nameList.join('\n\n');

                              String eventString = workout['event'] ?? 'Unknown Event';
                              String durationString = workout['duration'] ?? 'Unknown Duration';

                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(nameString),
                                    subtitle: Text('Distance: $eventString, Duration: $durationString'),
                                  ),
                                  SizedBox(height: 8.0), // Small gap between list items
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tomorrow's workout
            Container(
              height: 400,
              margin: const EdgeInsets.only(top: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tommorow',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.homePageTitle,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Make this part scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('workouts')
                            .where('event', isEqualTo: '800m')
                            .where('duration', isEqualTo: '3months')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No workout data available'));
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(snapshot.data!.docs.length, (index) {
                              var workout = snapshot.data!.docs[index];

                              // Convert 'day01' field as list to string
                              List<dynamic> nameList = workout['day01'];
                              String nameString = nameList.join('\n\n');

                              String eventString = workout['event'] ?? 'Unknown Event';
                              String durationString = workout['duration'] ?? 'Unknown Duration';

                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(nameString),
                                    subtitle: Text('Distance: $eventString, Duration: $durationString'),
                                  ),
                                  SizedBox(height: 8.0), // Small gap between list items
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
            ),
          ),
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
