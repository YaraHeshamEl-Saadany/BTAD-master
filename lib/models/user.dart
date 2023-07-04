import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final userData = document.data()!;
    return UserModel(
      firstName: userData['first_name'],
      lastName: userData['last_name'],
      email: userData['email'],
      role: userData['role'],
    );
  }
}
