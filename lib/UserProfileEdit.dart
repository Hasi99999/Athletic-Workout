import 'package:athletic/SignInScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:athletic/colors.dart' as color;

class UserProfileEdit extends StatefulWidget {
  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String userId = "";

  // Controllers for the TextFields
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController sportEventController;
  late TextEditingController competitionDurationController;
  late TextEditingController ageController;
  late TextEditingController eventTypeController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();

    // Initialize controllers
    usernameController = TextEditingController();
    emailController = TextEditingController();
    sportEventController = TextEditingController();
    competitionDurationController = TextEditingController();
    ageController = TextEditingController();
    eventTypeController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    usernameController.dispose();
    emailController.dispose();
    sportEventController.dispose();
    competitionDurationController.dispose();
    ageController.dispose();
    eventTypeController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    user = await _auth.currentUser;
    if (user != null) {
      userId = user!.uid;
      getUserData();
    }
  }

  void getUserData() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnap = await docRef.get();
    if (docSnap.exists) {
      final data = docSnap.data()!;
      setState(() {
        usernameController.text = data['username'];
        emailController.text = data['email'];
        sportEventController.text = data['sportEvent'];
        competitionDurationController.text = data['competitionDuration'];
        ageController.text = data['age'] ?? '';
        eventTypeController.text = data['event type'] ?? '';
      });
    }
  }

  void updateUserData() async {
    // Validate user input before updating
    // ...

    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await docRef.update({
      'username': usernameController.text,
      'email': emailController.text,
      'sportEvent': sportEventController.text,
      'competitionDuration': competitionDurationController.text,
      'age': ageController.text,
      'event type': eventTypeController.text
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
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
        body: Center(
          child: Text(""),
        ),
      );
    }

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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.AppColor.gradientFirst, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Edit User Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 60),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                    onChanged: (value) => setState(() => usernameController.text = value),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (value) => setState(() => emailController.text = value),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: sportEventController,
                    decoration: InputDecoration(
                      hintText: '100M 200M 800M',
                    ),
                    onChanged: (value) => setState(() => sportEventController.text = value),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: competitionDurationController,
                    decoration: InputDecoration(
                      hintText: 'Competition Duration',
                    ),
                    onChanged: (value) => setState(() => competitionDurationController.text = value),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      hintText: 'Age',
                    ),
                    onChanged: (value) => setState(() => ageController.text = value),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: eventTypeController,
                    decoration: InputDecoration(
                      hintText: 'Event Type',
                    ),
                    onChanged: (value) => setState(() => eventTypeController.text = value),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateUserData,
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set initial index
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
