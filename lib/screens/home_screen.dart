import 'package:flutter/material.dart';

// Package imports
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Firebase SDK imports
import 'package:firebase_auth/firebase_auth.dart';

// Widget imports
import 'package:btad/widgets/adaptive_view_widget.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({
    super.key,
    required this.user,
  });

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveViewWidget(user: user),
    );
  }
}
