import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/DoctorDetails/components/doctor_detail_form.dart';
import 'package:psychoday/screens/DoctorDetails/doctor_detail_screen.dart';
import 'package:psychoday/screens/Reservations_consultation/appointment_screen.dart';
import 'package:psychoday/screens/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../../utils/style.dart';

class DoctorDetailsScheduleScreen extends StatefulWidget {
  const DoctorDetailsScheduleScreen({super.key});

  @override
  State<DoctorDetailsScheduleScreen> createState() =>
      _DoctorDetailsScheduleScreenState();
}

class _DoctorDetailsScheduleScreenState
    extends State<DoctorDetailsScheduleScreen> {

  String? idUserConnected;
  String? roleUserConnected;
  //var
  bool _showTextField = false;
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late TimeOfDay _selectedTime1 = TimeOfDay.now();

  late String _dayOfWeek = "";
  late String _startTime = "";
  late String _endTime = "";
  late String _user;

  final GlobalKey<FormState> _keyFormSchedule = GlobalKey<FormState>();

  //actions

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');
    setState(() {
      _user=id_user!;
      idUserConnected=id_user;
      roleUserConnected=role_user!;
    });
  }

  void DoctorDetails() {
    //url
    Uri addUri = Uri.parse("$BASE_URL/schedule/addWorkingHours/$_user");

    //data to send
    Map<String, dynamic> userObject = {
      "dayOfWeek": _dayOfWeek,
      "startTime": _startTime,
      "endTime": _endTime,
      "user": _user,
    };

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(addUri, headers: headers, body: json.encode(userObject))
        .then((response) async {
      if (response.statusCode == 201) {
        print("Response status: ${response.statusCode}");
        var jsonSchedule = response.body;
        print(jsonSchedule);
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Error!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      } 
      // else {
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text("Information"),
      //         content: const Text("Day of the week already exists"),
      //         actions: [
      //           TextButton(
      //               onPressed: () => Navigator.pop(context),
      //               child: const Text("Dismiss"))
      //         ],
      //       );
      //     },
      //   );
      // }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  @override
  Widget build(BuildContext context) {

     @override
  void initState() {
    super.initState();
    getUserConnected();
  }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          "Your working hours",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Style.primaryLight,
                              fontFamily: 'Red Ring',
                              fontSize: 25),
                        ),
                      ),
                      Column(children: [
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Monday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Monday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerMonday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherMonday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerMonday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherMonday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerMonday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherMonday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerMonday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherMonday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Tuesday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Tuesday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerTuesday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherTuesday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerTuesday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTimeT) {
                                                        if (selectedTimeT !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTimeT;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherTuesday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerTuesday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherTuesday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerTuesday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherTuesday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Wednesday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Wednesday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerWednesday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherWednesday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerWednesday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherWednesday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerWednesday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherWednesday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerWednesday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherWednesday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Thursday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Thursday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerThursday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherThursday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerThursday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherThursday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerThursday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherThursday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerThursday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherThursday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Friday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Friday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerFriday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherFriday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerFriday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherFriday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerFriday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherFriday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerFriday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherFriday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Saturday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Saturday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerSaturday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherSaturday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerSaturday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherSaturday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerSaturday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherSaturday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerSaturday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherSaturday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Sunday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _dayOfWeek = "Sunday";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value:
                                                          'time_pickerSunday1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherSunday1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerSunday1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;

                                                            _startTime =
                                                                _selectedTime1
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherSunday1") {
                                                        _startTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value:
                                                          'time_pickerSunday2',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'otherSunday2',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_pickerSunday2') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                            _endTime =
                                                                _selectedTime
                                                                    .format(
                                                                        context);
                                                          });
                                                        }
                                                      });
                                                    } else {
                                                      if (value ==
                                                          "otherSunday2") {
                                                        _endTime = "Closed";
                                                      }
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            DoctorDetails();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: defaultPadding),
                  Hero(
                    tag: "doctor_detail_schedule_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Dashboard(role: roleUserConnected!)),
                        );
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: Style.whiteColor,
                            fontFamily: 'Mark-Light',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
