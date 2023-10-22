import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/utils/style.dart';


import '../../utils/constants.dart';
import 'Report.dart';
import 'RepportCell.dart';
import 'package:http/http.dart' as http;

import 'listRapport.dart';
 class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}


class _AddReportState extends State<AddReport> {
  final Report report = Report( "report_id",
  "happy",
  "2022-05-02",
  3,
  7,
  5,
  "headache, fatigue",
  "user_id",);
  double depressedMood = 0;
  double elevatedMood = 0;
  double irritabilityMood = 0;
  
  Future<void>  editMoodReport( int depressedMood, int elevatedMood, int irritabilityMood) async {
   // replace with your API endpoint URL and the report ID to edit
        Uri addUri = Uri.parse('$BASE_URL/report/editMood'); 
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        'depressedMood': depressedMood,
        'elevatedMood': elevatedMood,
        'irritabilityMood': irritabilityMood,
      });

      final response = await http.post(addUri, headers: headers, body: body);

      if (response.statusCode == 200) {
        // handle success response
        final responseData = json.decode(response.body);
        print(responseData['message']);
        print(responseData['editedMood']);
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ListRapport();
            },
          ),
        );
      } else {
        // handle error response
        final responseData = json.decode(response.body);
        print(responseData['message']);
      }
    }
     @override
  void initState() {
     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
         AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }); }
 triggerNotification(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
       channelKey: 'basic_channel',
       title: 'Report added',
       body: 'You have just been added your repport now',
       ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "Assets/bg.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  MoodCard(
                    sliderValue: depressedMood,
                    onSliderChange: (value) =>
                        setState(() => depressedMood = value),
                    title: "Today's depressed mood:",
                  ),
                  MoodCard(
                    sliderValue: elevatedMood,
                    onSliderChange: (value) =>
                        setState(() => elevatedMood = value),
                    title: "Today's elevated mood:",
                  ),
                  MoodCard(
                    sliderValue: irritabilityMood,
                    onSliderChange: (value) =>
                        setState(() => irritabilityMood = value),
                    title: "Today's irritability mood:",
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await editMoodReport(
                          
                          depressedMood.toInt(),
                          elevatedMood.toInt(),
                          irritabilityMood.toInt(),
                        );
                        triggerNotification();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Style.marron,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
