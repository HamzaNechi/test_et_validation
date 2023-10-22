import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/screens/quiz/controllers/question_controllers.dart';
import 'package:psychoday/screens/quiz/screens/constants.dart';
import 'package:psychoday/screens/quiz/screens/quiz/components/progress_bar.dart';
import 'package:psychoday/screens/quiz/screens/quiz/components/question_card.dart';
import 'package:websafe_svg/websafe_svg.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
     return Stack(
      children:[
            Container(
            width: double.infinity,
            height: double.infinity,
            child: WebsafeSvg.asset(
              'Assets/gh.svg',
              fit: BoxFit.cover,
        ),
      ),
      SafeArea(child:   
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                 const Padding(
                  padding:EdgeInsets.symmetric(horizontal: KDefaultPadding),
                  child: ProgressBar(),
                ),
                const SizedBox(height: KDefaultPadding),     
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal: KDefaultPadding),
                  child: Obx(
                    ()=>Text.rich(
                      TextSpan(
                        text: "Question ${_questionController.questionNumber.value}",
                        style: Theme.of(context).textTheme.headline4?.copyWith(color: KSecondaryColor),
                        children: [
                          TextSpan(
                            text: "/${_questionController.questions.length}",
                            style: Theme.of(context).textTheme.headline5?.copyWith(color: KSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                
                  ),
                  ), 
                const Divider(thickness: 1.5),
                 SizedBox(height: KDefaultPadding),  

                Expanded(
                  child: PageView.builder(
                    physics:const NeverScrollableScrollPhysics(),
                    controller: _questionController.pageController,
                    onPageChanged: _questionController.updateTheQnNum,
                    itemCount: _questionController.questions.length,
                    itemBuilder: (context, index) =>  QuestionCard(
                    question: _questionController.questions[index],
                      
                    ),
                  ),
                ),
        ],
      ),
      ),
      ],
    );
  }
}

