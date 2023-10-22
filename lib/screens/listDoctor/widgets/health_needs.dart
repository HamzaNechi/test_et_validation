import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

import 'package:http/http.dart' as http;

import '../models/custom.dart';
import '../models/doctor_model.dart';
import 'doctorcell.dart';

class HealthNeeds extends StatefulWidget {
  const HealthNeeds({Key? key}) : super(key: key);

  @override
  _HealthNeedsState createState() => _HealthNeedsState();
}

class _HealthNeedsState extends State<HealthNeeds> {
  List<CustomIcon> customIcons = [
    CustomIcon(
        name: "Psychologue",
        icon: 'Assets/psychiatrist.png',
        speciality: 'Psychiatrist'),
    CustomIcon(
        name: "Psychiatre",
        icon: 'Assets/psychologist.png',
        speciality: 'Psychologist'),
    CustomIcon(
        name: "Psychoeducateur",
        icon: 'Assets/therapy.png',
        speciality: 'Psychoeducator'),
    CustomIcon(name: "More", icon: 'Assets/more.png', speciality: ''),
  ];

  Future<List<DoctorModel>>? futureDoctors;
  List<DoctorModel> doctors = [];


Future<List<DoctorModel>> getAllDoctors() async {
  final response = await http.get(Uri.parse('$BASE_URL/user/getAllUsers'));
  if (response.statusCode == 200) {
    print("status 200 ok mrigle");

    final jsonBody = jsonDecode(response.body);
    List<dynamic> data = jsonBody;
    for (var item in data) {
      // Decrypting the full name using bcrypt
      //String fullName = await bcrypt.hash(item['fullName'], 10);
      DoctorModel doctor = DoctorModel.three(
        item['id'],
        item['fullName'],
        item['speciality'],
        item['certificate'],
      );
      doctors.add(doctor);
    }
    return doctors;
  } else {
    throw Exception('Failed to load doctors');
  }
}


  Future<void> getDoctorsBySpeciality(String speciality) async {
    doctors.clear();
    final response =
        await http.get(Uri.parse('$BASE_URL/user/filterdoctor/$speciality'));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      List<dynamic> data = jsonBody;
      for (var item in data) {
        DoctorModel doctor = DoctorModel.three(
          item['id'],
          item['fullName'],
          item['speciality'],
          item['certificate'],
        );
        doctors.add(doctor);
      }
    } else {
      throw Exception('Failed to load doctors with speciality');
    }
  }

  @override
  void initState() {
    super.initState();
    futureDoctors = getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(customIcons.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    if (customIcons[index].speciality.isNotEmpty) {
                      await getDoctorsBySpeciality(
                          customIcons[index].speciality);
                    } else {
                      setState(() {});
                      await getAllDoctors();
                    }
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          customIcons[index].icon,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(customIcons[index].name)
                    ],
                  ),
                );
              }),
            ),
            FutureBuilder<List<DoctorModel>>(
              future: futureDoctors,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    // wrap the ListView.builder with a SizedBox
                    // give it a fixed height
                    child: SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          return Cell(doctors[index]);
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ));
  }
}
