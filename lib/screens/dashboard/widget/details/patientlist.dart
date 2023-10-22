import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/dashboard/widget/details/patientcard.dart';

import '../../../../utils/constants.dart';

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<dynamic> _patients = [];

  @override
  void initState() {
    super.initState();
    fetchpatients().then((patients) {
      setState(() {
        _patients = patients;
        print(_patients);
      });
    });
  }

  Future<List<dynamic>> fetchpatients() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/user/getallpatients'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print("it works");
      return jsonResponse;
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
            Text("patients List"),
            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (BuildContext context, int index) {
                  final doctor = _patients[index];
                  return PatientCard(
                    id: doctor['id'],
                    name: doctor['fullName'],
                    email: doctor['email'],
                  );
                },
              ),
            ),

            // Replace '20' with the actual number of patients
          ],
        ),
      ),
    );
  }
}
