import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychoday/screens/Reservations_consultation/appointment_screen.dart';
import 'package:psychoday/screens/authentification_intelligente/auth.dart';
import 'package:psychoday/screens/chatbot/speech_screen.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/screens/listDoctor/widgets/health_needs.dart';
import 'package:psychoday/screens/therapy/list_therapy.dart';
import 'package:psychoday/utils/style.dart';

class StartTestCard extends StatelessWidget {
  const StartTestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
               padding: const EdgeInsets.all(20),
               decoration:BoxDecoration(
                color: Style.clair,
                borderRadius: BorderRadius.circular(12)
               ),
               child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 120,
                    child: Image.asset("Assets/images/doctor.png"),
                  ),


                  const SizedBox(width: 25,),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Style.titleText('Are you ready ?', Style.blackColor, 18),

                        const SizedBox(height: 12,),
                        Style.sousTitleText('To start your diagnostic test clic start', Style.blackColor, 16),

                        const SizedBox(height: 12,),
                  
                        InkWell(
                          //const SpeechScreen()
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SpeechScreen()));
                          
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Style.primaryLight,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child:  Center(
                              child: Style.titleText('start', Style.whiteColor, 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
               ),
            ),
          );
  }
}