import 'package:flutter/material.dart';

// Firebase SDK imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model imports
import 'package:btad/models/user.dart';

class FirebaseHelper {}

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;

void showScaffoldMessenger(BuildContext context, FirebaseException error) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error.message ?? "Something went wrong",
      ),
      duration: const Duration(seconds: 5),
    ),
  );
}

User? user;

User get currentUser {
  return user!;
}

Future<void> signUp({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  required String role,
  required BuildContext context,
}) async {
  try {
    await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await db.collection('users').doc(email).set({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    });
  } on FirebaseAuthException catch (error) {
    showScaffoldMessenger(context, error);
  }
}

Future<void> signIn({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (error) {
    showScaffoldMessenger(context, error);
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    await auth.signOut();
  } on FirebaseAuthException catch (error) {
    showScaffoldMessenger(context, error);
  }
}

Future<void> sendVerificationEmail(BuildContext context) async {
  try {
    await currentUser.sendEmailVerification();
  } on FirebaseException catch (error) {
    showScaffoldMessenger(context, error);
  }
}

Future<UserModel> getUserDetails(String? email) async {
  final snapshot =
      await db.collection('users').where("email", isEqualTo: email).get();
  final userData =
      snapshot.docs.map((user) => UserModel.fromSnapshot(user)).single;
  print(userData);
  return userData;
}

Future<List<UserModel>> getAllUserDetails(String email) async {
  final snapshot = await db.collection('users').get();
  final userData =
      snapshot.docs.map((user) => UserModel.fromSnapshot(user)).toList();
  return userData;
}
