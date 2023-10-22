import 'dart:math';
import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/chatbot/api_services.dart';
import 'package:psychoday/screens/chatbot/chat_model.dart';
import 'package:psychoday/screens/chatbot/colors.dart';
import 'package:psychoday/screens/chatbot/testResult.dart';
import 'package:psychoday/screens/chatbot/tts.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import '../../main.dart';
import '../listDoctor/pages/home_page.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  var text = "Hold the button and start speaking";
  var isListening = false;
  var isButtonDisabled = true;
  var initialMessage = false;
  var askedQuestion = "";
  var SymptomsJson;
  var symptomIndex = 0;
  var FirstAnswer = false;
  var TestEnded = false;

  var angryPercentage;
  var disgustedPercentage;
  var fearfulPercentage;
  var happyPercentage;
  var neutralPercentage;
  var sadPercentage;
  var surprisedPercentage;

  List<double> angryPercentageList = [];
  List<double> disgustedPercentageList = [];
  List<double> fearfulPercentageList = [];
  List<double> happyPercentageList = [];
  List<double> neutralPercentageList = [];
  List<double> sadPercentageList = [];
  List<double> surprisedPercentageList = [];
  List<int> questionlist = [];

  final List<ChatMessage> messages = [];

  late String _user ="";
  //actions

  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');

    setState(() {
      _user = id_user!;
    });
  }

  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  var manic_symptoms = {
    "elevated mood for more than one week": -1,
    "elevated mood nearly everyday": -1,
    "Inflated self-esteem or grandiosity": -1,
    "Decreased need for sleep": -1,
    "More talkative than usual or pressure to keep talking": -1,
    "Flight of ideas or subjective experience that thoughts are racing": -1,
    "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)":
        -1,
    "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation":
        -1,
    "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).":
        -1,
    "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.":
        -1,
    "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.":
        -1
  };
  var welcome_msg2 = "whatever";
  Timer? _timer;
  var welcome_msg =
      "Hello! Before we begin, I want to assure you that all of our conversations are confidential. Anything you share with me will be kept private and will not be shared with anyone else. My purpose is to help you identify and manage any manic symptoms you may be experiencing. So please feel free to share openly and honestly with me. I am here to help you.";

  int angryCounter = 0;

  int disgustedCounter = 0;
  int fearfulCounter = 0;
  int happyCounter = 0;
  int neutralCounter = 0;
  int sadCounter = 0;
  int surprisedCounter = 0;
  int totalemo = 0;
  void initState() {
    super.initState();
     getUserConnected();
    loadCamera();
    loadModel();
   

    Timer.periodic(Duration(seconds: 1), (timer) {
      // Check the value of output and increment the corresponding counter
      switch (output) {
        case '0 angry':
          setState(() {
            angryCounter++;
          });
          break;
        case '1 disgusted':
          setState(() {
            disgustedCounter++;
          });
          break;
        case '2 fearful':
          setState(() {
            fearfulCounter++;
          });
          break;
        case '3 happy':
          setState(() {
            happyCounter++;
          });
          break;
        case '4 neutral':
          setState(() {
            neutralCounter++;
          });
          break;
        case '5 sad':
          setState(() {
            sadCounter++;
          });
          break;
        case '6 surprised':
          setState(() {
            surprisedCounter++;
          });
          break;
        default:
          // Handle any other values of output if needed
          break;
      }

      var totalemos = angryCounter +
          disgustedCounter +
          fearfulCounter +
          happyCounter +
          neutralCounter +
          sadCounter +
          surprisedCounter;
      setState(() {
        totalemo = totalemos;
      });

      var angryPercentagel = (angryCounter / totalemo) * 100;
      var disgustedPercentagel = (disgustedCounter / totalemo) * 100;
      var fearfulPercentagel = (fearfulCounter / totalemo) * 100;
      var happyPercentagel = (happyCounter / totalemo) * 100;
      var neutralPercentagel = (neutralCounter / totalemo) * 100;
      var sadPercentagel = (sadCounter / totalemo) * 100;
      var surprisedPercentagel = (surprisedCounter / totalemo) * 100;
      setState(() {
        angryPercentage = angryPercentagel;
        disgustedPercentage = disgustedPercentagel;
        fearfulPercentage = fearfulPercentagel;
        happyPercentage = happyPercentagel;
        neutralPercentage = neutralPercentagel;
        sadPercentage = sadPercentagel;
        surprisedPercentage = surprisedPercentagel;
      });
      print("angryPercentage: " +
          angryPercentage.toString() +
          "% " +
          angryCounter.toString() +
          "totalemo" +
          totalemo.toString());
      print("disgustedPercentage: " + disgustedPercentage.toString() + "%");
      print("fearfulPercentage: " + fearfulPercentage.toString() + "%");
      print("happyPercentage: " + happyPercentage.toString() + "%");
      print("neutralPercentage: " + neutralPercentage.toString() + "%");
      print("sadPercentage: " + sadPercentage.toString() + "%");
      print("surprisedPercentage: " + surprisedPercentage.toString() + "%");
    });

    // Add welcome message to messages list when app is started

    messages.add(ChatMessage(text: welcome_msg, type: ChatMessageType.bot));

    // Speak the welcome message

    Future.delayed(const Duration(milliseconds: 500), () {
      print("start ");
      print(isButtonDisabled);

      print("start 2 ");
      print(isButtonDisabled);
      Future.delayed(const Duration(milliseconds: 500), () {
        TextToSpeech.speaks(welcome_msg).whenComplete(() {
          print("midair");
          print(isButtonDisabled);

          setState(() {
            isButtonDisabled = false;
          });
          print("after");
          print(isButtonDisabled);
        });
      });
      /*  TextToSpeech.speak(welcome_msg).whenComplete(() {
        
      });*/
      print("start ");
      print(isButtonDisabled);
    });
  }

  loadCamera() {
    cameraController = CameraController(cameras![1], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 7,
          threshold: 0.1,
          asynch: true);

      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "Assets/model.tflite", labels: "Assets/labels.txt");
  }

  @override
  @override
  Widget build(BuildContext context) {

    


    var welcome_msg =
        "Hello! Before we begin, I want to assure you that all of our conversations are confidential. Anything you share with me will be kept private and will not be shared with anyone else. My purpose is to help you identify and manage any manic symptoms you may be experiencing. So please feel free to share openly and honestly with me. I am here to help you.";

        //shared
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: isButtonDisabled
              ? null
              : (details) async {
                  print("tap down");
                  if (!isListening) {
                    print(initialMessage);

                    /*
                      initialMessage = true;
                      messages.add(ChatMessage(
                          text: welcome_msg, type: ChatMessageType.bot));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speak(welcome_msg);
                      });
                      setState(() {
                        initialMessage = true;
                      });*/

                    var available = await speechToText.initialize();
                    print(available);
                    if (available) {
                      print("yes available");
                      setState(() {
                        isListening = true;

                        speechToText.listen(
                          onResult: (result) {
                            setState(() {
                              text = result.recognizedWords;
                            });
                            print("done recording");
                            print(text);
                          },
                        );
                        print("done ");
                      });
                    }
                  }
                },
          onTapUp: isButtonDisabled
              ? null
              : (details) async {
                  print("tap up");
                  setState(() {
                    isListening = false;
                  });

                  await speechToText.stop();

                  if (text.isNotEmpty &&
                      text != "Hold the buttom and start speaking") {
                    setState(() {
                      messages.add(
                          ChatMessage(text: text, type: ChatMessageType.user));
                    });
                    if (FirstAnswer == false) {
                      print("asked question is empty");
                      var prompt = 'analyse this text "' +
                          text +
                          '" and change the values of this json from -1 to 1 if the symptoms are present in the text or keep them -1 if you can not confirm if the symptoms are present (return the JSON only)  {"elevated mood for more than one week": -1,"elevated mood nearly everyday": -1,"Inflated self-esteem or grandiosity": -1,"Decreased need for sleep": -1,"More talkative than usual or pressure to keep talking": -1,"Flight of ideas or subjective experience that thoughts are racing": -1,"Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)":    -1,"Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation":-1,"Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).":-1,"The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.":-1,"The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.":-1 } \n';
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      // msg = msg.trim();
                      var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                      setState(() {
                        FirstAnswer = true;
                      });
                    } else if (symptomIndex == 1) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  either it says a period of time that is more than a week or not, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["elevated mood for more than one week"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });

                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(1);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });

                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 2) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify   if the person has an elevated mood for most of the day or not , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["elevated mood nearly everyday"] = int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(2);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 3) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has inflated self-esteem or grandiosity , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, considering this answer  :"' +
                              text +
                              "'";
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      print("trimed msg");

                      print(msg);
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Inflated self-esteem or grandiosity"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(3);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 4) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has less need for sleep than the average person , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Decreased need for sleep"] = int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(4);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 5) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he is more talktive than usual or pressure to keep talking , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["More talkative than usual or pressure to keep talking"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(5);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 6) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has flight of ideas or subjective experience that thoughts are racing, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Flight of ideas or subjective experience that thoughts are racing"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(6);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 7) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  if he suffers from distractibility analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(7);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 8) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  any increase in goal-directed activity (either socially, at work or school, or sexually), analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(8);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 9) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  any Excessive involvement in activities that have a high potential for painful consequences, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(9);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 10) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify if The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });

                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(10);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 11) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  if the episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      setState(() {
                        angryPercentageList.add(angryPercentage);
                        disgustedPercentageList.add(disgustedPercentage);
                        fearfulPercentageList.add(fearfulPercentage);
                        happyPercentageList.add(happyPercentage);
                        neutralPercentageList.add(neutralPercentage);
                        sadPercentageList.add(sadPercentage);
                        surprisedPercentageList.add(surprisedPercentage);
                        questionlist.add(11);

                        angryCounter = 0;
                        disgustedCounter = 0;

                        fearfulCounter = 0;
                        happyCounter = 0;
                        neutralCounter = 0;
                        sadCounter = 0;
                        surprisedCounter = 0;
                        totalemo = 0;
                      });
                      print("after");
                      print(SymptomsJson);
                    }
                    // Index attribute is used to keep track of the symptoms

                    if (SymptomsJson["elevated mood for more than one week"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 1;
                      });
                      List<String> questions = [
                        "For how long have you been dealing with this mood?",
                        "How long have you been feeling excessively energetic, excited, or euphoric?",
                     //   "How long has it been since you first noticed these symptoms of mania in your life?",
                       // "Can you recall any specific periods in your life when you experienced manic symptoms for an extended period of time?",
                        "How long have you been experiencing symptoms such as racing thoughts, decreased need for sleep, or grandiosity?",
                        "Can you describe the longest period of time you have experienced manic symptoms, and how long ago was that?",
                       // "How long have you been feeling irritable or agitated?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson["elevated mood nearly everyday"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 2;
                      });
                      List<String> questions = [
                        "Can you describe how you feel on an average day, in terms of your mood and energy level?",
                        "Do you feel like your mood is consistently elevated, or does it fluctuate throughout the day?",
                       // "Have you noticed any triggers or patterns to your elevated moods, such as particular times of day or certain situations?",
                        "Do you feel abnormally upbeat or happy for most of the day, nearly every day?",
                        "On average, how many hours each day do you feel like you are in an elevated mood?",
                        "How often do you feel overly happy or elated during the day?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Inflated self-esteem or grandiosity"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 3;
                      });
                      List<String> questions = [
                        "How do you feel about yourself compared to others around you?",
                        "Have you been feeling more confident or empowered than usual lately?",
                        "Can you describe a recent experience where you felt particularly powerful or invincible?",
                        "What are your thoughts on your own intelligence or abilities?",
                        "How have your goals or aspirations changed recently?",
                     //   "How have people been reacting to your ideas or plans lately?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson["Decreased need for sleep"] == -1) {
                      setState(() {
                        symptomIndex = 4;
                      });
                      List<String> questions = [
                        "Have you been having trouble falling asleep at night? Or are you finding that you need less sleep than usual?",
                        "Do you find that your mind is racing at night when you're trying to sleep?",
                        "Have you noticed any changes in your sleep patterns, such as sleeping less or experiencing insomnia?",
                        //"How many hours of sleep did you get last night?",
                        "Have you had any trouble falling or staying asleep?",
                        "Do you feel like you could function well without much sleep?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "More talkative than usual or pressure to keep talking"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 5;
                      });
                      List<String> questions = [
                        "Do you find it hard to stop talking?",
                       // "Have you friends or family commented on the way you are talking?",
                        "Do you find yourself talking more than usual?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Flight of ideas or subjective experience that thoughts are racing"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 6;
                      });
                      List<String> questions = [
                        ///
                        ///
                        ///
                        "Do you find your thoughts racing?",
                        "Do you find it difficult to keep track of your thought?",
                        "Do your thoughts jump from place to place that makes it difficult for you to keep track of them?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 7;
                      });
                      List<String> questions = [
                        "Do you find yourself getting easily distracted by things around you?",
                        "Have you noticed any changes in your ability to concentrate or stay focused lately?",
                        "Do you have difficulty completing tasks because you get sidetracked by other things along the way?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 8;
                      });
                      List<String> questions = [


                        //



                     //   "Have you taken on any new activities lately?",
                        "Have you come across any brilliant ideas lately?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."] ==
                        -1) {
                      setState(() {
                        symptomIndex = 9;
                      });
                      List<String> questions = [


                        "Have you been doing things that are out of character for you ?",
                        "Have you done things that were unusual for you or that other people might have thought were excessive, foolish, or risky?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."] ==
                        -1) {


                      setState(() {
                        symptomIndex = 10;
                      });
                      List<String> questions = [

                        //** */
                        "Have you experienced any significant conflicts with others or disruptions to your social life recently?",



                        "Have you noticed any changes in your ability to function at work or in your relationships?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."] ==
                        -1) {
                      print("ija hne");
                      print(SymptomsJson[
                          "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."]);
                      setState(() {
                        symptomIndex = 11;
                      });
                      List<String> questions = [
                        "Have you used any drugs or alcohol lately?",
                        "Have you been diagnosed with any medical conditions that could be causing these symptoms?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    }
                    if (SymptomsJson["elevated mood for more than one week"] !=
                            -1 &&
                        SymptomsJson["elevated mood nearly everyday"] != -1 &&
                        SymptomsJson["Inflated self-esteem or grandiosity"] !=
                            -1 &&
                        SymptomsJson["Decreased need for sleep"] != -1 &&
                        SymptomsJson[
                                "More talkative than usual or pressure to keep talking"] !=
                            -1 &&
                        SymptomsJson[
                                "Flight of ideas or subjective experience that thoughts are racing"] !=
                            -1 &&
                        SymptomsJson[
                                "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"] !=
                            -1 &&
                        SymptomsJson[
                                "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"] !=
                            -1 &&
                        SymptomsJson[
                                "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."] !=
                            -1 &&
                        SymptomsJson[
                                "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."] !=
                            -1 &&
                        SymptomsJson[
                                "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."] !=
                            -1) {
                      messages.add(ChatMessage(
                          text: "Test completed", type: ChatMessageType.bot));

                      Uri addUri =
                          Uri.parse("$BASE_URL/symptoms/add");
                      Map<String, dynamic> symptomsObject = {
                        "idUser": _user, //user connecter
                        "elevated_mood_day": SymptomsJson[
                            "elevated mood for more than one week"],
                        "elevated_mood_week":
                            SymptomsJson["elevated mood nearly everyday"],
                        "inflated_self_esteem":
                            SymptomsJson["Inflated self-esteem or grandiosity"],
                        "decreased_sleep":
                            SymptomsJson["Decreased need for sleep"],
                        "talkative_or_pressure_to_talk": SymptomsJson[
                            "More talkative than usual or pressure to keep talking"],
                        "racing_thoughts": SymptomsJson[
                            "Flight of ideas or subjective experience that thoughts are racing"],
                        "distractibility": SymptomsJson[
                            "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"],
                        "increased_activity": SymptomsJson[
                            "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"],
                        "risky_behavior": SymptomsJson[
                            "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."],
                        "severe_mood_disturbance": SymptomsJson[
                            "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."],
                        "not_due_to_substance_or_medical_condition": SymptomsJson[
                            "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."],
                        "angrypercentage": angryPercentageList,
                        "sadpercentage": sadPercentageList,
                        "happypercentage": happyPercentageList,
                        "neutralpercentage": neutralPercentageList,
                        "surprisepercentage": surprisedPercentageList,
                        "fearpercentage": fearfulPercentageList,
                        "disgustpercentage": disgustedPercentageList,
                        "questions": questionlist
                      };
                      print(symptomsObject);
                      //data to send
                      Map<String, String> headers = {
                        "Content-Type": "application/json",
                      };

                      //request
                      http
                          .post(addUri,
                              headers: headers,
                              body: json.encode(symptomsObject))
                          .then((response) async {
                        if (response.statusCode == 201) {
                          print("Response status: ${response.statusCode}");
                          var jsonSchedule = response.body;
                          print(jsonSchedule);
                        } else if (response.statusCode == 401) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Information"),
                                content: const Text("Error!"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Dismiss"))
                                ],
                              );
                            },
                          );
                        }
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speak("Test completed");
                      });

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  TestResult(id_patient: _user ,)));
                    } else {
                      /*
                      
                   
                    */

                      setState(() {
                        messages.add(ChatMessage(
                            text: askedQuestion, type: ChatMessageType.bot));
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speaks(askedQuestion).whenComplete(() {
                          print("midair");
                          print(isButtonDisabled);

                          setState(() {
                            isButtonDisabled = false;
                          });
                          print("after");
                          print(isButtonDisabled);
                        });
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Failed to process. Try again")));
                  }
                },
                
          //child: ,
        ),
      ),
