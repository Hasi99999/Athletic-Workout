import 'package:athletic/SignInScreen.dart';
import 'package:athletic/UserProfileEdit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:athletic/colors.dart' as color;

class UserProfile extends StatelessWidget {

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

        backgroundColor: Colors.red,
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }
    String userId = user.uid; // Get the current user ID
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.AppColor.gradientFirst, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error fetching data"));
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("No user data found"));
                  }
            
                  var userData = snapshot.data!.data() as Map<String, dynamic>; // Use '!' to assert non-nullability
                  return Center(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'User Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
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
                        Column(
                          children: [
            
                            // TextField(
                            //
                            //   decoration: InputDecoration(
                            //     labelText: ' Username: ${userData['username']}'
                            //
                            //     ,
                            //   ),
                            // ),
                            Text(
                              ' Username: ${userData['username']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                          // TextField(
                          //
                          //   decoration: InputDecoration(
                          //     labelText: ' Email:  ${userData['email']}'
                          //
                          //   ,
                          //   ),
                          // ),
                            Text(
                              ' Email:  ${userData['email']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            // TextField(
                            //
                            //   decoration: InputDecoration(
                            //     labelText: '  Sport Event: ${userData['sportEvent']}'
                            //
                            //     ,
                            //   ),
                            // ),
                            Text(
                              '  Sport Event: ${userData['sportEvent']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            // TextField(
                            //
                            //   decoration: InputDecoration(
                            //     labelText: '  Duration: ${userData['competitionDuration']}'
                            //
                            //     ,
                            //   ),
                            // ),
                            Text(
                              '  Duration: ${userData['competitionDuration']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),


                            SizedBox(height: 20),
                            Column(
                              children: [

                                // TextField(
                                //
                                //   // decoration:TextDecorationStyle(
                                //   //   labelText: ' Age: ${userData['age']}'
                                //   //
                                //   //   ,
                                //   // ),
                                // ),

                                Text(
                                  ' Age: ${userData['age']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            Column(
                              children: [

                                // TextField(
                                //
                                //   decoration: InputDecoration(
                                //     labelText: ' Event Type: ${userData['event type']}'
                                //
                                //     ,
                                //   ),
                                // ),
                                Text(
                                  ' Event Type: ${userData['event type']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),

                            SizedBox(height: 40),


                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserProfileEdit()),
                                );
                              },
                              child: Text('Edit Profile'),
                            )
                          ],
                        ),

                  );
                },
              ),
            ),
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Opacity(
          //     opacity: 0.7, // Adjust opacity level as needed
          //     child: Image.asset(
          //       'assets/running-7056590_1280.jpg', // Replace with your image path
          //       fit: BoxFit.cover,
          //       height: 200, // Adjust height as needed
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
