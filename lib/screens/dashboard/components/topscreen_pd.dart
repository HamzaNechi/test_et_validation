import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/screens/dashboard/components/circular_button.dart';
import 'package:psychoday/screens/dashboard/components/search_field.dart';
import 'package:psychoday/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopScreenPD extends StatefulWidget {
  const TopScreenPD({super.key});

  @override
  State<TopScreenPD> createState() => _TopScreenPDState();
}

class _TopScreenPDState extends State<TopScreenPD> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child:  Column(
          children:const [
            AppBar()
          ],
        ) 
      );
  }
}

class AppBar extends StatefulWidget {
  const AppBar({super.key});

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  String nameUser='test';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fullname = prefs.getString('fullname');
    setState(() {
      nameUser=fullname!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(colors: [
         // Style.primary,
          Style.primaryLight,
          Style.primaryLight,
        
        ],
        begin: Alignment.topLeft,
        end:Alignment.bottomRight)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, \n$nameUser',
              style:  TextStyle(color: Style.whiteColor,fontSize: 20, fontStyle:FontStyle.normal,fontWeight:FontWeight.bold,fontFamily: 'Red Ring'),
               ),

              CircleButton(
              bgcolor: Style.primary,
              icon: Icons.notifications_active,
              iconColor: Style.whiteColor,
              onPressed: () {
                
              },)
            ],
          ),

          const SizedBox(height: 20,),

          const SearchTextField()

          
        ],
      ),
    );
  }


  
}