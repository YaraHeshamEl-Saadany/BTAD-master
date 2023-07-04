class Appointment {
  final String doctorId;
  final String doctorName;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final DateTime date;
  final bool isReserved;

  Appointment({
    required this.doctorId,
    required this.doctorName,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.date,
    required this.isReserved,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'patientPhone': patientPhone,
      'date': date,
      'isReserved': isReserved,
    };
  }
}

/* class Appointment {
  final String doctorName;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final DateTime date;
  final bool isReserved;

  const Appointment({
    required this.doctorId,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.date,
    required this.isReserved,
  });

  factory Appointment.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final appointmentData = document.data()!;
    return Appointment(
      doctorId: appointmentData["doctorId"],
      patientName: appointmentData["patientName"],
      patientEmail: appointmentData["patientEmail"],
      patientPhone: appointmentData["patientPhone"],
      date: appointmentData["date"],
      isReserved: appointmentData["isReserved"],
    );
  }

  Future<void> save() async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('appointments').doc().set({
      'doctorId': doctorId,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'patientPhone': patientPhone,
      'date': date,
      'isReserved': isReserved,
    });
  }
} */
