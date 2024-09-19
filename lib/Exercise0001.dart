import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart' as color;
import 'video_guide_Exersice.dart';
import 'video_guide_wormup.dart';  // Import the VideoGuidePage
import 'dart:convert';



class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}



class _ExercisePageState extends State<ExercisePage> {
  String sportEvent = ''; // Default value or you can set it to null initially
  String competitionDuration = ''; // Default value or set it to null
  List<dynamic> info = [];
  String? username;
  int? practicedDays;
  User? user = FirebaseAuth.instance.currentUser;
  String? workOut;
  String? workOut2;
  String day01 = "day01";  // Example placeholder, replace with actual workout
  String day02 = "day02";  // Example placeholder, replace with actual workout
  String day03 = "day03";  // Example placeholder, replace with actual workout
  String day04 = "day04";  // Example placeholder, replace with actual workout
  String day05 = "day05";  // Example placeholder, replace with actual workout
  String day06 = "day06";  // Example placeholder, replace with actual workout
  String day07 = "day07";


  // Function to get user's sportEvent and competitionDuration
  void getUserData() async {
  // Example Firestore query to get the user's event and duration from a user collection
  var userDoc = await FirebaseFirestore.instance.collection('users').doc('USER_ID').get();
  if (userDoc.exists) {
  setState(() {
  sportEvent = userDoc['sportEvent']; // Fetch 'event' field
  competitionDuration = userDoc['competitionDuration']; // Fetch 'competitionDuration' field
  });
  }
  }
  // Sign out function
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/signIn');
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _getpracticedDaysAndWorkouts();
    getUserData(); // Call this function to get user data when the screen initializes
  }


  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
      setState(() {
        info = json.decode(value);
      });
    });
  }

  Future<void> _getpracticedDaysAndWorkouts() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        practicedDays = (userDoc['practicedDays'] );
      });
      _getWorkouts();
      _getWorkoutsd2();
    }
  }

  Future<void> _getWorkouts() async {
    if (practicedDays != null) {
      int dayMod = (1 + practicedDays!) % 7;
      switch (dayMod) {
        case 1:
          workOut = day01;
          break;
        case 2:
          workOut = day02;
          break;
        case 3:
          workOut = day03;
          break;
        case 4:
          workOut = day04;
          break;
        case 5:
          workOut = day05;
          break;
        case 6:
          workOut = day06;
          break;
        case 0:
          workOut = day07;
          break;
      }
    }
  }

  Future<void> _getWorkoutsd2() async {
    if (practicedDays != null) {
      int dayMod = (1 + practicedDays!) % 7;
      switch (dayMod) {
        case 1:
          workOut2 = day02;
          break;
        case 2:
          workOut2 = day03;
          break;
        case 3:
          workOut2 = day04;
          break;
        case 4:
          workOut2 = day05;
          break;
        case 5:
          workOut2 = day06;
          break;
        case 6:
          workOut2 = day07;
          break;
        case 0:
          workOut2 = day01;
          break;
      }
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExerciseVideoGuidePage()),
                    );
                  },
                  child: Text("Go to Exercise Video Guide"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),

                  ),
                ),
                SizedBox(height: 16.0),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100, height: 50), // Set the desired width and height
                  child: ElevatedButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

                        FirebaseFirestore.instance.runTransaction((transaction) async {
                          DocumentSnapshot snapshot = await transaction.get(userDoc);

                          if (!snapshot.exists) {
                            throw Exception("User does not exist!");
                          }

                          int newPracticedDays = (snapshot.data() as Map<String, dynamic>)['practicedDays'] ?? 0;
                          newPracticedDays += 1;

                          // Update the practicedDays field
                          transaction.update(userDoc, {'practicedDays': newPracticedDays});
                        }).then((value) {
                          print("Practiced days updated!");
                          // Navigate to homepage
                          Navigator.pushReplacementNamed(context, '/home');
                        }).catchError((error) {
                          print("Failed to update practiced days: $error");
                        });
                      }
                    },
                    child: Text("done for today"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.zero, // Remove default padding
                      textStyle:
                      TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                          fontWeight: FontWeight.bold,),

                    ),
                  ),
                )
                ,
                // Today's workout
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

                      Expanded(
                        child: SingleChildScrollView(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('workouts')
                                .where('event', isEqualTo: sportEvent)
                                .where('duration', isEqualTo: competitionDuration)
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

                              // Use null-aware operator to handle the null case of workOut
                              String currentWorkOut = workOut ?? ''; // Provide a default value or handle this case

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(snapshot.data!.docs.length, (index) {
                                  var workout = snapshot.data!.docs[index];

                                  List<dynamic> nameList = workout[currentWorkOut] ?? []; // Use an empty list if workout[currentWorkOut] is null
                                  String nameString = nameList.join('\n\n');

                                  String eventString = workout['event'] ?? 'Unknown Event';
                                  String durationString = workout['duration'] ?? 'Unknown Duration';

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: ListTile(
                                      title: Text(nameString),
                                      subtitle: Text('Distance: $eventString, Duration: $durationString'),
                                    ),
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
                            .where('event', isEqualTo: sportEvent)
                            .where('duration', isEqualTo: competitionDuration)
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

                              // Convert 'day01' field (list) to string
                              List<dynamic> nameList = workout[workOut2!];
                              String nameString = nameList.join('\n\n');

                              String eventString = workout['event'] ?? 'Unknown Event';
                              String durationString = workout['duration'] ?? 'Unknown Duration';

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: ListTile(
                                  title: Text(nameString),
                                  subtitle: Text('Distance: $eventString, Duration: $durationString'),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    )
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
