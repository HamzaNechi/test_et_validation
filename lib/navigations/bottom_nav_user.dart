import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/screens/articles/articles.dart';
import 'package:psychoday/screens/dashboard/widget/dashboard_user.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/utils/style.dart';

class BottomNavUser extends StatefulWidget {
  const BottomNavUser({super.key});

  @override
  State<BottomNavUser> createState() => _BottomNavUserState();
}

class _BottomNavUserState extends State<BottomNavUser> {
  int index=0;

  void setCurrentIndex(int v){
    setState(() {
      index=v;
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> interfaces=[const DashboardUser(),const Articles(),const RootApp()];
    return BottomNavigationBar(
      onTap: (value) {
        setCurrentIndex(value);
        switch (value){
          case 0: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => interfaces[0],));
          break;
          case 1:Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => interfaces[1],));
          break;
          default : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => interfaces[2],));
        }
      },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Style.primary,
        currentIndex: index,
        backgroundColor: Style.whiteColor,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home)
          ),

          BottomNavigationBarItem(
            label: 'Articles',
            icon: Icon(Icons.newspaper),
          ),

          BottomNavigationBarItem(
            label: 'Profile',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()));
              },
              child: Icon(Icons.person))
          ),
        ]);
  }
}