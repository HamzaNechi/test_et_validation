class PatientModel {
  String fullName;
  //final int averageReview;
  String email;
  String phone;
  String id;
  PatientModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone
  
  }
     
  );

  PatientModel.three(this.id,this.fullName,this.email,this.phone);



  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      fullName : json['fullName'], 
      email : json['email'], 
      phone : json['phone']);
  }

  
}