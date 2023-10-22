import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychoday/screens/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  String _username = "";
  String _nickname = "";
  String _email = "";
  File? _profileImage;

  Future _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('fullname');
    String? nickname = prefs.getString('role');
    String? email = prefs.getString('email');

    setState(() {
      _username = username!;
      _nickname = nickname!;
      _email = email!;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  
  Future<void> _logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
}

 
  Future<void> _pickProfileImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final fileBytes = await pickedFile.readAsBytes();
    final response = await http.post(
      Uri.parse('$BASE_URL/user/updatePhoto/$_email'),
      body: fileBytes,
    );
    if (response.statusCode == 200) {
      // The photo was successfully uploaded to your server.
      // You can save the photo on the server or retrieve a URL to the photo
      // and save it to your database or display it in your app.
    } else {
      // Handle error uploading photo to server
    }
  }
}


  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("PROFILE"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // COLUMN THAT WILL CONTAIN THE PROFILE
          Column(
            children:  [
            GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  child: _profileImage == null
                      ? const Icon(Icons.person)
                      : null,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                ),
              ),
              SizedBox(height: 10),
           Text(
                _username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_nickname),
            ],
          ),
          const SizedBox(height: 25),
          // Row(
          //   children: const [
          //     Padding(
          //       padding: EdgeInsets.only(right: 5),
          //       child: Text(
          //         "Complete your profile",
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //     Text(
          //       "(1/5)",
          //       style: TextStyle(
          //         color: Colors.blue,
          //       ),
          //     )
          //   ],
          // ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 7,
                  margin: EdgeInsets.only(right: index == 4 ? 0 : 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: index == 0 ? Colors.blue : Colors.black12,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          // SizedBox(
          //   height: 180,
          //   child: ListView.separated(
          //     physics: const BouncingScrollPhysics(),
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       final card = profileCompletionCards[index];
          //       return SizedBox(
          //         width: 160,
          //         child: Card(
          //           shadowColor: Colors.black12,
          //           child: Padding(
          //             padding: const EdgeInsets.all(15),
          //             child: Column(
          //               children: [
          //                 Icon(
          //                   card.icon,
          //                   size: 30,
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Text(
          //                   card.title,
          //                   textAlign: TextAlign.center,
          //                 ),
          //                 const Spacer(),
          //                 ElevatedButton(
          //                   onPressed: () {},
          //                   style: ElevatedButton.styleFrom(
          //                     elevation: 0,
          //                     shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(10)),
          //                   ),
          //                   child: Text(card.buttonText),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //     separatorBuilder: (context, index) =>
          //         const Padding(padding: EdgeInsets.only(right: 5)),
          //     itemCount: profileCompletionCards.length,
          //   ),
          // ),
          const SizedBox(height: 35),
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return InkWell(
                onTap: () {
                  if(tile.title == "Logout"){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black12,
                    child: ListTile(
                      leading: Icon(tile.icon),
                      title: Text(tile.title),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 3,
      //   type: BottomNavigationBarType.fixed,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.home),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.chat_bubble_2),
      //       label: "Messages",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.book),
      //       label: "Discover",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.person),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}

class ProfileCompletionCard {
  final String title;
  final String buttonText;
  final IconData icon;
  ProfileCompletionCard({
    required this.title,
    required this.buttonText,
    required this.icon,
  });
}

List<ProfileCompletionCard> profileCompletionCards = [
  ProfileCompletionCard(
    title: "Set Your Profile Details",
    icon: CupertinoIcons.person_circle,
    buttonText: "Continue",
  ),
  ProfileCompletionCard(
    title: "Upload your resume",
    icon: CupertinoIcons.doc,
    buttonText: "Upload",
  ),
  ProfileCompletionCard(
    title: "Add your skills",
    icon: CupertinoIcons.square_list,
    buttonText: "Add",
  ),
];

class CustomListTile {
  final IconData icon;
  final String title;
   final VoidCallback onTap;
  CustomListTile({
    required this.icon,
    required this.title,
     required this.onTap,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.insights,
    title: "Activity",
    onTap: () {
      
    },
  ),
  CustomListTile(
    icon: Icons.location_on_outlined,
    title: "Location",
    onTap: () {
      
    },
  ),
  CustomListTile(
    title: "Notifications",
    icon: CupertinoIcons.bell,
    onTap: () {
      
    },
  ),
  CustomListTile(
    title: "Logout",
    icon: CupertinoIcons.arrow_right_arrow_left,
    onTap: () {

    },
  ),
];
