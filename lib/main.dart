import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Awesome Notifications with custom channel and group names
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "user_notifications_group",
        channelKey: "exam_notifications_channel",
        channelName: "Upcoming Exam Reminders",
        channelDescription: "Reminders for your upcoming exams",
      ),
      NotificationChannel(
        channelGroupKey: "user_notifications_group",
        channelKey: "general_notifications_channel",
        channelName: "General Notifications",
        channelDescription: "General notifications for the app",
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: "user_notifications_group",
          channelGroupName: "User Notifications Group"
      ),
    ],
  );

  if (!(await AwesomeNotifications().isNotificationAllowed())) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const AuthScreen(isLogin: true),
        '/register': (context) => const AuthScreen(isLogin: false),
      },
    );
  }
}
