import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:psychoday/models/reclamation.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/screens/reclamation/reponse.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;

import 'details/adminhome.dart';
import 'details/normaluserlist.dart';
import 'details/patientlist.dart';
import 'details/userlist.dart';


class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenAdmin(), 
      desktop:DesktopScreenAdmin());
  }
}

//**************mobile screen admin dashboard */

class MobileScreenAdmin extends StatefulWidget {
  const MobileScreenAdmin({super.key});

  @override
  State<MobileScreenAdmin> createState() => _MobileScreenAdminState();
}

class _MobileScreenAdminState extends State<MobileScreenAdmin> {

  void sendReclamation(String _id) {
    //url
    Uri addUri = Uri.parse("$BASE_URL/reclamation/$_id");


    http.delete(addUri).then((response)async {
      if(response.statusCode != 200){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Error status ${response.statusCode}"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    },);
  }

  List<User> users=[
  ];

  Future<List<Reclamation>> fetchData() async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/reclamation");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    List<Reclamation> reclamations=[
    ];

    http.Response response = await http.get(fetchUri, headers: headers);

    if(response.statusCode == 200){
      String responseBody = response.body;
      List<dynamic> data = json.decode(responseBody);
      for (var item in data) {
        
              var reclamation = Reclamation(
               id:  item["_id"],
                email: item['email'],
                message: item['message'],
                date: item['date'] ,
              );
             // print(item);
              reclamations.add(reclamation);
      }
      return reclamations;
    }else{
      
        return reclamations;
    }


    
  }


  @override
  void initState() {
    super.initState();
    //fetchedData = fetchData(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TopScreenPD(),

          // const SizedBox(height: 25,),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Style.titleText('Explore your patient', Style.blackColor, 16),
          //       Style.titleText('see all', Style.primaryLight, 14),
          //     ],
          //   ),
          // ),



          //const SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(image:AssetImage(users[index].photo!),fit: BoxFit.cover ),
                          borderRadius: BorderRadius.circular(50)
                        ),
                      ),

                      const SizedBox(width: 20,)
                    ],
                  )
                  ;
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
                Style.titleText('Reclamations', Style.blackColor, 16),
              ],
            ),
          ),

          //hné


          Expanded(
                  child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<Reclamation> reclamations=snapshot.data as List<Reclamation>;
                        return ListView.builder(
                        itemCount: reclamations.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(reclamations[index].id),
                            background: Card(color: Colors.red,),
                            onDismissed: (direction) {
                              print('delete reclam');
                            },
                            child: cardRec(reclamations[index]));
                        },
                      );
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    
                  ),
                )
        ],
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Style.primaryLight,
        backgroundColor: Style.whiteColor,
        elevation: 0,
        items:  [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),


          BottomNavigationBarItem(
            label: 'Users',
            icon: InkWell(
//            AdminPage()
onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
              },
              child: Icon(Icons.group))
          ),
          BottomNavigationBarItem(
            label: 'Doctors',
            icon: InkWell(
//            AdminPage()
onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorListPage()));
              },
              child: Icon(Icons.group))
          ),
          BottomNavigationBarItem(
            label: 'Patients',
            icon: InkWell(
//            AdminPage()
onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PatientList()));
              },
              child: Icon(Icons.group))
          ),

          BottomNavigationBarItem(
            label: 'Users',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Alluserslist()));
              },
              child: Icon(Icons.person))
          ),
           BottomNavigationBarItem(
            label: 'Profil',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()));
              },
              child: Icon(Icons.person))
          ),
        ]),
    );


    
  }

  Widget cardRec(Reclamation rec){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Container(
        width: MediaQuery.of(context).size.width-10,
        height: 150,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMEd().format(DateTime.parse(rec.date) ),style: const TextStyle(
                color: Colors.white,
                fontSize: 16
              ),),
        
              InkWell(
                onTap: () {
                  print("envoyer mail");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReponseReclamation(email: rec.email)));
                },

                child: Text(rec.email,style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),),
              ),
        
        
              Text(rec.message,style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400
              ),),
        
            ],
          ),
        ),
        decoration:  BoxDecoration(
          color: Style.primary,
          borderRadius: const BorderRadius.only(
            //bottomRight: Radius.circular(80),
            topRight: Radius.circular(80),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF363f93).withOpacity(0.3),
              offset: Offset(-10.0, 0.0),
              blurRadius: 20.0,
              spreadRadius: 4.0
            )
          ]
        ),
      ),
    );
  }
}

//**************** end screen doctor dashboard *************** */










//******************** desktop screen doctor********************* */
class DesktopScreenAdmin extends StatefulWidget {
  const DesktopScreenAdmin({super.key});

  @override
  State<DesktopScreenAdmin> createState() => _DesktopScreenAdminState();
}

class _DesktopScreenAdminState extends State<DesktopScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen admin");
  }
}