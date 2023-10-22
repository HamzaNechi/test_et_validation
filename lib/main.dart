import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:psychoday/screens/Welcome/components/login_signup_btn.dart';
import 'package:psychoday/screens/Welcome/welcome_screen.dart';
import 'package:psychoday/screens/articles/articles.dart';
import 'package:psychoday/screens/articles/detail_article.dart';
import 'package:psychoday/screens/chatbot/tts.dart';
import 'package:psychoday/screens/dashboard/dashboard.dart';
import 'package:psychoday/screens/therapy/ajout_therapy.dart';
import 'package:psychoday/screens/therapy/detail.dart';
import 'package:psychoday/screens/therapy/list_therapy.dart';
import 'package:psychoday/screens/welcome.dart';
import 'package:psychoday/utils/style.dart';
import './utils/constants.dart';


List<CameraDescription>? cameras;

Future<void> main() async {
  
  
  
   AwesomeNotifications().initialize(
    null,
  // set the icon to null if you want to use the default app icon
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group')
  ],
  debug: true
);

  TextToSpeech.initTTS();
   cameras = await availableCameras();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dear self',
      theme: ThemeData(
          primaryColor: Style.primary,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Style.primaryLight,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Style.clair,
            iconColor: Style.primaryLight,
            prefixIconColor: Style.primaryLight,
            contentPadding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
      )),
       home:  AnimatedSplashScreen(
              splash: Image.asset("Assets/Logo.png"),
              duration: 3000,
              splashIconSize:160,
              splashTransition: SplashTransition.fadeTransition, 
              nextScreen: const Welcome()
              ),

      routes: {
    
        HomeScreen.routeName: (context) => const HomeScreen(),
        //DetailsScreen.routeName: (context) => const DetailsScreen(title: 'Reservation',),
      },
    );
  }
}
