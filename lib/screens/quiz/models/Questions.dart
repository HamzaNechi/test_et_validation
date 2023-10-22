

class Question {
  final int id;
  final int answer;
  final String question;
  final List<String> options;

  Question({
    required this.id,
    required this.question,
    required this.answer,
    required this.options,
  });

   static List sample_data = [
    {
      "id": 1,
      "question": "Passez-vous d’un moment de tristesse à un moment de joie en très peu de temps ? ",
      "options": ["Oui","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 2,
      "question": "Est-ce qu’il vous arrive d’avoir des moments d’absence mentale et d’autres moments où il vous arrive d’être très innovant ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 3,
      "question": "Est-ce que vous avez des changements d’humeur fréquents ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 4,
      "question": "Vous sentez-vous quelquefois en dépression tout en étant hyperactif en même temps ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 5,
      "question": "Passez-vous d’un état pessimiste à optimiste, et vice versa, en quelques secondes seulement ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 6,
      "question": "Parlez-vous très rapidement à certains moments ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 7,
      "question": "Vous est-il déjà arrivé d’être dans un colère noire pour un rien ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
    {
      "id": 8,
      "question": "Vous arrives-t-il des fois de ne rien avoir envie de faire et des fois de vouloir tout faire ?",
      "options": ["Yes","No","Parfois","Je Sais Pas"],
      "answer_index": 2,
    },
  ];
}
