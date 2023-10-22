class Reservation {
  final String id;
  final String doctorId;
  final String patientId;
  final String therapyId;
  late final String status;
  final DateTime date;

  Reservation({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.therapyId,
    this.status = 'En attente',
    required this.date,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      therapyId: json['therapyId'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'therapyId': therapyId,
      'status': status,
      'date': date.toIso8601String(),
    };
  }
}
