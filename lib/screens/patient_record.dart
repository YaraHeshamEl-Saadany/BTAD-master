import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientRecordsPage extends StatefulWidget {
  final String userEmail;

  PatientRecordsPage({required this.userEmail});

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  List<Map<String, dynamic>> appointmentDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Get the Firestore instance
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the appointments collection based on the logged-in user's email
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('appointments')
        .where('patientEmail', isEqualTo: widget.userEmail)
        .get();

    // Iterate over the documents in the query result
    List<Map<String, dynamic>> data = [];
    for (DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      final appointmentData = document.data()!;
      data.add({
        'doctorName': appointmentData['doctorName'],
        'date': appointmentData['date'].toDate(),
      });
    }

    setState(() {
      appointmentDataList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Records'),
      ),
      body: ListView.builder(
        itemCount: appointmentDataList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> appointmentData = appointmentDataList[index];
          String doctorName = appointmentData['doctorName'];
          DateTime date = appointmentData['date'];

          return ListTile(
            title: Text('Doctor Name: $doctorName'),
            subtitle: Text('Date: $date'),
          );
        },
      ),
    );
  }
}
