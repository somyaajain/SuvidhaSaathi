import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';

class MedicineReminder extends StatefulWidget {
  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> _medicines = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSavedReminders();
  }

  void _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  void _loadSavedReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedReminders = prefs.getString('medicines');

    if (savedReminders != null) {
      setState(() {
        _medicines = List<Map<String, dynamic>>.from(
            json.decode(savedReminders).map((item) => Map<String, dynamic>.from(item)));
      });

      // 🛠 Re-schedule reminders after restart
      _medicines.forEach((medicine) {
        _scheduleNotification(
          medicine['name'],
          TimeOfDay(hour: medicine['time']['hour'], minute: medicine['time']['minute']),
          List<int>.from(medicine['days']),
        );
      });
    }
  }

  void _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(_medicines);
    await prefs.setString('medicines', encodedData);
  }

  void _addMedicineReminder() {
    String medicineName = '';
    TimeOfDay selectedTime = TimeOfDay.now();
    List<bool> selectedDays = List.generate(7, (_) => false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add Medicine Reminder"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Medicine Name"),
                      onChanged: (value) => medicineName = value,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text("Select Time: ${selectedTime.format(context)}"),
                    ),
                    SizedBox(height: 10),
                    Text("Select Days"),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        return FilterChip(
                          label: Text(
                              ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][index]),
                          selected: selectedDays[index],
                          onSelected: (bool value) {
                            setState(() {
                              selectedDays[index] = value;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (medicineName.isNotEmpty &&
                        selectedDays.contains(true)) {
                      setState(() {
                        _medicines.add({
                          'name': medicineName,
                          'time': {'hour': selectedTime.hour, 'minute': selectedTime.minute},
                          'days': selectedDays.map((e) => e ? 1 : 0).toList(),
                        });
                      });

                      _scheduleNotification(
                          medicineName, selectedTime, selectedDays.map((e) => e ? 1 : 0).toList());
                      _saveReminders();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _scheduleNotification(
      String medicineName, TimeOfDay time, List<int> days) async {
    for (int i = 0; i < 7; i++) {
      if (days[i] == 1) {
        int notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

        var androidDetails = AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminder',
          channelDescription: 'Reminder to take medicine',
          importance: Importance.high,
          priority: Priority.high,
        );

        var notificationDetails =
        NotificationDetails(android: androidDetails);

        DateTime now = DateTime.now();
        DateTime scheduledDate = DateTime(
            now.year, now.month, now.day + (i - now.weekday + 1) % 7, time.hour, time.minute);

        tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          'Medicine Reminder',
          'Time to take $medicineName',
          tzScheduledDate,
          notificationDetails,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine Reminders")),
      body: _medicines.isEmpty
          ? Center(child: Text("No reminders set! Tap + to add."))
          : ListView.builder(
        itemCount: _medicines.length,
        itemBuilder: (context, index) {
          final medicine = _medicines[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                "${medicine['name']} - ${TimeOfDay(hour: medicine['time']['hour'], minute: medicine['time']['minute']).format(context)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Days: ${_getDaysText(medicine['days'])}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _medicines.removeAt(index);
                    _saveReminders();
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addMedicineReminder,
      ),
    );
  }

  String _getDaysText(List<dynamic> days) {
    List<String> weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days.asMap().entries.where((e) => e.value == 1).map((e) => weekDays[e.key]).join(", ");
  }
}
