import 'package:psychoday/models/schedule.dart';

class User {
  String? id;
  String? fullName;
  String? assurance;
  String? nickName;
  String? email;
  String? password;
  String? phone;
  String? role;
  String? speciality;
  String? address;
  String? photo;
  String? certificate;
  List<Schedule>? schedules;

  User(
      this.id,
      this.nickName,
      this.email,
      this.password,
      this.phone,
      this.role,
      this.address,
      this.photo,
      this.certificate,
      this.fullName,
      this.speciality,
      this.assurance,
      this.schedules);

  User.userWithThreeParameters(
      {this.fullName, this.speciality, this.assurance});
  User.userWith2ParameterDoctor({this.fullName, this.id});
  User.userWithTwoParameters({this.fullName, this.speciality});
    User.rania({this.fullName, this.phone, this.email,this.id});

 User.userWith3ParameterDoctor({this.fullName, this.id, this.role});
  User.four({this.fullName, this.role, this.id, this.email,this.address});

  factory User.fromJson(dynamic json) {
    return User.four(
      id: json['_id'],
      email: json['email'],
      role: json['role'],
      fullName: json['fullname'],
      address: json['address'],
    );
  }
}
