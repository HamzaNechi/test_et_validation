import 'package:flutter/cupertino.dart';

class Report extends ChangeNotifier {
  String? id;
  String? date;
  String? mood;
  int? depressedMood;
  int? elevatedMood;
  int? irritabilityMood;
  String? symptoms;
  String? user;

  Report(this.id, this.date,this.mood, this.depressedMood, this.elevatedMood, this.irritabilityMood, this.symptoms, this.user);
}
