import 'package:btad/screens/alzheimers_screen.dart';
import 'package:btad/screens/brain_tumor_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:btad/helpers/firebase_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/* import '../models/chat.dart';
import '../models/user.dart'; */

import '../screens/alarm_screen.dart';
import '../screens/appointment_schedule.dart';

// import '../screens/chat_screen.dart';
import '../screens/doctor_record.dart';

import '../screens/patient_record.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

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
              /*Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PatientRecordPage(userEmail: user.email),
  ),
);
 */
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientRecordsPage(
                          userEmail: "${auth.currentUser!.email}"),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.addressCard),
                title: const Text("Records"),
              ),
              //DoctorPatientRecordPage
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorPatientRecordPage(
                          userEmail: "${auth.currentUser!.email}"),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.addressCard),
                title: const Text("Records"),
              ),
/*               ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                          chat: Chat(
                              id: '',
                              message: '',
                              receiverId: '',
                              senderId: '',
                              timestamp: '' as Timestamp),
                          user: const UserModel(
                              email: '',
                              firstName: '',
                              lastName: '',
                              role: '')),
                    ),
                  );
                },
                leading: const FaIcon(FontAwesomeIcons.addressCard),
                title: const Text("chats"),
              ), */
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
                        width: 400, // Set the width to 80
                        height: 250, // Set the height to 50
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
                        width: 400, // Set the width to 80
                        height: 250, // Set the height to 50
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
                        width: 400, // Set the width to 80
                        height: 250, // Set the height to 50
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
            ],
          ),
        ),
      ),
    );
  }
}
