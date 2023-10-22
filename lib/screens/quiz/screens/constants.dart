import 'package:flutter/material.dart';

import '../models/Questions.dart';

const KSecondaryColor = Color(0xFF8894BC);
const KGreenColor = Color(0xFF6AC259);
//blue clor
const KBlueColor = Color(0xFF46A0AE);
const KGreyColor = Color(0xFFC1C1C1);
const KBlackColor = Color(0xFF101010);
const KPrimaryGradient = LinearGradient(
  colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const double KDefaultPadding = 20;

Map<Question, String> pdfQuiz = new Map();
String username = "";
