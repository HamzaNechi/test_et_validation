import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:psychoday/screens/quiz/controllers/question_controllers.dart';
import 'package:psychoday/screens/quiz/screens/constants.dart';


class Option extends StatelessWidget {
   Option({
    super.key,
    required this.text,
    required this.index,
    required this.press,

  });

  final String text;
  final int index;
  final VoidCallback press;
  List<String> options = [];
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      
        init: QuestionController(),
        builder: (qnController) {
          //declarer une liste string
          for (int i = 0; i < qnController.questions.length; i++) {
            options.add(qnController.questions[i].options[index]);
          }
          //afficher la liste
                                      //ajouter tous les question de sample_question dans la liste
          


          Color getTheRightColor() {
            if (qnController.isAnswered) {
              if (index == qnController.selectedAns &&
                  qnController.selectedAns == qnController.correctAns) {
                return KBlueColor;
              } else if (index == qnController.selectedAns &&
                  qnController.selectedAns != qnController.correctAns) {
                return KBlueColor;
              }
            }
            return KGreyColor;
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == KBlueColor ? Icons.close : Icons.done;
          }


          

          return InkWell(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: KDefaultPadding),
              padding: EdgeInsets.all(KDefaultPadding),
              decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor()),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${index + 1}. $text",
                    style: TextStyle(color: getTheRightColor(), fontSize: 16),
                  ),
                  Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: getTheRightColor() == KGreyColor
                            ? Colors.transparent
                            : getTheRightColor(),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: getTheRightColor()),
                      ),
                      child: getTheRightIcon() == KGreyColor
                          ? null
                          : Icon(
                              getTheRightIcon(),
                              size: 16,
                            )),
        
                ],
              ),
           
            ),
          
          );
          
        }
        );
        
        
  }
  
  
  
}

