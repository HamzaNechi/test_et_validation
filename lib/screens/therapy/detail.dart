import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/therapy/SendEmail.dart';
import 'package:psychoday/screens/therapy/therapy_argument.dart';
import 'package:psychoday/screens/therapy/therapy_model.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../utils/constants.dart';
import '../../utils/style.dart';
import '../../main.dart';
import 'chrono.dart';

class DetailsScreen extends StatefulWidget {
  //var
  static const String routeName = "/Details";
  const DetailsScreen({super.key, required this.title, required this.therapy});
    final String title;
    final Therapy therapy;


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Duration _remainingDuration;
  late Timer _timer;
  String? idUserConnected;
  String? roleUserConnected;

  //var
  bool hasTimerStopped = false;
  bool hasReserved = false;

  int capa=0;
  bool reserved=false;
  
  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');
    setState(() {
      idUserConnected=id_user!;
      roleUserConnected=role_user!;
    });
  }

  Future<bool> Reserve(
      String patient_id, String therapy_id) async {
    //url
    Uri buyUri = Uri.parse("$BASE_URL/reservation/send");

    //headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //Object
    Map<String, dynamic> buyObject = {
      "patient_id": idUserConnected,
      "therapy_id": therapy_id,
    };

    //request
    await http
        .post(buyUri, headers: headers, body: json.encode(buyObject))
        .then((response) {
          if(response.statusCode == 201){
            this.capa+=1;
            setState(() {
              reserved=true;
            });
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Information"),
                  content: const Text("therapy reserved successfully!"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Dismiss"))
                  ],
                );
              },
            );
          }else{
            if(response.statusCode == 401){
              showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning"),
                  content: const Text("You have already reserved."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Dismiss"))
                  ],
                );
              },
              );
            }else{
              if(response.statusCode == 402){
                showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text("Sorry ! All seats are already reserved."),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Dismiss"))
                    ],
                  );
                },
                );
              }else{
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Information"),
                        content: const Text("Verify : Server error! Try again later"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Dismiss"))
                        ],
                      );
                    },
                  );
              }
            }
          }

    }).onError((error, stackTrace) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Information"),
                  content: const Text("Verify : Server error! Try again later"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Dismiss"))
                  ],
                );
              },
            ));

    return true;
  }

Future<int> getNumberOfReservations(String therapyId) async {
  print("therapy id getnumber = $therapyId");
  final response = await http.get(
    Uri.parse('$BASE_URL/reservation/number?therapy_id=$therapyId'),
  );
  if (response.statusCode == 200) {
    print("capacity = ${response.body}");
    return int.parse(response.body);
  } else {
    print("response code != 200");
    throw Exception('Failed to get number of reservations');
  }
}

Future<bool> verifIsUserReserved(String therapyId) async {
  print("therapy id getnumber = $therapyId");
   //headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //Object
    Map<String, dynamic> buyObject = {
      "patient_id": idUserConnected,
      "therapy_id": therapyId,
    };

  final response = await http.post(Uri.parse('$BASE_URL/reservation/is_user_reserved'),headers: headers,body: json.encode(buyObject));
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


Future cancelReservation(String therapyId) async {
  print("therapy id getnumber = $therapyId");
   //headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //Object
    Map<String, dynamic> buyObject = {
      "patient_id": idUserConnected,
      "therapy_id": therapyId,
    };

  final response = await http.post(Uri.parse('$BASE_URL/reservation/cancel_reserved'),headers: headers,body: json.encode(buyObject));
  if (response.statusCode == 200) {
    setState(() {
      reserved=false;
    });
  } else {
    setState(() {
      reserved=true;
    });
  }
}
//final GameArgument args = ModalRoute.of(context)?.settings.arguments as GameArgument;

  @override
  void initState() {
     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
         AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }); 
    // TODO: implement initState
    super.initState();
    getUserConnected().then((v){
        verifIsUserReserved(widget.therapy.id).then((value){
        setState(() {
          reserved=value;
          });
        });
    });


    getNumberOfReservations(widget.therapy.id).then((value){
      setState(() {
        capa=value;
      });
    });
    
     //   Noti.initialize(flutterLocalNotificationsPlugin);
    
    print("hello init state one");
    setState((){
       print("hello init state one set state $capa");
    });
    
    
     //get reserved places


  }

  
   triggerNotification(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
       channelKey: 'basic_channel',
       title: 'Therapy Reservation',
       body: 'You have just been reserved your therapy now',
       ));
  }
  //build
  @override
  Widget build(BuildContext context) {
    
    final therapyDate = widget.therapy.date;
//         DateTime therapyDate = args.therapy.date as DateTime;
// DateTime now = DateTime.now();
// Duration remainingTime = therapyDate.difference(now);
   // var capacityVerif= args.therapy.capacity < 0;

   

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            //1
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300.0,
                    child: Image.network(widget.therapy.image),
                    ),
                const SizedBox(
                  height: 20,
                ),
                //2
                Text(
                  widget.therapy.titre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Style.primary,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(widget.therapy.description)
              ],
            ),

            const SizedBox(
              height: 50,
            ),
            //3
            Container(
              
              width: 60.0,
              padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: 900,
                whenTimeExpires: () {
                  setState(() {
                    hasTimerStopped = true;
                  });
                },
                countDownTimerStyle: TextStyle(
                  color: Style.marron,
                  fontSize: 50.0,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
                    "number of Participants : ${this.capa.toString()}")),
            const SizedBox(
              height: 50,
            ),

            Visibility(
              visible: !reserved,
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                  
                    print('roleUserConnected = $roleUserConnected');
                    print('idUserConnected = $idUserConnected');
                
                      Reserve(idUserConnected!, widget.therapy.id);
                        triggerNotification();
                        
                        
                      setState(() {
                        if (widget.therapy.capacity > capa) {
                          capa+=1;
            
                        }
                      });
                   // }
                    
                  },
                  icon: const Icon(CupertinoIcons.add),
                  label: const Text("Reserve Now"),
                ),
              ),
            ),


            Visibility(
              visible: reserved,
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                      //add future function to cancel reservation
                        cancelReservation(widget.therapy.id);
                        
                      setState(() {
                        if (widget.therapy.capacity > capa && capa > 0) {
                          capa-=1;
            
                        }
                      });
                   // }
                    
                  },
                  icon: const Icon(CupertinoIcons.xmark),
                  label: const Text("Cancel reservation"),
                ),
              ),
            ),
             const SizedBox(
              height: 50,
            ),
      
          ],
        ),
      ),
    );
  }
}
