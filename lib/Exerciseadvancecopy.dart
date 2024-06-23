import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:athletic/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart' as color;

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  List info = [];
  String? competitionDuration;
  String? username;
  String? startingDayStr;
  DateTime? startingDay;
  int? daysLeft;
  User? user = FirebaseAuth.instance.currentUser;
  String? speed;

  _initData() {
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
      setState(() {
        info = json.decode(value);
      });
    });
  }

  _getStartingDay() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        startingDay = (userDoc['Startingday'] as Timestamp).toDate();
        daysLeft = DateTime.now().difference(startingDay!).inDays;
      });
    }
  }

  _getStartingday() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        startingDayStr = userDoc['Startingday'];
      });
    }
  }

  _getWorkoutType() async {
    if (speed != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('workouts').doc(speed).get();
      String workoutId = userDoc['workoutId'];

      QuerySnapshot workoutQuery = await FirebaseFirestore.instance
          .collection('workouts')
          .where('workoutId', isEqualTo: workoutId)
          .get();

      if (workoutQuery.docs.isNotEmpty) {
        setState(() {
          speed = workoutQuery.docs.first['type'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _getStartingday();
    _getStartingDay();
    _getWorkoutType();
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              children: [
                Text(
                  "Let's do some work out",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Container(
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
                        '${1 + daysLeft!} Day',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: color.AppColor.homePageTitle,
                        ),
                      ),
                      speed != null
                          ? Text(
                        speed!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: color.AppColor.homePageTitle,
                        ),
                      )
                          : Text('Loading workout type...'),
                      SizedBox(height: 16.0),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
                        builder: (context, snapshot) {
                          List<Widget> workoutsWidgets = [];
                          if (snapshot.hasData) {
                            final workouts = snapshot.data?.docs.reversed.toSet();
                            for (var workouts in workouts!) {
                              final workoutWidget = Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(workouts['type']),
                                ],
                              );
                              workoutsWidgets.add(workoutWidget);
                            }
                          }
                          return
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: workoutsWidgets,
                            );
                        },
                      )
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
