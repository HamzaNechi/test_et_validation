import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/screens/quiz/screens/constants.dart';
import 'package:psychoday/screens/quiz/screens/quiz/quiz_screen.dart';
import 'package:websafe_svg/websafe_svg.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController myController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: WebsafeSvg.asset(
              'Assets/gh.svg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: KDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    "Let's Play Bipolaire Quiz,",
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      "Pendant une durée d’au moins 1 semaine au cours des 6 derniers mois, dîtes nous, par « oui  » ou par « non », si vous avez déjà ressenti un des symptômes ci-dessous . (Toutes les questions sont obligatoires)"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your informations below",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2341),
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  InkWell(
                   // onTap: () => Get.to(QuizScreen(myController.text)),
                   onTap: () {
                     Navigator.push(context,MaterialPageRoute(builder: (context) => QuizScreen(myController.text)));
                   },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(KDefaultPadding * 0.75),
                      decoration: const BoxDecoration(
                        gradient: KPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
    
  }
  
}
