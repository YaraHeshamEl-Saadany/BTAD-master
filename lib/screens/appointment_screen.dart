import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Appiontment extends StatefulWidget {
  const Appiontment({
    super.key,
  });

  @override
  State<Appiontment> createState() => _AppiontmentState();
}

class _AppiontmentState extends State<Appiontment> {
  DateTime? _selectedDate;

  void _openDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day + 1);
    final lastDate = DateTime(now.year, now.month + 1, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Schedule Appointment'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _selectedDate == null
                ? 'Select Date'
                : formatter.format(_selectedDate!),
          ),
          IconButton(
            onPressed: _openDatePicker,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
