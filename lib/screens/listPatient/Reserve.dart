import 'package:psychoday/screens/therapy/therapy_model.dart';

import '../../models/user.dart';

class Reserve {
  String? id;
  User? patient;
 

  String? date;
  String? therapy;
  String? status;

  Reserve({this.id, this.patient, this.date, this.therapy , this.status});
  
}
