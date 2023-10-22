import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_doctor.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_patient.dart';
import 'package:psychoday/screens/listDoctor/widgets/doctorcell.dart';
import 'package:psychoday/screens/listPatient/listReservation.dart';
import 'package:psychoday/screens/therapy/ajout_therapy.dart';
import 'package:psychoday/screens/therapy/cell.dart';
import 'package:psychoday/screens/therapy/cellDoctor.dart';
import 'package:psychoday/screens/therapy/therapy_model.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  //var
  static const String routeName = "/Home";
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? idUserConnected;
  String? roleUserConnected;
  //var
  final List<Therapy> games = [];
  late Future<bool> fetchedData;
  bool _isFiltering = false;
  Future<void> deleteTherapy(String therapyId) async {
    final response =
        await http.delete(Uri.parse('$BASE_URL/therapy/deleteOnce/$therapyId'));
    if (response.statusCode == 200) {
      print('Therapy deleted successfully.');
    } else {
      print('Failed to delete therapy. Status code: ${response.statusCode}');
    }
  }

  Future<bool> fetchData(BuildContext context) async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/therapy");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      //request
      http.Response response = await http.get(fetchUri, headers: headers);
      if (response != null && response.statusCode == 200) {
        print('rabiiiii ye rabiii');
        //Selialization
        String responseBody = response.body;
        if (responseBody != null) {
          List<dynamic> data = json.decode(responseBody);
          print("Fetched data: $data");
          for (var item in data) {
            var therapy = Therapy(
              item['_id'] ?? "",
              item['image'] ?? "",
              item['titre'] ?? "",
              item['date'] ?? "",
              item['address'] ?? "",
              item['description'] ?? "",
              item['type'] ?? "",
              item['code'] ?? "",
              item['capacity'] ?? 0,
            );
            games.add(therapy);
            print("Number of items in data list: ${data.length}");
            print("Deserialized data: $item => $therapy");
          }
        } else {
          print("Response body is null");
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server Error! Try agaim later."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    } catch (error) {
      print("Error fetching data: $error");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: const Text("An error occurred while fetching data."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"))
            ],
          );
        },
      );
    }

    return true;
  }

  Future<bool> getDoctorsBySpeciality(String titre) async {
    games.clear();
    Uri fetchUri = Uri.parse("$BASE_URL/therapy/filtertherapy/${titre}");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      //request
      http.Response response = await http.get(fetchUri, headers: headers);
      if (response != null && response.statusCode == 200) {
        print('rabiiiii ye rabiii');
        //Selialization
        String responseBody = response.body;
        if (responseBody != null) {
          List<dynamic> data = json.decode(responseBody);
          print("Fetched data: $data");
          for (var item in data) {
            var therapy = Therapy(
              item['_id'] ?? "",
              item['image'] ?? "",
              item['titre'] ?? "",
              item['date'] ?? "",
              item['address'] ?? "",
              item['description'] ?? "",
              item['type'] ?? "",
              item['code'] ?? "",
              item['capacity'] ?? 0,
            );
            games.add(therapy);
            print("Number of items in data list: ${data.length}");
            print("Deserialized data: $item => $therapy");
          }
        } else {
          print("Response body is null");
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server Error! Try agaim later."),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    } catch (error) {
      print("Error fetching data: $error");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: const Text("An error occurred while fetching data."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"))
            ],
          );
        },
      );
    }

    return true;
  }

  //life cycle
  @override
  void initState() {
    super.initState();
    fetchedData = fetchData(context);
    getUserConnected();
  }

  void toggleFiltering(bool value) {
    setState(() {
      _isFiltering = value;
    });
  }

  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');
    setState(() {
      idUserConnected = id_user!;
      roleUserConnected = role_user!;
    });
  }

  //build
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    print("role = ${roleUserConnected}");

    @override
    void initState() {
      super.initState();
      getUserConnected();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('List therapies'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return DashboardDoctor();
                    },
                  ),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: height * 0.3,
                      width: width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("Assets/123.png"),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(1.0),
                            ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft)),
                      ),
                    ),
                    Positioned(
                      bottom: 90,
                      left: 20,
                      child: RichText(
                        text: const TextSpan(
                            text: "it's Great",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20),
                            children: [
                              TextSpan(
                                  text: "Day for \nGroup Therapy",
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
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
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

                            Padding(
                              padding:const EdgeInsets.all(15),
                              child: roleUserConnected == "doctor" ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddGroupTherapyScreen()));
                                    },
                                    child: Container(
                                    width: 100,
                                    height: 60,
                                    decoration:const BoxDecoration(
                                      color: Style.primaryLight,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),

                                    child: const Center(
                                      child: Text("Add New",style: TextStyle(color: Style.whiteColor,fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  ),
                                   InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListReservation()));
                                    },
                                    child: Container(
                                    width: 200,
                                    height: 60,
                                    decoration:const BoxDecoration(
                                      color: Style.primaryLight,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),

                                    child: const Center(
                                      child: Text("See Reservations",style: TextStyle(color: Style.whiteColor,fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  ),
                                  
                                ],
                              ) : Container(),
                              ),
                            Container(
                              height: height * 0.6,
                              child: FutureBuilder(
                                future: fetchedData,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text("Error: ${snapshot.error}"));
                                    }
                                    // Check that the list is not empty before building cells
                                    if (games.isNotEmpty) {
                                      return ListView.builder(
                                        itemCount: games.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 12),
                                            child: Dismissible(
                                              key:
                                                  Key(games[index].id.toString()),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onDismissed: (direction) {
                                                // Remove the item from the list and the server API
                                                deleteTherapy(games[index].id);
                                                setState(() {
                                                  games.removeAt(index);
                                                });
                                              },
                                              child: roleUserConnected! ==
                                                      "doctor"
                                                  ? CellDoctor(games[index])
                                                  : MenuItemCard(games[index]),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return Center(
                                          child: Text("No therapies found"));
                                    }
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
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