/*
      appBar: AppBar(
        leading: const Icon(
          Icons.sort_rounded,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          'Psychoday',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),*/
      body: Container(
         decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/bot-wallpaper.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
        
        child: Column(
          /************************** */

          children: [
            Padding(
              padding: EdgeInsets.only(
                  /* left: MediaQuery.of(context).size.width * 0.1,*/ top:
                      20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.33,
                child: !cameraController!.value.isInitialized
                    ? Container()
                    : AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      ),
              ),
            ),
            /******************************* */


            /*
            Image.asset(
              'Assets/Psychoday.gif',
              width: 100,
              height: 100,
            ),
            */
            const Text(
              'Hello there!',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 175, 204),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: chatBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var chat = messages[index];

                  return chatBubble(chattext: chat.text, type: chat.type);
                },
              ),
            )),
            const SizedBox(height: 12),
            CircleAvatar(
              backgroundColor: isButtonDisabled ? Colors.grey : bgColor,
              radius: 35,
              child: Icon(isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: textColor,
          child: type == ChatMessageType.bot
              ? Image.asset('Assets/psychoday.png')
              : const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot ? bgColor : Colors.blue,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: type == ChatMessageType.bot ? textColor : chatBgColor,
                fontWeight: type == ChatMessageType.bot
                    ? FontWeight.w600
                    : FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
