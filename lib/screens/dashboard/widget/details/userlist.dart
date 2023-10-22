import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/dashboard/widget/details/usercard.dart';

import '../../../../utils/constants.dart';

class DoctorListPage extends StatefulWidget {
  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  List<dynamic> _doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors().then((doctors) {
      setState(() {
        _doctors = doctors;
        print(_doctors);
      });
    });
  }

  Future<List<dynamic>> fetchDoctors() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/user/getalldoctors'));

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
            Text("Doctors List"),
            SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _doctors.length,
                itemBuilder: (BuildContext context, int index) {
                  final doctor = _doctors[index];
                  return UserCard(
                    id: doctor['id'],
                      name: doctor['fullName'],
                      email: doctor['email'],
                      phoneNumber: doctor['phone'],
                      nickname: doctor['certificate'],
                      specialty: doctor['speciality'],
                      address: doctor['about'],
                      assurance: doctor['assurance']);
                },
              ),
            ),
         

            // Replace '20' with the actual number of doctors
          ],
        ),
      ),
    );
  }
}
