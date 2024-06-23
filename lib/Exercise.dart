import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:athletic/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart' as color;

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List<dynamic> info = [];
  String? username;
  DateTime? startingDay;
  int? daysLeft;
  User? user = FirebaseAuth.instance.currentUser;
  String? workOut;
  String? workOut2;
  String w01 = "w01";  // Example placeholder, replace with actual workout
  String w02 = "w02";  // Example placeholder, replace with actual workout
  String w03 = "w03";  // Example placeholder, replace with actual workout
  String w04 = "w04";  // Example placeholder, replace with actual workout
  String w05 = "w05";  // Example placeholder, replace with actual workout
  String w06 = "w06";  // Example placeholder, replace with actual workout
  String w07 = "w07";  // Example placeholder, replace with actual workout

  @override
  void initState() {
    super.initState();
    _initData();
    _getStartingDayAndWorkouts();
  }

  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
      setState(() {
        info = json.decode(value);
      });
    });
  }

  Future<void> _getStartingDayAndWorkouts() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        startingDay = (userDoc['Startingday'] as Timestamp).toDate();
        daysLeft = DateTime.now().difference(startingDay!).inDays;
      });
      _getWorkouts();
      _getWorkoutsd2();
    }
  }

  Future<void> _getWorkouts() async {
    if (daysLeft != null) {
      int dayMod = (1 + daysLeft!) % 7;
      switch (dayMod) {
        case 1:
          workOut = w01;
          break;
        case 2:
          workOut = w02;
          break;
        case 3:
          workOut = w03;
          break;
        case 4:
          workOut = w04;
          break;
        case 5:
          workOut = w05;
          break;
        case 6:
          workOut = w06;
          break;
        case 0:
          workOut = w07;
          break;
      }
    }
  }

  Future<void> _getWorkoutsd2() async {
    if (daysLeft != null) {
      int dayMod = (1 + daysLeft!) % 7;
      switch (dayMod) {
        case 1:
          workOut2 = w02;
          break;
        case 2:
          workOut2 = w03;
          break;
        case 3:
          workOut2 = w04;
          break;
        case 4:
          workOut2 = w05;
          break;
        case 5:
          workOut2 = w06;
          break;
        case 6:
          workOut2 = w07;
          break;
        case 0:
          workOut2 = w01;
          break;
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
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
                Container(
                  height: 350,
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: daysLeft != null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Today',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: color.AppColor.homePageTitle,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final workouts = snapshot.data?.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workouts?.length,
                              itemBuilder: (context, index) {
                                var workout = workouts![index];
                                List<dynamic> exercises = workout[workOut!] as List<dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: exercises.map((exercise) => Text(exercise.toString())).toList(),
                                );
                              },
                            );
                          } else {
                            return Text('Loading workouts...');
                          }
                        },
                      ),
                    ],
                  )
                      : Text('No data available'),
                ),
                Container(
                  height: 350,
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: daysLeft != null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tommorrow',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: color.AppColor.homePageTitle,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final workouts = snapshot.data?.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: workouts?.length,
                              itemBuilder: (context, index) {
                                var workout = workouts![index];
                                List<dynamic> exercises = workout[workOut2!] as List<dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: exercises.map((exercise) => Text(exercise.toString())).toList(),
                                );
                              },
                            );
                          } else {
                            return Text('Loading workouts...');
                          }
                        },
                      ),
                    ],
                  )
                      : Text('No data available'),
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
