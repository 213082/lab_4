import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/exam_widget.dart';
import '../widgets/map_widget.dart';
import '../models/exam.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../notification_controller.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Exam> exams = [
    Exam(course: 'OOP', timestamp: DateTime.now()),
    Exam(course: 'KMB', timestamp: DateTime(2025, 01, 22)),
    Exam(course: 'OS', timestamp: DateTime(2025, 01, 23)),
    Exam(course: 'WP', timestamp: DateTime(2025, 01, 24)),
    Exam(course: 'VNP', timestamp: DateTime(2025, 01, 27)),
  ];

  bool _isLocationBasedNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceiveMethod,
      onDismissActionReceivedMethod:
      NotificationController.onDismissActionReceiveMethod,
      onNotificationCreatedMethod:
      NotificationController.onNotificationCreateMethod,
      onNotificationDisplayedMethod:
      NotificationController.onNotificationDisplayed,
    );

    NotificationService().scheduleNotificationsForExistingExams(exams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Upcoming Exams',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: _isLocationBasedNotificationsEnabled
                  ? Colors.amberAccent
                  : Colors.white,
            ),
            onPressed: _toggleLocationNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: _openMap,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _openCalendar,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.currentUser != null
                ? _addExamFunction(context)
                : _navigateToSignInPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return _buildExamCard(exams[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildExamCard(Exam exam) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8,
      color: Colors.white,
      shadowColor: Colors.deepPurple.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exam.course,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _formatTimestamp(exam.timestamp),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }

  void _toggleLocationNotifications() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Based Notifications"),
          content: _isLocationBasedNotificationsEnabled
              ? const Text("You have turned off location-based notifications")
              : const Text("You have turned on location-based notifications"),
          actions: [
            TextButton(
              onPressed: () {
                NotificationService().toggleLocationNotification();
                setState(() {
                  _isLocationBasedNotificationsEnabled =
                  !_isLocationBasedNotificationsEnabled;
                });
                Navigator.pop(context);
              },
              child: const Text("OK", style: TextStyle(color: Colors.deepPurple)),
            )
          ],
        );
      },
    );
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarWidget(exams: exams),
      ),
    );
  }

  void _openMap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MapWidget()));
  }

  Future<void> _addExamFunction(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: ExamWidget(
            addExam: _addExam,
          ),
        );
      },
    );
  }

  void _addExam(Exam exam) {
    setState(() {
      exams.add(exam);
      NotificationService().scheduleNotification(exam);
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void _navigateToSignInPage(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}
