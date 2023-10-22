import 'dart:convert';
//import 'dart:ffi';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:psychoday/utils/constants.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _doctornum = 0;
  int _patientnum = 0;

  int _usernum = 0;

  @override
  void initState() {
    super.initState();
    fetchpatients().then((doctornum) {
      setState(() {
        _doctornum = doctornum;
        print(_doctornum);
      });
    });
    fetchdoctors().then((patientnum) {
      setState(() {
        _patientnum = patientnum;
        print(_patientnum);
      });
    });
    fetchusers().then((usernum) {
      setState(() {
        _usernum = usernum - _doctornum - _patientnum;
        
        print(_usernum);
      });
    });
  }

  Future<int> fetchpatients() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/user/getallpatients'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("it works");

      return jsonResponse.length;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<int> fetchdoctors() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/user/getalldoctors'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("it works");

      return jsonResponse.length;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<int> fetchusers() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/user/getalls'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("it works");

      return jsonResponse.length;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                CircleAvatar(
                  backgroundImage: AssetImage('Assets/image.png'),
                  radius: 30,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Good morning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildUserBox(
                'Number of Users',
                _usernum
                    .toString()), // Replace '100' with the actual number of users
            SizedBox(height: 16), // Add some spacing between the boxes
            _buildUserBox(
                'Number of Patients',
                _patientnum
                    .toString()), // Replace '50' with the actual number of patients
            SizedBox(height: 16), // Add some spacing between the boxes
            _buildUserBox(
                'Number of Doctors',
                _doctornum
                    .toString()), // Replace '20' with the actual number of doctors
          ],
        ),
      ),
    );
  }

  Widget _buildUserBox(String title, String count) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Color.fromARGB(150, 224, 224, 224),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(158, 158, 158, 1),
          style: BorderStyle.solid,
        ),
      ),
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
