import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart' as color;
import 'video_info.dart';

class HomePagee extends StatefulWidget {
  const HomePagee({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePagee> {
//declarer une list hashmap
  List<dynamic> info = [];

  //afficher to la liste avec foreach

  //afficher un element de la liste

  // if list vide
  _initData() {
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
      info = json.decode(value);
      if (info.length > 0) {
        setState(() {
          info = info;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackGround,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Training",
                  style: TextStyle(
                    color: color.AppColor.homePageTitle,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Icon(Icons.arrow_back_ios,
                    size: 20, color: color.AppColor.homePageIcons),
                SizedBox(width: 10),
                Icon(Icons.calendar_today_outlined,
                    size: 20, color: color.AppColor.homePageIcons),
                SizedBox(width: 15),
                Icon(Icons.arrow_forward_ios,
                    size: 20, color: color.AppColor.homePageIcons),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Training",
                  style: TextStyle(
                    color: color.AppColor.homePageSubtitle,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "Details",
                  style: TextStyle(
                    color: color.AppColor.homePageDetail,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Navigator.push(context , MaterialPageRoute(builder: (context)=> const VideoInfo()));
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: color.AppColor.homePageIcons,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.AppColor.gradienFirst.withOpacity(0.8),
                      color.AppColor.gradienSecond.withOpacity(0.9),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(80),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20,
                        color: color.AppColor.gradienSecond.withOpacity(0.2))
                  ]),
              child: Container(
                  padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Next Workout",
                            style: TextStyle(
                              fontSize: 16,
                              color: color.AppColor.homePageContainerTextSmall,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text("bipolaire Exercice",
                            style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.homePageContainerTextSmall,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text("And Yoga Workout",
                            style: TextStyle(
                              fontSize: 25,
                              color: color.AppColor.homePageContainerTextSmall,
                            )),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 20,
                                    color: color
                                        .AppColor.homePageContainerTextSmall,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("30 min",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: color.AppColor
                                            .homePageContainerTextSmall,
                                      )),
                                ],
                              ),
                              Expanded(child: Container()),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4, 8),
                                      blurRadius: 20,
                                      color: color.AppColor.gradienFirst,
                                    )
                                  ],
                                ),
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                            ]),
                      ])),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 30),
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(
                            "Assets/three.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(8, 10),
                              blurRadius: 40,
                              color: color.AppColor.gradienSecond
                                  .withOpacity(0.2)),
                          BoxShadow(
                              offset: Offset(-1, -5),
                              blurRadius: 10,
                              color:
                                  color.AppColor.gradienSecond.withOpacity(0.2))
                        ]),
                  ),
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 150, bottom: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(
                          "Assets/yogagd.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                      width: double.maxFinite,
                      height: 100,
                      margin: const EdgeInsets.only(right: 150, top: 40),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You are doing great",
                              style: TextStyle(
                                color: color.AppColor.homePageDetail,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "Keep it up\n",
                                  style: TextStyle(
                                    color: color.AppColor.homePagePlanColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(text: "stick to your plan"),
                                  ]),
                            )
                          ]))
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Area of focus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: color.AppColor.homePageTitle,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),

//pour afficher les images et les title dans la list info
            Expanded(
                child: OverflowBox(
              //bien afficher tous les images
              maxWidth: MediaQuery.of(context).size.width,

              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: (info.length.toDouble() / 2).toInt(),
                  itemBuilder: (_, i) {
                    //afficher image from list
                    int a = 2 * i;
                    int b = 2 * i + 1;

                    return Row(
                      children: [
                        Container(
                            height: 170,
                            width: (MediaQuery.of(context).size.width - 90) / 2,
                            margin: const EdgeInsets.only(
                                left: 30, bottom: 15, top: 15),
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(info[a]['img']),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 3,
                                      color: color.AppColor.gradienSecond
                                          .withOpacity(0.1)),
                                  BoxShadow(
                                      offset: Offset(-5, -5),
                                      blurRadius: 3,
                                      color: color.AppColor.gradienSecond
                                          .withOpacity(0.1)),
                                ]),
                            child: Center(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  info[a]['title'],
                                  style: TextStyle(
                                    color: color.AppColor.homePageDetail,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                        Container(
                            height: 170,
                            width: (MediaQuery.of(context).size.width - 90) / 2,
                            margin: const EdgeInsets.only(
                                left: 30, bottom: 15, top: 15),
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(info[b]['img']),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, 5),
                                      blurRadius: 3,
                                      color: color.AppColor.gradienSecond
                                          .withOpacity(0.1)),
                                  BoxShadow(
                                      offset: Offset(-5, -5),
                                      blurRadius: 3,
                                      color: color.AppColor.gradienSecond
                                          .withOpacity(0.1)),
                                ]),
                            child: Center(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  info[b]['title'],
                                  style: TextStyle(
                                    color: color.AppColor.homePageDetail,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    );
                  },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
