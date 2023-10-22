import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/screens/quiz/controllers/question_controllers.dart';
import 'package:psychoday/screens/quiz/screens/quiz/components/body.dart';

import '../constants.dart';

class QuizScreen extends StatelessWidget {
  QuizScreen(this.name);
  String name = "";
  @override
  Widget build(BuildContext context) {
    username = this.name;
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _controller.nextQuestion,
            child: const Text('Skip'),
          )
        ],
      ),
      body: Body(),
    );
  }
}
