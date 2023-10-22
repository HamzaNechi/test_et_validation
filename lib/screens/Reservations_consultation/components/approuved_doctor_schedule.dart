import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:psychoday/screens/Reservations_consultation/components/approuved_cell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/appointement.dart';
import '../../../models/user.dart';
import '../../../utils/constants.dart';
import '../../../utils/style.dart';

class ApprouvedDoctorSchedule extends StatefulWidget {
  const ApprouvedDoctorSchedule({super.key});

  @override
  State<ApprouvedDoctorSchedule> createState() => _ApprouvedDoctorSchedule();
}

class _ApprouvedDoctorSchedule extends State<ApprouvedDoctorSchedule> {
  //var
  List<Appointement> apps = [];
  late String _user = "";
  String? idUserConnected;
  String? roleUserConnected;
  
  //actions

  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');

    setState(() {
      _user = id_user!;
      idUserConnected = id_user;
      roleUserConnected = role_user!;
    });
  }

  Future<List<Appointement>> getAppointementsDoctor() async {
    apps.clear();
    //late String _doctor = "6432c9aa1a2bf140b086fec6";

    //url
    Uri verifyUri = Uri.parse(
        "$BASE_URL/appointement/getAppointementsDoctorApprouved/$_user");

    //request
    try {
      final response = await http.get(verifyUri);
      print('HTTP status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
        print(jsonObject);

        jsonObject['ap'].forEach((appointement) => {
              apps.add(Appointement.AppointementWithFourParameterDoctor(
                  user: User.userWith3ParameterDoctor(
                      fullName: appointement['user']['fullName'],
                      id: appointement['user']['id'],
                      role: appointement['user']['role']),
                  date: DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(appointement['date'])),
                  time: appointement['time'],
                  day: appointement['day'],
                  id: appointement['id'])),
            });
        print(apps);
        return apps;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('HTTP request failed with error: $e');
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Appointement>>(
        future: getAppointementsDoctor(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Appointement>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Appointement> pdata = snapshot.data!;

            print(pdata);
            return ListView.builder(
              itemCount: pdata.length,
              itemBuilder: (context, index) {
                
                return ApprouvedCell(pdata: pdata[index]);
              },
            );
          }
          ;
        },
      ),
    );
  }
}
