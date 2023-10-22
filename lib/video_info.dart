import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'colors.dart' as color;

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  List<dynamic> videoInfo = [];
  bool _playArea = false;
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  //afficher to la liste avec foreach

  //afficher un element de la liste

  // if list vide
  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
      print(videoInfo);
      if (videoInfo.length > 0) {
        setState(() {
          videoInfo = videoInfo;
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
        body: Container(
            decoration: _playArea == false
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.AppColor.gradienFirst.withOpacity(0.9),
                        color.AppColor.gradienSecond,
                      ],
                      begin: const FractionalOffset(0.0, 0.4),
                      end: Alignment.topRight,
                    ),
                  )
                : BoxDecoration(color: color.AppColor.gradienSecond),
            child: Column(
              children: [
                _playArea == false
                    ? Container(
                        padding:
                            const EdgeInsets.only(top: 70, left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      size: 20,
                                      color: color.AppColor
                                          .secondPageContainerGradient1stColor
                                          .withOpacity(0.8)),
                                ),
                                Expanded(child: Container()),
                                Icon(Icons.info_outline,
                                    size: 20,
                                    color: color.AppColor
                                        .secondPageContainerGradient1stColor
                                        .withOpacity(0.8)),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text("bipolaire Exercice",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "And Yoga Workout",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 90,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        color.AppColor.secondPageIconColor
                                            .withOpacity(0.1),
                                        color.AppColor.secondPageIconColor
                                            .withOpacity(0.1),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        size: 20,
                                        color:
                                            color.AppColor.secondPageIconColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "30 min",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: color
                                              .AppColor.secondPageIconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 250,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        color.AppColor.secondPageIconColor
                                            .withOpacity(0.1),
                                        color.AppColor.secondPageIconColor
                                            .withOpacity(0.1),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.handyman_outlined,
                                        size: 20,
                                        color:
                                            color.AppColor.secondPageIconColor,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Resistent band, Psychoday",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: color
                                              .AppColor.secondPageIconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(children: [
                          Container(
                              height: 100,
                              padding: const EdgeInsets.only(
                                  top: 50, left: 30, right: 30),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      debugPrint("tapped");
                                    },
                                    child: Icon(Icons.arrow_back_ios,
                                        size: 20,
                                        color:
                                            color.AppColor.secondPageIconColor),
                                  ),
                                  Expanded(child: Container()),
                                  Icon(Icons.info_outline,
                                      size: 20,
                                      color:
                                          color.AppColor.secondPageIconColor),
                                ],
                              )),
                          _playView(context),
                          _controlView(context),
                        ]),
                      ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(70),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Circuit 1: Legs Toning",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: color.AppColor.circuitsColor,
                              ),
                            ),
                            Expanded(child: Container()),
                            Row(
                              children: [
                                Icon(
                                  Icons.loop_outlined,
                                  size: 20,
                                  color: color.AppColor.loopColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "3sets",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: color.AppColor.setsColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(child: _listView()),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }

  Widget _controlView(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      color: color.AppColor.gradienSecond,
      child: Row( 
        children: [
          FloatingActionButton(
            onPressed: () async {},
            child: Icon(
              Icons.fast_rewind,
              size: 36,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              if (_isPlaying) {
                _controller?.pause();
                setState(() {
                  _controller?.play();
                });
              }
            },
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              size: 36,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            onPressed: () async {},
            child: Icon(
              Icons.fast_forward,
              size: 36,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _playView(BuildContext context) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
            child: Text(
              "Preparing...",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ));
    }
  }

  void _onControllerUpdate() async {
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller can not be initialised");
      return;
    }
    final playing = controller.value.isPlaying;
    _isPlaying = playing;
  }

  _onTapVideo(int index) {
    final controller =
        VideoPlayerController.network(videoInfo[index]["videoUrl"]);
    _controller = controller;
    setState(() {});
    controller
      ..initialize().then((_) {
        controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
      });
  }

  _listView() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        itemCount: videoInfo.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              _onTapVideo(index);
              debugPrint(index.toString());
              setState(() {
                if (_playArea == false) {
                  _playArea = true;
                }
              });
            },
            child: _buildCard(index),
          );
        });
  }

  _buildCard(int index) {
    return Container(
      height: 135,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage(videoInfo[index]["thumbnail"]),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo[index]["title"],
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoInfo[index]["duration"],
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(children: [
            Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFFeaeefc),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "15 rest",
                  style: TextStyle(color: Color(0xFF839fed)),
                ),
              ),
            ),
            Row(children: [
              for (int i = 0; i < 70; i++)
                i.isEven
                    ? Container(
                        width: 3,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Color(0xFF839fed),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    : Container(
                        width: 3,
                        height: 1,
                        color: Colors.white,
                      ),
            ]),
          ])
        ],
      ),
    );
  }
}
