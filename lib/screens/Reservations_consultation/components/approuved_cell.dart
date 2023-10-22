import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/appointement.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/style.dart';
import '../../chatbot/rapportDoctor.dart';

class ApprouvedCell extends StatefulWidget {
  final Appointement pdata;
  const ApprouvedCell({super.key, required this.pdata});

  @override
  State<ApprouvedCell> createState() => _ApprouvedCellState();
}

class _ApprouvedCellState extends State<ApprouvedCell> {
  bool _switchValue = false;

  void acceptAppointement(String id) async {
    //url
    Uri verifyUri = Uri.parse("$BASE_URL/appointement/confirmPatient");
    print("switch patnet = $verifyUri");
    //data to send
    Map<String, dynamic> appObject = {"_id": id};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http.post(verifyUri, headers: headers, body: json.encode(appObject))
        .then((response) async {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                showCloseIcon: false,
                title: "Success",
                desc: "Patient Confirmed!")
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
    _switchValue = widget.pdata.user!.role == "patient"; 
  }

  @override
  Widget build(BuildContext context) {
    
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
                                    "Mr/Ms.${widget.pdata.user!.fullName}",
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RapportDoctor(id_patient: widget.pdata.user!.id!)));
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
                                          "${widget.pdata.date}",
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
                                          "${widget.pdata.day} at ${widget.pdata.time}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Confirm as a patient"),
                                    Row(
                                      children: [
                                        Switch(
                                          value: _switchValue,
                                          
                                          onChanged: (value) {
                                            print(widget.pdata.user!.role);
                                            setState(() {
                                        
                                              _switchValue = value;
                                              if(value){
                                                acceptAppointement(widget.pdata.user!.id!);
                                              }
                                              
                                            });
                                          },
                                          activeColor: Style.second,
                                          inactiveTrackColor: Colors.grey,
                                          inactiveThumbColor: Colors.white,
                                          activeTrackColor: Style.secondLight,
                                        ),
                                        Text("Patient",
                                            style: TextStyle(
                                              color: Style.primary,
                                            )),
                                      ],
                                    )
                                  ],
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
  }
}