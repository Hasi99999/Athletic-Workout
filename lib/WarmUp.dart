import 'package:athletic/SignInScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart' as color;
import 'video_guide_wormup.dart';  // Import the VideoGuidePage

class WarmUpPage extends StatelessWidget {
  const WarmUpPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  Future<String?> getCurrentUserEventType() async {
    try {
      // Get the current logged-in user ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        // If no user is logged in, return null or handle accordingly
        return null;
      }

      // Reference to the Firestore document for the current user
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the user document exists
      if (userDoc.exists) {
        // Retrieve the 'eventType' field from the user's document
        String? eventType = userDoc.get('event type');
        return eventType;
      } else {
        // If the document doesn't exist, handle accordingly
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching user event type: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _getFastWorkouts(String? eventType) async {
    try {
      // Query Firestore with the user's event type
      var querySnapshot = await FirebaseFirestore.instance
          .collection('wormups')
          .where('type', isEqualTo: eventType)
          .get();

      List<Map<String, dynamic>> workouts = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return workouts;
    } catch (e) {
      throw Exception('Failed to load workouts: $e');
    }
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
        height: double.infinity,
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
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Warmup First",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoGuidePage()),
                      );
                    },
                    child: Text("Go to Warmup Video Guide"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: FutureBuilder<String?>(
                      future: getCurrentUserEventType(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          String? eventType = snapshot.data;
                          if (eventType == null) {
                            return Center(child: Text('No event type found.'));
                          } else {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: _getFastWorkouts(eventType),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text('No fast workouts found.'));
                                } else {
                                  List<Map<String, dynamic>> workouts = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: workouts.length,
                                    itemBuilder: (context, index) {
                                      var workoutField = workouts[index];
                                      List<dynamic> exercises = (workoutField['dynamic wormup'] is List<dynamic>)
                                          ? workoutField['dynamic wormup'] as List<dynamic>
                                          : []; // Use an empty list if dynamicwormups is not a List

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercises.join('\n\n'), // Join exercises with newline
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 16.0), // Optional: space between different workouts
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Set initial index to Warm Up Page
        onTap: (index) {
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
