import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../utils/constants.dart';
import '../../utils/style.dart';
import '../listDoctor/pages/home_page.dart';

class TestResult extends StatefulWidget {
  const TestResult({super.key,required this.id_patient});
final String id_patient;
  @override
  State<TestResult> createState() => _TestResultState();
}

class _TestResultState extends State<TestResult> {

int scode=0;
  var secondary_symptoms;
  var primary_symptoms;
  var message = "";

 List<dynamic> symptoms = [];
    Future<void> getSymptomsByUser() async {
    final String url = "$BASE_URL/symptoms/getbyuser";
    final String idUser = widget.id_patient;


    try {
      final response = await http.get(Uri.parse('$url/$idUser'));
      if (response.statusCode == 200) {
        // Prints the list of symptoms retrieved
        setState(() {
          scode=200;
          symptoms = json.decode(response.body);

          secondary_symptoms = symptoms[0]['inflated_self_esteem'] +
          symptoms[0]['decreased_sleep'] +
          symptoms[0]['talkative_or_pressure_to_talk'] +
          symptoms[0]['racing_thoughts'] +
          symptoms[0]['distractibility'] +
          symptoms[0]['increased_activity'] +
          symptoms[0]['risky_behavior'];
          primary_symptoms = symptoms[0]['elevated_mood_day']+ symptoms[0]['elevated_mood_week']+symptoms[0]['severe_mood_disturbance']+symptoms[0]['not_due_to_substance_or_medical_condition'];
          
     
        });
      } else {
        setState(() {
          scode=0;
        });
      }
      if(primary_symptoms ==4 && secondary_symptoms>=3 ){
message = "Based on the severity and duration of your symptoms, it is highly likely that you are experiencing manic symptoms. We urge you to seek immediate professional help to manage your symptoms and receive appropriate treatment";
      }else if( primary_symptoms>=2  &&  secondary_symptoms>=3)
      {message = "It is probable that you have manic symptoms: Based on the information you have provided, it is possible that you are experiencing symptoms of mania. We recommend seeking advice from a medical professional to further assess your condition and receive appropriate treatment.";}
      else if  (primary_symptoms < 2 ){
        message = "It is very unlikely that you have manic symptoms: Based on the information you have provided, it does not seem like you are experiencing symptoms of mania. However, if you are concerned about your mental health, we recommend seeking advice from a medical professional";
      }
    } catch (e) {}

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSymptomsByUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //animation
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                    height: 400,
                    width: 400,
                    child: Center(
                      child: Lottie.asset("Assets/animations/hellobot.json", repeat: true,reverse: true,fit:BoxFit.cover),
                    ),
                  ),
          ),
          //text
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width-10,
              height: 250,
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 20),),
              ),
            ),
            ),
          //button navigate
          Padding(padding: EdgeInsets.all(10),
          child: ElevatedButton(
              onPressed: () {
                print("go doctor list");
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
              },
              child: const Text(
                "See a doctor",
                style: TextStyle(
                    color: Style.whiteColor,
                    fontFamily: 'Mark-Light',
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }
}