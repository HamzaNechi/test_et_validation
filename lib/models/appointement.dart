import 'package:psychoday/models/user.dart';

class Appointement {
  String? id;
  User? patient;
  User? user;
  User? doctor;
  String? schedule;
  String? date;
  String? time;
  String? day;
  bool? upcoming;
  bool? canceled;
  String? statuss;

  Appointement(this.patient, this.user,this.doctor, this.date, this.time, this.day,
      this.upcoming, this.canceled);
  Appointement.AppointementWithFourParameter(
      {this.doctor, this.date, this.time, this.day, this.statuss});
  Appointement.AppointementWithFourParameterDoctor(
      {this.id,this.user, this.date, this.time, this.day});
}
