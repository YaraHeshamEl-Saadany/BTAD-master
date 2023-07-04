import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Alarm {
  final String id;
  final String title;
  final TimeOfDay time;
  final List<bool> days;
  bool isActive;
  String medicineName;
  int pillCount;

  Alarm({
    required this.id,
    required this.title,
    required this.time,
    required this.days,
    this.isActive = true,
    required this.medicineName,
    required this.pillCount,
  });
}

List<Alarm> alarms = [];
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void addAlarm(String title, TimeOfDay time, List<bool> days,
    String medicineName, int pillCount) {
  String id = UniqueKey().toString();
  Alarm newAlarm = Alarm(
    id: id,
    title: title,
    time: time,
    days: days,
    medicineName: medicineName,
    pillCount: pillCount,
  );
  alarms.add(newAlarm);
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  final String timeZoneName =
      tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()).name;
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future onSelectNotification(String? payload) async {
  // Handle notification selection here, e.g., navigate to a specific page
}

Future<void> scheduleAlarmNotifications() async {
  tz.initializeTimeZones();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  for (int i = 0; i < alarms.length; i++) {
    Alarm alarm = alarms[i];
    if (alarm.isActive) {
      for (int j = 0; j < alarm.days.length; j++) {
        if (alarm.days[j]) {
          final String timeZoneName = tz
              .getLocation(await FlutterNativeTimezone.getLocalTimezone())
              .name;
          tz.setLocalLocation(tz.getLocation(timeZoneName));
          DateTime scheduledTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            alarm.time.hour,
            alarm.time.minute,
          );
          int difference = j - DateTime.now().weekday;
          if (difference < 0) {
            difference += 7;
          }
          scheduledTime = scheduledTime.add(Duration(days: difference));
          final scheduledTimeZone = tz.getLocation(timeZoneName);
          final scheduledTZDateTime = tz.TZDateTime.from(
            scheduledTimeZone as DateTime,
            scheduledTime as tz.Location,
          );

          final AndroidNotificationDetails androidChannelSpecifics =
              AndroidNotificationDetails(
            'alarm_channel_id',
            'Alarm Channel',
            sound: RawResourceAndroidNotificationSound(
                'success_fanfare_trumpets_6185'),
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          );

          final NotificationDetails platformSpecifics =
              NotificationDetails(android: androidChannelSpecifics);

          await flutterLocalNotificationsPlugin.zonedSchedule(
            i,
            'Medicine Reminder',
            'It\'s time to take ${alarm.medicineName} - ${alarm.pillCount} pill(s)',
            scheduledTZDateTime,
            platformSpecifics,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
          );
        }
      }
    }
  }
}

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  bool _switchValue = true;
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _pillCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _pillCountController.dispose();
    super.dispose();
  }

  Future<void> _addAlarm() async {
    List<bool> _days = List.filled(7, false);
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_pickedTime != null) {
      await showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose days',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              ToggleButtons(
                children: [
                  Text('Sun'),
                  Text('Mon'),
                  Text('Tue'),
                  Text('Wed'),
                  Text('Thu'),
                  Text('Fri'),
                  Text('Sat'),
                ],
                isSelected: _days,
                onPressed: (int index) {
                  setState(() {
                    _days[index] = !_days[index];
                  });
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: _medicineNameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _pillCountController,
                decoration: InputDecoration(
                  labelText: 'Pill Count',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showSnackbar('Alarm added');
                      addAlarm(
                        _switchValue ? 'Medicines' : 'Pill',
                        _pickedTime,
                        _days,
                        _medicineNameController.text,
                        int.tryParse(_pillCountController.text) ?? 0,
                      );
                      scheduleAlarmNotifications();
                      setState(() {
                        _medicineNameController.clear();
                        _pillCountController.clear();
                      });
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String getDaysString(List<bool> days) {
    List<String> dayStrings = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    String result = '';
    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        result += dayStrings[i] + ', ';
      }
    }
    if (result.length > 2) {
      result = result.substring(0, result.length - 2);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines Alarm'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          Alarm alarm = alarms[index];
          return Dismissible(
            key: Key(alarm.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                alarms.removeAt(index);
              });
            },
            child: SwitchListTile(
              title: Text(alarm.title),
              subtitle: Text(
                '${alarm.time.format(context)} | ${getDaysString(alarm.days)}',
              ),
              secondary: Icon(Icons.alarm),
              value: alarm.isActive,
              onChanged: (bool value) {
                setState(() {
                  alarm.isActive = value;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        tooltip: 'Add Alarm',
        child: Icon(Icons.add),
      ),
    );
  }
}
