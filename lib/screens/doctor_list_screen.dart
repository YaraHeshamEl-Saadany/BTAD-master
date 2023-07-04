import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../models/user.dart';
import 'chat_patient_screen.dart';

class DoctorListScreen extends StatelessWidget {
  final UserModel user;

  const DoctorListScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: _buildDoctorList(context),
    );
  }

  Widget _buildDoctorList(BuildContext context) {
    return StreamBuilder<List<Doctor>>(
      stream: Doctor.getDoctors().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final doctors = snapshot.data;

        if (doctors == null || doctors.isEmpty) {
          return const Text('No doctors found.');
        }

        return ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return GestureDetector(
              onTap: () {
                _openChatScreen(context, doctor, user);
              },
              child: Card(
                child: ListTile(
                  title: Text(doctor.name),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openChatScreen(BuildContext context, Doctor doctor, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPatientScreen(user: user, doctor: doctor),
      ),
    );
  }
}
