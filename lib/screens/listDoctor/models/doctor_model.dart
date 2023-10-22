class DoctorModel {
  String fullName;
  String speciality;
  //final int averageReview;
 // final int totalReviews;
  String certificate;
  String id;
  DoctorModel({
    required this.id,
    required this.fullName,
     required this.speciality,
     required this.certificate,
  }
     
  );

  DoctorModel.three(this.id,this.fullName,this.speciality,this.certificate);



  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      fullName : json['fullName'], 
      speciality : json['speciality'], 
      certificate : json['certificate']);
  }

  
}
