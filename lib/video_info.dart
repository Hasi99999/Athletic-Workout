import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart' as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.AppColor.gradientFirst.withOpacity(0.8),
                color.AppColor.gradientSecond.withOpacity(0.9)
              ],
              begin: const FractionalOffset(0.0, 0.4),
              end: Alignment.topRight,

            )
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 70,left: 30,right: 30),
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_back_ios_sharp,size: 20,
                        color: color.AppColor.secondPageIconColor,),
                        Expanded(child: Container()),
                        Icon(Icons.info_outline_rounded,size: 20,
                          color: color.AppColor.secondPageIconColor,)
                      ],
                    ),
                    SizedBox(height: 30,),
                    Text("Next Workout",
                      style: TextStyle(
                          fontSize: 16,
                          color: color.AppColor.secondPageTitleColor
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text("800 Meter workout",
                      style: TextStyle(
                          fontSize: 25,
                          color: color.AppColor.secondPageTitleColor
                      ),
                    ),
                    SizedBox(height: 50,),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          height:30,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  color.AppColor.secondPageContainerGradient1stColor,
                                  color.AppColor.secondPageContainerGradient2ndColor
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              )
                            ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_card_sharp,size: 20,
                                  color: color.AppColor.secondPageIconColor,),
                              SizedBox(width: 5,),
                              Text(
                                  "10 Repetition",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: color.AppColor.secondPageIconColor,
                                ),
                              )
                            ],
                          ),

                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70)
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        Text(
                          "Circuit 1",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.circuitsColor,
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(Icons.loop, size: 30,
                            color: color.AppColor.loopColor,),
                            SizedBox(width: 5,),
                            Text(
                              "3sets Each",
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.setsColor,
                              ),
                            )
                          ],
                        ),
                        SizedBox(width: 30,)
                      ],
                    )
                  ],
                ),
              ))
            ],
          )
        )

    );
  }
}
