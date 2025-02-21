import 'package:flutter/material.dart';
import 'file1.dart'; // Import file1 (Login Page)
import 'file2.dart'; // Import file2
import 'file3.dart'; // Import file3 (Caregiver Page)
import 'home.dart'; // Import Home Page
import 'sos_page.dart';
import 'medicine_reminder.dart';
import 'package:suvidha_saathi/notification_service.dart'; // Import NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Initialize Notifications
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suvidha Saathi',
      initialRoute: '/', // Default route to the Login page
      routes: {
        '/': (context) => File1(), // Login Page (File1)
        '/file2': (context) => File2(),
        '/home': (context) => home(), // Home Page
        '/file3': (context) => File3(), // Caregiver Page (File3)
        '/sos_page': (context) => SOSPage(),
      },
    );
  }
}
//
//
// import 'package:flutter/material.dart';
// import 'file1.dart'; // Import file1
// import 'file2.dart'; // Import file2
// import 'file3.dart'; // Import file3
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Navigation',
//       initialRoute: '/', // Default route
//       routes: {
//         '/': (context) => File1(), // Login Page (correct capitalization)
//         '/file2': (context) => File2(), // Form Page (correct capitalization)
//         '/file3': (context) => File3(), // Caregiver Page (correct capitalization)
//       },
//     );
//   }
// }
//
