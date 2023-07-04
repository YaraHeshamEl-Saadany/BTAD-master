import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Alarm> alarms = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      DateTime dateTime, String medicineName, int numberOfPills) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('sound_file'),
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Alarm: $medicineName',
      'Number of pills: $numberOfPills',
      dateTime,
      platformChannelSpecifics,
      payload: '',
    );
  }

  void addAlarm(DateTime dateTime, String medicineName, int numberOfPills) {
    final newAlarm = Alarm(
      dateTime: dateTime,
      medicineName: medicineName,
      numberOfPills: numberOfPills,
    );

    setState(() {
      alarms.add(newAlarm);
      scheduleNotification(dateTime, medicineName, numberOfPills);
    });

    _listKey.currentState!.insertItem(alarms.length - 1);
  }

  void deleteSelectedAlarms(List<int> selectedIndices) {
    selectedIndices.sort((a, b) => b.compareTo(a));

    setState(() {
      for (final index in selectedIndices) {
        final alarm = alarms.removeAt(index);
        flutterLocalNotificationsPlugin.cancel(alarm.hashCode);
        _listKey.currentState!.removeItem(
          index,
          (BuildContext context, Animation<double> animation) =>
              Container(), // Dummy widget to support removal animation
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: alarms.length,
              itemBuilder: (context, index, animation) {
                final alarm = alarms[index];
                return buildAlarmTile(alarm, animation);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => showAddAlarmDialog(context),
              child: const Text('Add Alarm'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAlarmTile(Alarm alarm, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        title:
            Text('Alarm: ${DateFormat.yMd().add_jm().format(alarm.dateTime)}'),
        subtitle: Text(
            'Medicine: ${alarm.medicineName}, Pills: ${alarm.numberOfPills}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => deleteSelectedAlarms([alarms.indexOf(alarm)]),
        ),
      ),
    );
  }

  Future<void> showAddAlarmDialog(BuildContext context) async {
    DateTime selectedDateTime = DateTime.now();
    String medicineName = '';
    int numberOfPills = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Alarm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final dateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (dateTime != null) {
                    final timeOfDay = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (timeOfDay != null) {
                      selectedDateTime = DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                    }
                  }
                },
                child: const Text('Select Date and Time'),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Medicine Name'),
                onChanged: (value) => medicineName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Number of Pills'),
                keyboardType: TextInputType.number,
                onChanged: (value) => numberOfPills = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addAlarm(selectedDateTime, medicineName, numberOfPills);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class Alarm {
  final DateTime dateTime;
  final String medicineName;
  final int numberOfPills;

  Alarm({
    required this.dateTime,
    required this.medicineName,
    required this.numberOfPills,
  });
}
