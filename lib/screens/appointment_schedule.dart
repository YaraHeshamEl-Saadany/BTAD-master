import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';
import '../models/doctor.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  List<Doctor> doctors = [];
  Doctor? selectedDoctor;
  List<DateTime> availableTimeSlots = [];
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    List<Doctor> fetchedDoctors = await Doctor.getDoctors();
    setState(() {
      doctors = fetchedDoctors;
    });
  }

  void updateAvailableTimeSlots() {
    // ignore: unnecessary_null_comparison
    if (selectedDoctor != null) {
      List<DateTime> availableTime = selectedDoctor!.getAvailableTime();
      setState(() {
        availableTimeSlots = availableTime;
      });
    }
  }

  void scheduleAppointment() async {
    if (_formKey.currentState!.validate() &&
        selectedDoctor != null &&
        // ignore: unnecessary_null_comparison
        selectedTime != null) {
      String patientName = _nameController.text;
      String patientEmail = _emailController.text;
      String patientPhone = _phoneController.text;

      Appointment appointment = Appointment(
        doctorId: selectedDoctor!.id,
        doctorName: selectedDoctor!.name,
        patientName: patientName,
        patientEmail: patientEmail,
        patientPhone: patientPhone,
        date: selectedTime,
        isReserved: true,
      );
      List<DateTime> updatedAvailableTime =
          List<DateTime>.from(selectedDoctor!.availableTime);
      updatedAvailableTime.remove(selectedTime);
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(selectedDoctor!.id)
          .update({
        'availableTime': updatedAvailableTime
            .map((time) => Timestamp.fromDate(time))
            .toList()
      });

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointment.toJson());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Appointment Scheduled'),
            content:
                const Text('Your appointment has been scheduled successfully.'),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Appointment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Doctor>(
                  value: selectedDoctor,
                  onChanged: (Doctor? doctor) {
                    setState(() {
                      selectedDoctor = doctor!;
                      updateAvailableTimeSlots();
                    });
                  },
                  items: doctors.map((Doctor doctor) {
                    return DropdownMenuItem<Doctor>(
                      value: doctor,
                      child: Text(doctor.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Doctor',
                  ),
                ),
                // ignore: unnecessary_null_comparison
                if (selectedDoctor != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Available Time Slots:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: availableTimeSlots.map((DateTime time) {
                      return ListTile(
                        title: Text(time.toString()),
                        onTap: () {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: scheduleAppointment,
                  child: const Text('Schedule Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
