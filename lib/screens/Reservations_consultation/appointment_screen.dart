import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:psychoday/screens/DoctorDetails/components/table_calender_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as google_maps;
import 'package:psychoday/utils/style.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import '../../utils/constants.dart';

class AppointmentScreen extends StatefulWidget {
  late String id_doctor;
  AppointmentScreen(this.id_doctor, {super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late Future<Map<String, dynamic>> _userDataFuture;
  String idUserConnected = '';
  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('_id');
    setState(() {
      idUserConnected = id!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserConnected();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    print("get user ");
    final response =
        await http.get(Uri.parse("$BASE_URL/user/getUser/${widget.id_doctor}"));
    print("$BASE_URL/user/getUser/${widget.id_doctor}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Style.primary,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: DetailBody(userDetail: snapshot.data!, idDoctor: widget.id_doctor),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to fetch user data"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final Map<String, dynamic> userDetail;
  final String idDoctor;
  DetailBody({Key? key, required this.userDetail, required this.idDoctor}) : super(key: key);

  Future<void> _launchMapsUrl(double lat, double lng) async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await canLaunchUrlString(url)
        ? await launchUrlString(url)
        : throw "Could not launch $url";
  }

  @override
  Widget build(BuildContext context) {
    print(userDetail);
    /* String latLngString = userDetail["address"];
    List<String> parts = latLngString.split(RegExp(r'[(),]'));
    double lat = double.parse(parts[1]);
    double lng = double.parse(parts[2]);*/

    return FutureBuilder<List<Location>>(
        future: locationFromAddress(userDetail["address"]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Location location = snapshot.data!.first;
            return Container(
                child: Column(children: [
              Row(
                children: [
                  Container(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Style.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('Assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Dr ${userDetail["fullName"] != null ? userDetail["fullName"] : "nil" }",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Mark-Light',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${userDetail["speciality"] != null ? userDetail["speciality"] : "nil"}",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EEFA),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: Style.primaryLight,
                          iconSize: 25,
                          onPressed: () async {
                            final Uri url = Uri(
                                scheme: 'tel',
                                path: "${userDetail["user"]["phone"] != null ? userDetail["user"]["phone"] : "nil"}");
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              print("cannot launch this url");
                            }
                          },
                          icon: Icon(Icons.call),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0EEFA),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.chat_bubble_text_fill,
                          color: Style.primaryLight,
                          size: 25,
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10.0 * 3),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "About Doctor",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Style.second,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${userDetail["about"] != null ? userDetail["about"] != null : "nil"}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Style.blackColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Assurance Médicale",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Style.second,
                      ),
                    ),
                     Row(
                      children: [
                        const SizedBox(height: 0),
                        if (userDetail["assurance"] != null && userDetail["assurance"] == "CNAM")
                          Image.asset(
                            'Assets/images/cnam2.png',
                            height: 70,
                            width: 70,
                          )
                        else
                          Image.asset(
                            'Assets/images/carte.jpg',
                            height: 70,
                            width: 70,
                          )
                      ],
                    ),

                    const SizedBox(height: 5),
                    Text(
                      "${userDetail["assurance"] != null ? userDetail["assurance"] : "nil"}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Style.blackColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Style.second,
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0EEFA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Style.second,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        "${userDetail["address"] != null ? userDetail["address"] : "nil"}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Text("Click on the black marker"),
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FlutterMap(
                          options: MapOptions(
                              center: latLng.LatLng(
                                  location.latitude, location.longitude),
                              zoom: 14.0,
                              interactiveFlags: InteractiveFlag.none),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: latLng.LatLng(
                                      location.latitude, location.longitude),
                                  builder: (ctx) => Container(
                                      child: GestureDetector(
                                    onTap: () {
                                      _launchMapsUrl(location.latitude,
                                          location.longitude);
                                    },
                                    child: Icon(Icons.location_pin),
                                  )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //men hné chenbadlou
                    const Text(
                      "Schedule",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Style.second,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        userDetail != null
                            ? Text(
                                "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Monday").first["dayOfWeek"]}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Style.blackColor,
                                ),
                              )
                            : const Text("null"),
                        const SizedBox(width: 95),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Monday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Monday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Tuesday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 93),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Tuesday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Tuesday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Wednesday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 70),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Wednesday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Wednesday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Thursday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 87),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Thursday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Thursday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Friday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 120),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Friday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Friday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Saturday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 100),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Saturday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Saturday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Saturday").first["dayOfWeek"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 102),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Sunday").first["startTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.arrow_right_outlined, color: Style.second),
                        const SizedBox(width: 10),
                        Text(
                          "${userDetail["schedules"].where((schedule) => schedule["dayOfWeek"] == "Sunday").first["endTime"]}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Style.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Style.primary,
                        ),
                      ),
                      child: const Text('Book Appointment'),
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TableCalenderDoctor(idDoctor: idDoctor)),
                        ),
                      },
                    )
                  ],
                ),
              ),
            ]));
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to fetch location data"));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
