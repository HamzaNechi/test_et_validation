import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class QuestionAndAnswer {
  String questionText;
  String correctAnswer;
  String selectedAnswer;

  QuestionAndAnswer({
    required this.questionText,
    required this.correctAnswer,
    required this.selectedAnswer,
  });

  Map<String, dynamic> toJson() => {
        'questionText': questionText,
        'correctAnswer': correctAnswer,
        'selectedAnswer': selectedAnswer,
      };

  factory QuestionAndAnswer.fromJson(Map<String, dynamic> json) =>
      QuestionAndAnswer(
        questionText: json['questionText'],
        correctAnswer: json['correctAnswer'],
        selectedAnswer: json['selectedAnswer'],
      );
}

Future<File> get _localFile async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/questions_and_answers.json');
}

Future<void> saveQuestionsAndAnswers(List<QuestionAndAnswer> questionsAndAnswers) async {
  final file = await _localFile;
  final jsonList = questionsAndAnswers.map((qa) => qa.toJson()).toList();
  final jsonString = jsonEncode(jsonList);
  await file.writeAsString(jsonString);
}
