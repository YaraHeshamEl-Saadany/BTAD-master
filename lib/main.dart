import 'package:btad/screens/home_screen.dart';
import 'package:flutter/material.dart';

// Package imports
import 'package:google_fonts/google_fonts.dart';

// Firebase SDK imports
import 'package:firebase_core/firebase_core.dart';

// Helper imports
import 'package:btad/helpers/firebase_helper.dart';

// Screen imports
import 'package:btad/screens/authentication_screen.dart';
import 'package:btad/screens/verify_email_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebugMode = false;
    assert(() {
      inDebugMode = true;
      return true;
    }());

    if (inDebugMode) {
      return ErrorWidget(details.exception);
    }
    return Center(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Error\n${details.exception}",
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  };

  runApp(const ApplicationRoot());
}

class ApplicationRoot extends StatelessWidget {
  const ApplicationRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BTAD",
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorSchemeSeed: Colors.deepPurpleAccent,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.deepPurpleAccent,
        ),
      ),
      darkTheme: ThemeData.light(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (auth.currentUser == null) {
              return const AuthenticationScreen();
            } else if (!auth.currentUser!.emailVerified) {
              return const VerifyEmailScreen();
            }
            return HomeScreen(user: auth.currentUser!);
          }
          return const AuthenticationScreen();
        },
      ),
    );
  }
}
