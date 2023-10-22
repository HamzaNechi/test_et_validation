import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:psychoday/screens/DoctorDetails/googlemap/google_map.dart';
import 'package:psychoday/screens/Signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../../utils/style.dart';
import '../doctor_detail_schedule_screen.dart';

class DoctorDetailsForm extends StatefulWidget {
  const DoctorDetailsForm({super.key});

  @override
  State<DoctorDetailsForm> createState() => DoctorDetailsFormState();
}

class DoctorDetailsFormState extends State<DoctorDetailsForm> {
  final _textControllerAddress = TextEditingController();
  //var
  List<String> itemsList = ['Psychiatre', 'Psychologue', "Psychoeducateur"];
  List<String> itemsList2 = ['CNAM', 'CARTE'];

  late String _speciality = "";
  late String _about;
  late String _assurance = "";
  late String _location = "";

  String testing = "wajdi@gmail.com";

  final GlobalKey<FormState> _keyFormdetails = GlobalKey<FormState>();
  String idUserConnected='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('_id');
    setState(() {
      idUserConnected=id!;
    });
  }

  //actions

  void DoctorDetails() {
    //url
    Uri addUri = Uri.parse("$BASE_URL/user/editDoctorDetails/$idUserConnected");
    print("$BASE_URL/user/editDoctorDetails/$idUserConnected");
    //data to send
    Map<String, dynamic> userObject = {
      "speciality": _speciality,
      "about": _about,
      "assurance": _assurance,
      "address": _location
    };

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .put(addUri, headers: headers, body: json.encode(userObject))
        .then((response) async {
      if (response.statusCode == 200) {
        print("Response status: ${response.statusCode}");
        var jsonResponse = response.body;
        print(jsonResponse);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DoctorDetailsScheduleScreen()),
        );
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Email or password are incorrect!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
          Form(
            key: _keyFormdetails,
            child: Column(children: [
              DropdownButtonFormField<String>(
                items: itemsList
                    .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 15))))
                    .toList(),
                onChanged: (item) => setState(() {
                  _speciality = item!;
                }),
                decoration: InputDecoration(
                  labelText: 'Speciality',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  minLines: 2,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (String? value) {
                    _about = value!;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "About cant be empty!";
                    } else if (value.length < 10) {
                      return "About must have at least 10 characters!";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'About Doctor',
                    hintText: "Little biography",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.medical_information),
                    ),
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                //hint
                items: itemsList2
                    .map((item2) => DropdownMenuItem(
                        value: item2,
                        child: Text(item2, style: TextStyle(fontSize: 15))))
                    .toList(),
                onChanged: (item2) => setState(() {
                  _assurance = item2!;
                }),
                decoration: InputDecoration(
                  labelText: 'Assurance',
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () async {
                    // Wait for user to select a location
                    final LatLng? selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoogleMapDoctor()),
                    );

                    
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        selectedLocation!.latitude, selectedLocation.longitude);
                    if (selectedLocation != null) {
                      setState(() {
                        _location =
                            "${selectedLocation.latitude}, ${selectedLocation.longitude}";
                        _textControllerAddress.text =
                            placemarks.first.street.toString() +
                                " " +
                                placemarks.first.subLocality.toString();
                    
                      });
                    }
                  },
                  icon: Icon(Icons.my_location),
                  label: Text('Click Here to choose your location'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  controller: _textControllerAddress,
                  enabled: false,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  onSaved: (String? value) {
                    _location = value!;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Address cant be empty!";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Address',
                    hintText: "Your address",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.add_location_rounded),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Hero(
                tag: "doctor_detail_btn",
                child: ElevatedButton(
                  onPressed: () {
                    if (_keyFormdetails.currentState!.validate()) {
                      _keyFormdetails.currentState!.save();
                      DoctorDetails();
            
                    }
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        color: Style.whiteColor,
                        fontFamily: 'Mark-Light',
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
            ]),
          ),
        ],
      ),
    );
  }
}
