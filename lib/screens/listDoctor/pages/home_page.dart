import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import '../../../utils/style.dart';
import '../widgets/health_needs.dart';
import '../widgets/nearby_doctors.dart';
import '../widgets/upcoming_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // default name

  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('fullname');
    setState(() {
      _username = username!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Style.second,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, $_username!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Style.primary,
              ),
            ),
            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: Style.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.notifications_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Ionicons.search_outline),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        children: [
          const UpcomingCard(),
          const SizedBox(height: 20),
          Text(
            "Your Doctors",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Style.marron,
              fontFamily: 'Red Ring',
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 15),
          const HealthNeeds(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.home_outline),
            activeIcon: Icon(Ionicons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.calendar_outline),
            activeIcon: Icon(Ionicons.calendar),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.chatbubble_ellipses_outline),
            label: "Chat",
            activeIcon: Icon(Ionicons.chatbubble_ellipses),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.person_outline),
            activeIcon: Icon(Ionicons.person),
            label: "Profile",
          ),
        
        ],
        onTap: (int index) {
          if (index == 3) {
            // navigate to fraud page
         
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return RootApp();
            },
            
          ),
        );
          }else if (index ==  0) {
            // navigate to fraud page
         
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            
        },
        
      ),
    );
  }
        }));}}
