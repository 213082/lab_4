import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamWidget extends StatefulWidget {
  final Function(Exam) addExam;

  const ExamWidget({required this.addExam, super.key});

  @override
  ExamWidgetState createState() => ExamWidgetState();
}

class ExamWidgetState extends State<ExamWidget> {
  final TextEditingController courseController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        selectedDate = datePicked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (timePicked != null && timePicked != selectedTime) {
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          timePicked.hour,
          timePicked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ElevatedButton(
                  child: const Text('Select Date', style: TextStyle(color: Colors.white),),
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,  // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Time: ${selectedDate.toLocal().toString().split(' ')[1].substring(0, 5)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,  // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Exam exam = Exam(
                  course: courseController.text,
                  timestamp: selectedDate,
                );
                widget.addExam(exam);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,  // Button background color
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Add Exam',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
