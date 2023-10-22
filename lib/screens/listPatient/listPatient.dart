import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psychoday/screens/listPatient/PatientModel.dart';
import 'package:psychoday/screens/listPatient/patientcell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;


class DoctorListP extends StatefulWidget {
  //var

  const DoctorListP({Key? key}) : super(key: key);

  @override
  State<DoctorListP> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DoctorListP> {
  final List<PatientModel> doctors = [];

  String? id_userConnected;
  late Future<void> fetchedData;

Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    print("print shared = $id_user");
    setState(() {
       id_userConnected = id_user;
    });
    print("print shared id user connected= $id_userConnected");
  }


  


  //actions
  Future<bool> fetchData(BuildContext context) async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/user/getPatients/$id_userConnected");
    print("url = $fetchUri");
    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    await http.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        
        //Selialization
        List<dynamic> data = json.decode(response.body);
        print("Fetched data: $data");

        for (var item in data) {
          doctors.add(PatientModel.three(
            item['_id'],
            item['fullName'],
            item['email'],
            item['phone'],
            
          ));
          print("rabi ysahel");
          print(item);
        }
      } else {
        const Center(child: CircularProgressIndicator(),)
        ;
      }
    });

    return true;
  }
    Future<bool> getDoctorsBySpeciality(String titre) async {
  
    Uri fetchUri = Uri.parse("$BASE_URL/user/filterPatient/${titre}");

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    await http.get(fetchUri, headers: headers).then((response) {
      if (response.statusCode == 200) {
        
        //Selialization
        List<dynamic> data = json.decode(response.body);
        print("Fetched data: $data");

        for (var item in data) {
          doctors.add(PatientModel.three(
            item['id'],
            item['fullName'],
            item['email'],
            item['phone'],
            
          ));
          print("rabi ysahel");
          print(item);
        }
      } else {
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: const Text("Information"),
        //       content: const Text("Server Error! Try agaim later."),
        //       actions: [
        //         TextButton(
        //             onPressed: () => Navigator.pop(context),
        //             child: const Text("Dismiss"))
        //       ],
        //     );
        //   },
        // );
        const Center(child: CircularProgressIndicator(),)
        ;
      }
    });

    return true;
  }


  //life cycle

  
@override
  void initState() {
    super.initState();
        fetchedData = fetchData(context);

    getUserConnected();
  }
  
  //build
 

  //build
  // build method in DoctorList class
@override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

  

      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height * 0.3,
                  width: width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Assets/123.png"),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(1.0),
                    ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: 20,
                  child: RichText(
                    text: TextSpan(
                        text: "My Patient ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 20),
                        children: [
                          TextSpan(
                              text: "'s \n reports",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24))
                        ]),
                  ),
                )
              ],
            ),
  Transform.translate(
                  offset: Offset(0.0, -(height * 0.3 - height * 0.26)),
                  child: Container(
                    width: width,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 0),
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    fetchedData;
                                  } else {
                                    getDoctorsBySpeciality(value);
                                  }
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 3),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Icon(
                                        Icons.search,
                                        size: 30,
                                      ),
                                    ),
                                    hintText: "Search your therapy",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                            width: 1.0,
                                            color: Colors.transparent))),
                              ),
                            ),
                       
                     
                        Container(
                          height: height * 0.6,
                        child: FutureBuilder(
      future: fetchData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // Check that the list is not empty before building cells
          if (doctors.isNotEmpty) {
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return CellP(doctors[index]);
              },
            );
          } else {
            return Center(child: Text("No therapies found"));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}