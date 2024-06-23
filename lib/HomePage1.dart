import 'dart:convert';
import 'package:athletic/Exercise.dart';
import 'package:athletic/UserProfile.dart';
import 'package:athletic/WarmUp.dart';
import 'package:athletic/video_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'colors.dart' as color;
import 'package:athletic/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'WarmUp.dart';
import 'package:athletic/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  List info=[];
  _initData(){
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value){
     info= json.decode(value);
  });
}
  int _currentIndex = 0;

  final List<Widget> _pages = [
    VideoInfo(),
    ExercisePage(),
    WarmUpPage(),
    UserProfile(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState(){
    super.initState();
    _initData() ;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: color.AppColor.homePageBackground,
      body:
      Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top:70, left: 10,right: 10 ),


            child: Column(
              children: [
                Row(
                  children: [
                    Text("Athletic Workout",
                    style: TextStyle(
                      fontSize: 30,
                      color: color.AppColor.homePageTitle,
                      fontWeight: FontWeight.w700
                    ),
                    ),

                    Expanded(child:
                    Container()),
                    Expanded(child: Container()),
                    ElevatedButton(
                      onPressed: _signOut,
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                          color: color.AppColor.homePageIcons,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/userProfile');
                      },
                      child: Icon(
                        Icons.account_circle,
                        size: 30,
                        color: color.AppColor.homePageIcons,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 30,),
                Row(
                  children: [
                    Text("Athletic Workout",
                      style: TextStyle(
                          fontSize: 20,
                          color: color.AppColor.homePageSubtitle,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Expanded(child: Container()),
                      GestureDetector(
                          onTap: () {
                          Navigator.pushNamed(context, '/warmUp');
                          },
                      child: Text("WormUp",
                      style: TextStyle(
                          fontSize: 20,
                          color: color.AppColor.homePageDetail,

                        ),
                      ),
                      ),
                     SizedBox(width: 5,),
                    Icon(Icons.arrow_forward
                    ,size:20 ,
                    color: color.AppColor.homePageIcons,),

                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.AppColor.gradientFirst.withOpacity(0.8),
                        color.AppColor.gradientSecond
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(80)
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(10,10),
                        blurRadius: 20,
                        color: color.AppColor.gradientSecond
                      )
                    ]
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20,top: 20,right: 20, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Next Workout",
                          style: TextStyle(
                            fontSize: 16,
                            color: color.AppColor.homePageContainerTextSmall
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text("800 Meter workout",
                          style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.homePageContainerTextSmall
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 80,),
                                Icon(Icons.add_card_sharp,size: 20,color: color.AppColor.homePageContainerTextSmall,
                                ),
                                Text(
                                  "10 repetition",
                                  style: TextStyle(
                                  fontSize: 14,
                                  color: color.AppColor.homePageContainerTextSmall
                                ),
                                ),

                              ],
                            ),
                            Expanded(child: Container()),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.AppColor.gradientFirst,
                                      blurRadius: 10,
                                      offset: const Offset(4,8)
                                    )
                                  ]

                                ),

                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/exercise');
                                  },
                                  child: const Icon
                                    (Icons.play_circle,color: Colors.white,size: 60,),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),


                ) ,
                const SizedBox(height: 25,),
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 20),
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                              image: AssetImage(
                                   "assets/card.jpg"),
                            fit: BoxFit.fill,
                        ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 40,
                              offset: const Offset(8,10) ,
                              color: color.AppColor.gradientSecond.withOpacity(0.3)
                            ) ,
                             BoxShadow(
                               blurRadius: 10,
                               offset: const Offset(-1,-5) ,
                               color: color.AppColor.gradientSecond.withOpacity(0.3))
                          ]
                      ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(right: 200,bottom: 30, ),
                        decoration: BoxDecoration(
                          // color: Colors.redAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                              image: AssetImage(
                                   "assets/figure.png"),
                            // fit: BoxFit.fill,
                        ),
                      ),
                      ) ,
                      Container(
                        width: double.maxFinite,
                        height: 100,
                        // color: Colors.redAccent.withOpacity(0.2),
                        margin: const EdgeInsets.only(left: 150,top: 50),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You are doing well" ,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: color.AppColor.homePageDetail
                              ),
                            ) ,
                            SizedBox(height: 10,),
                            RichText(text: TextSpan(
                              text: "keep it up\n" ,
                              style: TextStyle(
                                color: color.AppColor.homePagePlanColor,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "stick to your workout"
                                )
                              ]

                            )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [

                    Text("Event",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.homePageTitle
                    ),)
                  ],
                ),
                Expanded(child: OverflowBox(maxWidth: MediaQuery.of(context).size.width,
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                      itemCount: (info.length.toDouble()/2).toInt(),//2
                      itemBuilder:(_, i)
                    {
                      int a = 2*i;
                      int b = 2*i +1;
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            height: 170,
                            width: (MediaQuery.of(context).size.width-90)/2,
                            margin: const EdgeInsets.only(left: 30, bottom: 15, right: 15, top: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage    (
                                image: AssetImage(
                                 info[a]['img']
                                )
                              ),
                              boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(5,5),
                                      color: color.AppColor.gradientSecond.withOpacity(0.1)
                                    ),
                                BoxShadow(
                                  blurRadius: 3,
                                  offset: Offset(-5,-5),
                                  color: color.AppColor.gradientSecond.withOpacity(0.1)
                                )
                              ]
                            ),
                            child: Center
                              (
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  info[a]["title"],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: color.AppColor.homePageDetail
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5),
                            height: 170,
                            width: (MediaQuery.of(context).size.width-90)/2,
                            margin: const EdgeInsets.only(left: 15, bottom: 15, right: 30, top: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage    (
                                    image: AssetImage(
                                        info[b]['img']
                                    )
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(5,5),
                                      color: color.AppColor.gradientSecond.withOpacity(0.1)
                                  ),
                                  BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(-5,-5),
                                      color: color.AppColor.gradientSecond.withOpacity(0.1)
                                  )
                                ]
                            ),
                            child: Center
                              (
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  info[b]["title"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: color.AppColor.homePageDetail
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],

                      ) ;
                    }),
                  ),
                )
                )

              ],

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
