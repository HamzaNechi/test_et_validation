import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import 'AddReport.dart';
import 'ItemView.dart';
import 'package:http/http.dart' as http;

import 'dateCard.dart';





class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
   String nameUser='';
   String id_userConnected='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fullname = prefs.getString('fullname');
    final String? id_user = prefs.getString('_id');
    setState(() {
      nameUser=fullname!;
      id_userConnected = id_user!;
    });
  }
  
  late final moodController = TextEditingController();
  late final dateController = TextEditingController();

  final items = [
    ItemMood(
      title: 'Happy',
      image: Image.asset("Assets/happyy.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
    ItemMood(
      title: 'Sad',
      image:  Image.asset("Assets/sadd.png",width: 70,height: 70,),
      imgColor: Colors.green, id: '',
    ),
    ItemMood(
      title: 'Angry',
      image:  Image.asset("Assets/angryy.png",width: 70,height: 70,),
      imgColor: Colors.black.withOpacity(0.8), id: '',
    ),
    ItemMood(
      title: 'Calm',
      image:  Image.asset("Assets/calmm.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
    ItemMood(
      title: 'Manic',
      image:  Image.asset("Assets/manicc.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
  ];

  final spacing = 10.0;
  final numberOfRows = 3;
  
void addMoodReport(String mood) async {
  
    Uri addUri = Uri.parse('$BASE_URL/report/addMood'); // replace with your API endpoint URL
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'date': DateFormat('yyyy-MM-dd').format(DateTime.parse(DateTime.now().toString())), // use the current date and time
    'mood': mood,
    'user': id_userConnected // replace with the user's ID or username
  });

  final response = await http.post(addUri, headers: headers, body: body);

  if (response.statusCode == 200) {
    // handle success response
    final responseData = json.decode(response.body);
    print(responseData['message']);
    print(responseData['newReport']);
     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Success!"),
        content: Text("Your mood has been added."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReport()),
              );
            },
          ),
        ],
      );
    },
  );
  } else {
    // handle error response
    final responseData = json.decode(response.body);
    print(responseData['message']);
    print(responseData['verifReport']);
  }
}
  @override
  void dispose() {
    moodController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(
      1,
      (index) => const Flexible(
        child: SizedBox.shrink(),
      ),
    ).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: items.map((item) {
                return InkWell(
              onTap: () {
          addMoodReport(item.title); 
      },
                  child:  ItemView(item: item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      color:Style.second,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
            nameUser,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}