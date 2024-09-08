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
  String username = "";
  String email = "";
  String sportEvent = "";
  String duration = "";
  String eventtype = "";
  String age = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
        username = data['username'];
        email = data['email'];
        sportEvent = data['sportEvent'];
        duration = data['duration'];
      });
    }
  }

  void updateUserData() async {
    // Validate user input before updating
    // ...

    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    await docRef.update({
      'username': username,
      'email': email,
      'sportEvent': sportEvent,
      'duration': duration,
      'age':age,
      'event type': eventtype
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



    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user == null) {
      // User is not logged in
      // Redirect to login screen or handle as needed
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
          child: Text("User not logged in"),
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
              // Allow scrolling for long content
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

                    controller: TextEditingController(text: username),
                    decoration: InputDecoration(

                      hintText: 'Username',

                    ),
                    onChanged: (value) => setState(() => username = value),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: email),
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    onChanged: (value) => setState(() => email = value),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: TextEditingController(text: sportEvent),

                    decoration: InputDecoration(
                      hintText:  '100M 200M 800M ',
                      //labelText:'$email',



                    ),
                    onChanged: (value) => setState(() => sportEvent = value),
                  ),
                  SizedBox(height: 20),

                  TextField(

                    controller: TextEditingController(text: duration),
                    decoration: InputDecoration(

                      hintText: 'Duration',
                    ),
                    onChanged: (value) => setState(() => duration = value),
                  ),
                  SizedBox(height: 20),

                  TextField(

                    controller: TextEditingController(text: age),
                    decoration: InputDecoration(

                      hintText: 'Age',
                    ),
                    onChanged: (value) => setState(() => age = value),
                  ),

                  SizedBox(height: 20),

                  TextField(

                    controller: TextEditingController(text: eventtype),
                    decoration: InputDecoration(

                      hintText: 'Event type',
                    ),
                    onChanged: (value) => setState(() => eventtype = value),
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
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //
          //
          //   child: Opacity(
          //     opacity: 0.7, // Adjust opacity level as needed
          //     child: Image.asset(
          //       'assets/running-7056590_1280.jpg', // Replace with your image path
          //       fit: BoxFit.cover,
          //       height: 250, // Adjust height as needed
          //     ),
          //   ),
          // ),
        ],

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set initial index
        onTap: (index) {
          // Handle navigation here based on index
          switch (index) {
            case 0:
            // Navigate to Home Page
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
            // Navigate to Exercise Page
              Navigator.pushNamed(context, '/exercise');
              break;
            case 2:
            // Navigate to Warm Up Page
              Navigator.pushNamed(context, '/warmUp');
              break;
            case 3:
            // Navigate to User Profile Page
              Navigator.pushNamed(context, '/userProfile');
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color:Colors.black,),
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
      ),
    );

  }
}
