import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/therapy_groups.dart';
import 'package:psychoday/screens/Reservations_consultation/schedule_screen.dart';
import 'package:psychoday/screens/dashboard/components/cell_therapy_group.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/screens/quiz/screens/welcome/welcome_screens.dart';
import 'package:psychoday/screens/suivi/AddMood.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';
import 'package:psychoday/home_page.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants.dart';
import '../../therapy/list_therapy.dart';
import '../../therapy/therapy_model.dart';

class DashboardPatient extends StatefulWidget {
  const DashboardPatient({super.key});

  @override
  State<DashboardPatient> createState() => _DashboardPatientState();
}

class _DashboardPatientState extends State<DashboardPatient> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenPatient(), 
      desktop:DesktopScreenPatient(),
      );
  }
}


// ignore: slash_for_doc_comments
/********* mobile patient */
class MobileScreenPatient extends StatefulWidget {
  const MobileScreenPatient({super.key});

  @override
  State<MobileScreenPatient> createState() => _MobileScreenPatientState();
}

class _MobileScreenPatientState extends State<MobileScreenPatient> {

 List<Therapy> t_groups=[];
 late Future<bool> fetchedData;


  Future<bool> fetchData(BuildContext context) async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/therapy/limit");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      //request
      http.Response response = await http.get(fetchUri, headers: headers);
      if (response != null && response.statusCode == 200) {
        print('rabiiiii ye rabiii');
        //Selialization
        String responseBody = response.body;
        if (responseBody != null) {
          List<dynamic> data = json.decode(responseBody);
          print("Fetched data: $data");
          for (var item in data) {
            var therapy = Therapy(
              item['_id'] ?? "",
              item['image'] ?? "",
              item['titre'] ?? "",
              item['date'] ?? "",
              item['address'] ?? "",
              item['description'] ?? "",
              item['type'] ?? "",
              item['code'] ?? "",
              item['capacity'] ?? 0,
            );
            t_groups.add(therapy);
            print("Number of items in data list: ${data.length}");
            print("Deserialized data: $item => $therapy");
          }
        } else {
          print("Response body is null");
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
    } catch (error) {
      print("Error fetching data: $error");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: const Text("An error occurred while fetching data."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"))
            ],
          );
        },
      );
    }

    return true;
  }

  
 


  List<List<String>> services=[
    [
      'Follow up',
      'Assets/images/reports.png'
    ],

    [
      'Reports',
      'Assets/6000881.png'
    ],

    [
      'Exercises',
      'Assets/images/ex.png'
    ],

    [
      'Articles',
      'Assets/images/news.png'
    ],
  ];

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchedData=fetchData(context);
  }


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body:SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children:[
          const TopScreenPD(),

          const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Style.titleText('Explore therapy groups', Style.blackColor, 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const  HomeScreen()));
                    },
                    child: Style.titleText('see all', Style.primaryLight, 14)),
                ],
              ),
            ),

           const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 150,
                child: FutureBuilder(
                  future: fetchedData,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: t_groups.length,
                          itemBuilder: (context, index) {
                            return CellTherapyGroup(t_group: t_groups[index]);
                          },
                        );
                    }else{
                      return const Center(
                        child:  Text("No data found"),
                      );
                    }
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

            const SizedBox(height: 12,),


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
                        switch (serviceName) {
                          case 'Reports':
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMood()));
                            break;
                          case 'Bookings':
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ScheduleScreen()));
                            break;
                          case 'Follow up':
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  WelcomeScreen()));
                            break;
                          case 'Exercises':
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=>  const HomePagee()));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>  HomeScreen()));
                            break;
                          default : print('not therapy');
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

        ] ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const DashboardPatient()));
              },
              child: Icon(Icons.home))
          ),

          BottomNavigationBarItem(
            label: 'Repports',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddMood()));
              },
              child: Icon(Icons.file_copy))
          ),


          BottomNavigationBarItem(
            label: 'Groups',
            icon: InkWell(
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
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

/****************end mobile screen */










// ignore: slash_for_doc_comments
/*********** start desktop screen ******************/

class DesktopScreenPatient extends StatefulWidget {
  const DesktopScreenPatient({super.key});

  @override
  State<DesktopScreenPatient> createState() => _DesktopScreenPatientState();
}

class _DesktopScreenPatientState extends State<DesktopScreenPatient> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen patient");
  }
}
/*********** end desktop screen************* */