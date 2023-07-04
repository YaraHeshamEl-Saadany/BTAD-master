import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String email;
  final String name;
  final List<DateTime> availableTime;

  Doctor({
    required this.id,
    required this.email,
    required this.name,
    required this.availableTime,
  });

  factory Doctor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final List<Timestamp> availableTimeData =
        List<Timestamp>.from(data['availableTime']);

    return Doctor(
      id: snapshot.id,
      email: data['email'],
      name: data['name'],
      availableTime: availableTimeData.map((time) => time.toDate()).toList(),
    );
  }

  static Future<List<Doctor>> getDoctors() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    final doctorsList =
        querySnapshot.docs.map((doc) => Doctor.fromSnapshot(doc)).toList();

    return doctorsList;
  }

  List<DateTime> getAvailableTime() {
    final now = DateTime.now();
    return availableTime.where((time) => time.isAfter(now)).toList();
  }
}


/* class Doctor {
  final String email;
  final String name;
  final List<DateTime> availableTime;

  Doctor({
    required this.email,
    required this.name,
    required this.availableTime,
  });

  factory Doctor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final List<Timestamp> availableTimeData =
        List<Timestamp>.from(data['availableTime']);

    return Doctor(
      email: data['email'],
      name: data['name'],
      availableTime: availableTimeData.map((time) => time.toDate()).toList(),
    );
  }

  static Future<List<Doctor>> getDoctors() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    final doctorsList =
        querySnapshot.docs.map((doc) => Doctor.fromSnapshot(doc)).toList();

    return doctorsList;
  }

  List<DateTime> getavailableTime() {
    final now = DateTime.now();
    return availableTime.where((time) => time.isAfter(now)).toList();
  }
} */
/* 
class Doctor {
  final String email;
  final List<String> name; // Changed type to List<String>
  final List<DateTime> availableTime;

  Doctor({
    required this.email,
    required this.name,
    required this.availableTime,
  });

  factory Doctor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final List<Timestamp> availableTimeData =
        List<Timestamp>.from(data['availableTime']);

    return Doctor(
      email: data['email'],
      name: List<String>.from(data['name']), // Changed type to List<String>
      availableTime: availableTimeData.map((time) => time.toDate()).toList(),
    );
  }

  static Future<List<Doctor>> getDoctors() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    final doctorsList =
        querySnapshot.docs.map((doc) => Doctor.fromSnapshot(doc)).toList();

    return doctorsList;
  }

  List<DateTime> getavailableTime() {
    final now = DateTime.now();
    return availableTime.where((time) => time.isAfter(now)).toList();
  }
}
 */