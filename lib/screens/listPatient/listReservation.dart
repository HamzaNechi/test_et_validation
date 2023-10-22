import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:psychoday/models/appointement.dart';
import 'package:psychoday/screens/listPatient/Reserve.dart';
import 'package:psychoday/screens/therapy/reservation_model.dart';
import 'package:psychoday/screens/therapy/therapy_model.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user.dart';
import '../../../utils/constants.dart';
import '../dashboard/dashboard.dart';

class ListReservation extends StatefulWidget {
  const ListReservation({super.key});

  @override
  State<ListReservation> createState() => _ListReservationState();
}

class _ListReservationState extends State<ListReservation> {
  //var
  List<Reserve> ress = [];
  late String _user ="";
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

  Future<List<Reserve>> getRes() async {
    ress.clear();
    //late String _patient = "643be448745ad0cbfd1277d6";
    
    //url
    Uri verifyUri=Uri.parse("$BASE_URL/reservation/$_user");
    
    print("get reservation $verifyUri");

    //request
    try {
      final response = await http.get(verifyUri);
      print('HTTP status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
          print(jsonObject);

        jsonObject['apps'].forEach((res) => {
              ress.add(Reserve(
                id: res['id'],
                  patient: User.rania(
                      fullName: res['patient']['fullName'],
                      phone: res['patient']['phone'],
                      email: res['patient']['email']),
                    //  therapy: res['therapy']['titre'],
                  date: DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(res['date'])),
                                  status: res['status'])),
                  
            });
        print(ress);
        return ress;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('HTTP request failed with error: $e');
      return [];
    }
  }
   void cancelAppointement(String id) async {
    //url
    Uri verifyUri = Uri.parse("$BASE_URL/reservation/cancelR");

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

void acceptAppointement(String id) async {
    //url
    Uri verifyUri = Uri.parse("$BASE_URL/reservation/approuveR");

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
                desc: "Reservation approuved!")
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

  Widget build(BuildContext context) {
    return _user.isNotEmpty ? Scaffold(
      appBar: AppBar(
        title: Text("list reservations"),
           actions: [
            InkWell(child:  Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(role: "doctor")));
            },)
          ],
      ),
      body: FutureBuilder<List<Reserve>>(
        future: getRes(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Reserve>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Reserve> pdata = snapshot.data!;
         


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
                                    "Mr.${pdata[index].patient!.fullName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      "${pdata[index].patient!.email}"),
                                  trailing: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        AssetImage("Assets/images/avatar.png"),
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
                                          Icons.phone,
                                          color: Style.primary,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${pdata[index].patient!.phone}",
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
                                          Text(
                                          "${pdata[index].date}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        ),
                                      
                                    
                                      ],
                                    ),
                                  ],
                                ),
                                   Padding(
                                     padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                                     child: Row(
                                          children: [
                                        
                                            SizedBox(height: 15),
                                                                   Row(
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
                                         SizedBox(width: 10,)    ,                       
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
                                                                   )
                                          ],
                                        ),
                                   ),
                              ]),
                            ),
                          ),
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
    ): CircularProgressIndicator();
  }
}
