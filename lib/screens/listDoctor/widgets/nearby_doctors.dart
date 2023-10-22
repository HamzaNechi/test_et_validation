import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;

import '../models/doctor_model.dart';
import 'doctorcell.dart';

class DoctorList extends StatefulWidget {
  //var
  static const String routeName = "/Home";
  const DoctorList({Key? key}) : super(key: key);

  @override
  State<DoctorList> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DoctorList> {
  final List<DoctorModel> doctors = [];
  late Future<void> fetchedData;

  //actions
  Future<bool> fetchData() async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/user/getAllUsers");

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
          doctors.add(DoctorModel.three(
            item['id'],
            item['fullName'],
            item['speciality'],
            item['certificate'],
          ));
          print("rabi ysahel");
          print(item);
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
    });

    return true;
  }

  //life cycle
  @override
  void initState() {
    super.initState();
    fetchedData = fetchData();
  }

  //build
  // build method in DoctorList class
  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height,
    //   child: Scaffold(
    //     body: FutureBuilder(
    //       future: fetchedData,
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return Expanded(
    //             // wrap the ListView.builder with a SizedBox
    //             // give it a fixed height
    //             child: SizedBox(
    //               height: 200,
    //               child: ListView.builder(
    //                 itemCount: doctors.length,
    //                 itemBuilder: (context, index) {
    //                   return Cell(doctors[index]);
    //                 },
    //               ),
    //             ),
    //           );
    //         } else {
    //           return Center(child: CircularProgressIndicator());
    //         }
    //       },
    //     ),
    //   ),
    // );


    return FutureBuilder(
          future: fetchedData,
          
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return Cell(doctors[index]);
                      
                    },
                  ),
                );
              
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
  }
}
