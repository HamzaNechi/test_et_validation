import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/DoctorDetails/doctor_detail_schedule_screen.dart';
import 'package:psychoday/screens/articles/articles.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/listPatient/PatientModel.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/screens/therapy/ajout_therapy.dart';
import 'package:psychoday/screens/therapy/list_therapy.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Reservations_consultation/doctor_schedule_screen.dart';
import '../../listPatient/listPatient.dart';

class DashboardDoctor extends StatefulWidget {
  const DashboardDoctor({super.key});

  @override
  State<DashboardDoctor> createState() => _DashboardDoctorState();
}

class _DashboardDoctorState extends State<DashboardDoctor> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenDoctor(), 
      desktop:DesktopScreenDoctor());
  }
}

//**************mobile screen doctor dashboard */

class MobileScreenDoctor extends StatefulWidget {
  const MobileScreenDoctor({super.key});

  @override
  State<MobileScreenDoctor> createState() => _MobileScreenDoctorState();
}

class _MobileScreenDoctorState extends State<MobileScreenDoctor> {



  List<PatientModel> users=[
  ];

  List<List<String>> services=[
    [
      'Booking',
      'Assets/images/booking.png'
    ],

    [
      'Patients',
      'Assets/images/patient.png'
    ],

    [
      'Therapy groups',
      'Assets/images/groups.png'
    ],

    [
      'Articles',
      'Assets/images/news.png'
    ],
  ];

  String? id_userConnected;
  late Future<void> fetchedData;

  Future getUserConnected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    print("print shared = $id_user");
    setState(() {
       id_userConnected = id_user;
    });
    print("print shared id user connected= $id_userConnected");
  }

   
  //actions
  Future<bool> fetchData(BuildContext context) async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/user/getPatients/6452ff4ad1890fe1ab6d0be8");
    print("url = $fetchUri");
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
          users.add(PatientModel.three(
            item['_id'],
            item['fullName'],
            item['email'],
            item['phone'],
            
          ));
          print("rabi ysahel");
          print(item);
        }
      } else {
        const Center(child: CircularProgressIndicator(),)
        ;
      }
    });

    return true;
  }

 
@override
  void initState() {
    super.initState();
        getUserConnected();
        fetchedData = fetchData(context);
        setState(() {
          
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       SingleChildScrollView(
        physics: ScrollPhysics(),

        child: Column(
          children: [
            const TopScreenPD(),

            const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Style.titleText('Explore your patient', Style.blackColor, 16),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DoctorListP()));
                    },
                    child: Style.titleText('see all', Style.primaryLight, 14)),
                ],
              ),
            ),



            const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder(
                  future: fetchData(context),
                  builder: (context, snapshot) {
                    return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image:const DecorationImage(image:AssetImage("Assets/to7fa.jpg"),fit: BoxFit.cover ),
                              borderRadius: BorderRadius.circular(50)
                            ),
                          ),
                          Text(users[index].fullName),
                          const SizedBox(width: 25,)
                        ],
                      )
                      ;
                    },
                  );
                  },
                ),
              ),
            ),


            const SizedBox(height: 25,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Style.titleText('Other services', Style.blackColor, 16),
                ],
              ),
            ),



            //geridview services

            //const SizedBox(height: 12,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 400,
                child: GridView.builder(
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    String serviceName=services[index][0];
                    String serviceImage=services[index][1];
                    return InkWell(
                      onTap: () {
                        if(serviceName == 'Therapy groups'){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                        }if(serviceName == 'Booking') {
                           Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DoctorScheduleScreen()));
                        }if(serviceName == 'Articles')
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const Articles()));
                        }
                        if(serviceName == 'Patients')
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DoctorListP()));
                        }


                      },
                      child: Card(
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Style.clair,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          width: 110,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(serviceImage)),
                                ),
                              ),
                              
                    
                              const SizedBox(height: 8,),
                    
                              Style.titleText(serviceName, Style.blackColor, 16)
                            ],
                          ),
                        ),
                      ),
                    );
                  }, 
                  
                ),
              ),
            ),
            //end gridview services
          ],
        ),

        


        
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Style.primaryLight,
        backgroundColor: Style.whiteColor,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: InkWell(
              onTap: () {
                Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DashboardDoctor()));
              },
              child: Icon(Icons.home))
          ),

          BottomNavigationBarItem(
            label: 'Bookings',
            icon: InkWell(
              onTap: () {
                Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => DoctorScheduleScreen()));
              },
              child: Icon(Icons.file_copy))
          ),


          BottomNavigationBarItem(
            label: 'Patients',
            icon: InkWell(
              onTap: () {
                Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const DoctorListP()));
              },
              child: Icon(Icons.group))
          ),

          BottomNavigationBarItem(
            label: 'Profile',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()));
              },
              child: Icon(Icons.person))
          ),
        ]),
    );
  }
}

//**************** end screen doctor dashboard *************** */










//******************** desktop screen doctor********************* */
class DesktopScreenDoctor extends StatefulWidget {
  const DesktopScreenDoctor({super.key});

  @override
  State<DesktopScreenDoctor> createState() => _DesktopScreenDoctorState();
}

class _DesktopScreenDoctorState extends State<DesktopScreenDoctor> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen doctor");
  }
}