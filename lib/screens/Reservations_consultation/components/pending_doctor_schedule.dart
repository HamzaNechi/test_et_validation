import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psychoday/screens/chatbot/rapport.dart';
import 'package:psychoday/screens/chatbot/rapportDoctor.dart';
import 'package:psychoday/screens/chatbot/testResult.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/appointement.dart';
import '../../../models/user.dart';
import '../../../utils/constants.dart';
import '../../../utils/style.dart';

class PendingDoctorSchedule extends StatefulWidget {
  const PendingDoctorSchedule({super.key});

  @override
  State<PendingDoctorSchedule> createState() =>
      _PendingDoctorScheduleState();
}

class _PendingDoctorScheduleState extends State<PendingDoctorSchedule> {
  //var
  List<Appointement> apps = [];
  late String _user = "";
  String? idUserConnected;
  String? roleUserConnected;
  //actions

  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');

    setState(() {
      _user = id_user!;
      idUserConnected = id_user;
      roleUserConnected = role_user!;
    });
  }

  Future<List<Appointement>> getAppointementsDoctor() async {
    apps.clear();
    //late String _doctor = "6432c9aa1a2bf140b086fec6";

    //url
    Uri verifyUri =
        Uri.parse("$BASE_URL/appointement/getAppointementsDoctor/$_user");

    //request
    try {
      final response = await http.get(verifyUri);
      print('HTTP status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
        print(jsonObject);

        jsonObject['appss'].forEach((appointement) => {
              apps.add(Appointement.AppointementWithFourParameterDoctor(
                  user: User.userWith2ParameterDoctor(
                      fullName: appointement['user']['fullName'],
                      id: appointement['user']['id']),
                  date: DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(appointement['date'])),
                  time: appointement['time'],
                  day: appointement['day'],
                  id: appointement['id'])),
            });
        print(apps);
        return apps;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('HTTP request failed with error: $e');
      return [];
    }
  }

  //actions
  void acceptAppointement(String id) async {
    //url
    Uri verifyUri = Uri.parse("$BASE_URL/appointement/approuveAppointement");

    //data to send
    Map<String, dynamic> appObject = {"_id": id};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(verifyUri, headers: headers, body: json.encode(appObject))
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                showCloseIcon: false,
                title: "Success",
                desc: "Appointement approuved!")
            .show();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server error! Try again later"),
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
  }

  //actions
  void cancelAppointement(String id) async {
    //url
    Uri verifyUri = Uri.parse("$BASE_URL/appointement/cancelAppointement");

    //data to send
    Map<String, dynamic> appObject = {"_id": id};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(verifyUri, headers: headers, body: json.encode(appObject))
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        AwesomeDialog(
                context: context,
                 dialogType: DialogType.info,
                animType: AnimType.topSlide,
                showCloseIcon: false,
                title: "Info",
                desc: "Appointement canceled!")
            .show();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server error! Try again later"),
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
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Appointement>>(
        future: getAppointementsDoctor(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Appointement>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Appointement> pdata = snapshot.data!;

            print(pdata);
            return ListView.builder(
              itemCount: pdata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About User",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Style.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Style.primary,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: [
                                ListTile(
                                  title: Text(
                                    "Mr/Ms.${pdata[index].user!.fullName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // trailing: CircleAvatar(
                                  //   radius: 25,
                                  //   backgroundImage:
                                  //       AssetImage("Assets/images/anyn.png"),
                                  // ),
                                  trailing: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RapportDoctor(id_patient: pdata[index].user!.id!)));
                                    },
                                    child: const Icon(Icons.file_open , color: Style.primary,size: 32,),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    height: 20,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Style.primary,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${pdata[index].date}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          color: Style.primary,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${pdata[index].day} at ${pdata[index].time}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                
                                          cancelAppointement(pdata[index].id!);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 130, 43, 43),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Style.whiteColor,
                                            ),
                                          )),
                                        ),
                                      ),
                                   
                                      InkWell(
                                        onTap: () {
                                          acceptAppointement(pdata[index].id!);
                                        },
                                        child: Container(
                                          width: 150,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 43, 130, 79),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Approuve",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Style.whiteColor,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            );
          }
          ;
        },
      ),
    );
  }
}
