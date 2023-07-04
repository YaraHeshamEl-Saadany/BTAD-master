import 'package:btad/screens/alzheimers_screen.dart';
import 'package:btad/screens/brain_tumor_screen.dart';
import 'package:flutter/material.dart';

import 'package:btad/helpers/firebase_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/user.dart';
import '../screens/appointment_schedule.dart';
import '../screens/medication_screen.dart';
import '../screens/doctor_list_screen.dart';

class PatientView extends StatelessWidget {
  final UserModel user;
  const PatientView({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${auth.currentUser!.email}"),
        actions: [
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "${auth.currentUser!.email}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlzheimerModel(),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.handsBubbles),
                title: const Text("Alzheimer's"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BrainModel(),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.brain),
                title: const Text("Brain Tumor"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AppointmentPage(),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.calendar),
                title: const Text("Schedule Appointment"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlarmPage(),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.addressCard),
                title: const Text("Medicines"),
              ),
              ListTile(
                onTap: () {
                  signOut(context);
                },
                leading: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                title: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlzheimerModel(),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/alzheimer.jpg',
                        fit: BoxFit.cover,
                        width: 400,
                        height: 250,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Alzheimer's",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BrainModel(),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/brain.jpg',
                        fit: BoxFit.cover,
                        width: 400,
                        height: 250,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Brain Tumor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AppointmentPage(),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/alarm.jpg',
                        fit: BoxFit.cover,
                        width: 400,
                        height: 250,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Schedule Appointment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DoctorListScreen(
                        user: user,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/chat.png',
                        fit: BoxFit.cover,
                        width: 400,
                        height: 250,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Chat",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
