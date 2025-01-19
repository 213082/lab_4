import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/exam.dart';

class CalendarWidget extends StatelessWidget {
  final List<Exam> exams;

  const CalendarWidget({super.key, required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Exams',
        style: TextStyle(
            color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _getCalendarDataSource(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _handleDateTap(context, details.date!);
          }
        },
        todayHighlightColor:Colors.teal,
        todayTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var exam in exams) {
      appointments.add(Appointment(
        startTime: exam.timestamp,
        endTime: exam.timestamp.add(const Duration(hours: 2)),
        subject: exam.course,
        color: Colors.teal, // Set a specific color for exam appointments
      ));
    }

    return _DataSource(appointments);
  }

  void _handleDateTap(BuildContext context, DateTime selectedDate) {
    List<Exam> selectedExams = exams
        .where((exam) =>
    exam.timestamp.year == selectedDate.year &&
        exam.timestamp.month == selectedDate.month &&
        exam.timestamp.day == selectedDate.day)
        .toList();

    if (selectedExams.isNotEmpty) {
      _showExamsDialog(context, selectedDate, selectedExams);
    }
  }

  void _showExamsDialog(
      BuildContext context, DateTime selectedDate, List<Exam> exams) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exams on ${selectedDate.toLocal()}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: exams
                .map((exam) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '${exam.course} - ${exam.timestamp.hour}:${exam.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
            ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
