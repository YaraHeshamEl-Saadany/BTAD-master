import 'package:flutter/material.dart';

// Library imports
import 'dart:async';

// Package imports
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Firebase SDK imports
import 'package:firebase_auth/firebase_auth.dart';

// Screen imports
import 'package:btad/screens/home_screen.dart';

final _firebaseAuth = FirebaseAuth.instance;

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailVerified = false;

  Timer? checkVerificationTimer;

  Future<void> sendVerificationEmail() async {
    try {
      // Get user then send a verification email
      final user = _firebaseAuth.currentUser!;
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  Future<void> checkEmailVerification() async {
    // Refresh the user to see if they're already verified
    await _firebaseAuth.currentUser!.reload();

    setState(() => _isEmailVerified = _firebaseAuth.currentUser!.emailVerified);
    if (_isEmailVerified) checkVerificationTimer?.cancel();
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);

    // Send verification email on reaching this screen
    if (!_isEmailVerified) {
      sendVerificationEmail();

      // Check if the email got verified every 3 seconds
      checkVerificationTimer = Timer.periodic(
          const Duration(seconds: 3), (timer) => checkEmailVerification());
    }
  }

  @override
  void dispose() {
    checkVerificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEmailVerified) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Email Verification"),
          actions: [
            IconButton(
              onPressed: signOut,
              icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "A verification email has been sent to:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "${_firebaseAuth.currentUser!.email}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Please check your inbox or spam folder.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return HomeScreen(user: _firebaseAuth.currentUser!);
    }
  }
}
