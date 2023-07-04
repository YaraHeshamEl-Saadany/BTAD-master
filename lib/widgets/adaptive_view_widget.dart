import 'package:flutter/material.dart';

// Firebase SDK imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Helper imports
import 'package:btad/helpers/firebase_helper.dart';

// View imports
import 'package:btad/views/technician_view.dart';
import 'package:btad/views/doctor_view.dart';
import 'package:btad/views/patient_view.dart';

import '../models/user.dart';

class AdaptiveViewWidget extends StatefulWidget {
  final User user;

  const AdaptiveViewWidget({super.key, required this.user});

  @override
  State<AdaptiveViewWidget> createState() => _AdaptiveViewWidgetState();
}

class _AdaptiveViewWidgetState extends State<AdaptiveViewWidget> {
  String role = '';
  String firstName = '';
  String lastName = '';

  Future<void> getUserData() async {
    final currentUserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.email)
        .get();

    setState(() {
      role = currentUserData['role'];
      firstName = currentUserData['first_name'];
      lastName = currentUserData['last_name'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUserDetails(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    if (role == 'admin') return const AdminView();
    if (role == 'doctor') {
      final userModel = UserModel(
        email: widget.user.email as String,
        firstName: '',
        lastName: '',
        role: '',
      );
      return DoctorView(
        user: userModel,
        chatData: const <String, dynamic>{},
      );
    }
    if (role == 'patient') {
      final userModel = UserModel(
        email: widget.user.email as String,
        firstName: '',
        lastName: '',
        role: '',
      );

      return PatientView(
        user: userModel,
      );
    }
    return const Center(child: CircularProgressIndicator());
  }
}
