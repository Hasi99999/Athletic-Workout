import 'package:athletic/UserProfile.dart';
import 'package:athletic/video_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'AuthenticationState.dart';
import 'firebase_options.dart';
import 'HomePage.dart';
import 'SignInScreen.dart';
import 'SignUpScreen.dart';
import 'UserProfile.dart';
import 'Exercise.dart';
import 'WarmUp.dart';
import 'video_guide_wormup.dart';  // Import the VideoGuidePage


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      //home:VideoInfo(),
      home:AuthStateWidget(),
      routes: {
        '/home': (context) => HomePage(),
        '/signIn': (context) => SignInScreen(),
        '/userProfile': (context) => UserProfile(),
        '/exercise': (context) => ExercisePage(),
        '/warmUp': (context) => WarmUpPage(),
        '/videoGuide': (context) => VideoGuidePage(),

      },
    );
  }
}
