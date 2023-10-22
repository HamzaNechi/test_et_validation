import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/screens/quiz/controllers/question_controllers.dart';
import 'package:psychoday/screens/quiz/screens/constants.dart';

import 'package:websafe_svg/websafe_svg.dart';

import '../../pdf/pdf_page.dart';


class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});


  @override
  Widget build(BuildContext context) {
    
      QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children:[
          Container(
              width: double.infinity,
              height: double.infinity,
              child: WebsafeSvg.asset(
                'Assets/gh.svg',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              children:[
                const Spacer( flex:3),
                Text("Score",style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: KSecondaryColor
                ),
             
                ),
                const Spacer(),
                Text("${_qnController.numOfCorrectAns * 10} / ${_qnController.questions.length * 10}",style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: KSecondaryColor
                ),
                

             
                ),
                const Spacer(flex:3),
// elevationbutton to pdf
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PdfPage(),
                      ),
                    );
                  },
                  child:const Text('PDF'),
                ),
                const Spacer(flex:3),
              ]

            ) 
        ]
      ),
    );
  }
}