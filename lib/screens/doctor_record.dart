import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doctor.dart';

class DoctorPatientRecordPage extends StatefulWidget {
  final String userEmail;

  DoctorPatientRecordPage({required this.userEmail});

  @override
  _DoctorPatientRecordPageState createState() =>
      _DoctorPatientRecordPageState();
}

class _DoctorPatientRecordPageState extends State<DoctorPatientRecordPage> {
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      // Step 1: Retrieve the currently logged-in user's email
      final currentUserEmail = widget.userEmail;

      // Step 2: Retrieve the doctor with the matching email
      final doctorSnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (doctorSnapshot.docs.isEmpty) {
        // Handle case where no doctor with the given email is found
        return;
      }

      final doctor = Doctor.fromSnapshot(doctorSnapshot.docs[0]);

      // Step 3: Retrieve the appointments where doctorId matches the doctor's id
      final appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctor.id)
          .get();

      // Step 4: Extract the required data ("patientName" and "date") from the retrieved appointments
      final List<Map<String, dynamic>> appointmentsData = [];
      appointmentsSnapshot.docs.forEach((appointmentDoc) {
        final appointment = appointmentDoc.data();
        final Map<String, dynamic> appointmentData = {
          'patientName': appointment['patientName'],
          'date': appointment['date'].toDate(),
        };
        appointmentsData.add(appointmentData);
      });

      setState(() {
        appointments = appointmentsData;
      });
    } catch (error) {
      print('Error fetching appointments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Patient Record'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return ListTile(
            title: Text('Patient Name: ${appointment['patientName']}'),
            subtitle: Text('Date: ${appointment['date']}'),
          );
        },
      ),
    );
  }
}
