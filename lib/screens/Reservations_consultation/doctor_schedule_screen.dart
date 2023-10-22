import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/style.dart';
import 'components/approuved_doctor_schedule.dart';
import 'components/pending_doctor_schedule.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  //var
  int _buttonIndexD = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Booking"),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: TabBar(
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Approuved'),
                ],
                onTap: (index) {
                  setState(() {
                    _buttonIndexD = index;
                  });
                },
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 16),
                labelColor: Style.primary,
                unselectedLabelColor: Style.blackColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Style.primary,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PendingDoctorSchedule(),
                  ApprouvedDoctorSchedule(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
