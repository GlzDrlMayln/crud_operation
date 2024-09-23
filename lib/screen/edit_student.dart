import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStudent extends StatefulWidget {
  final String studentId;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  const EditStudent({
    super.key,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String? selectedYear;
  bool isEnrolled = false;

  final List<String> yearOptions = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    courseController.text = widget.course;
    selectedYear = widget.year;
    isEnrolled = widget.enrolled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                hintText: "First Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                hintText: "Last Name",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                hintText: "Course",
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              items: yearOptions.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Enrolled'),
                Switch(
                  value: isEnrolled,
                  onChanged: (bool newValue) {
                    setState(() {
                      isEnrolled = newValue;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateStudent();
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateStudent() async {
    final Map<String, dynamic> body = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "course": courseController.text,
      "year": int.tryParse(selectedYear ?? '0'),
      "enrolled": isEnrolled,
    };

    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.32:3000/students/${widget.studentId}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Student updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        print('Failed to update student: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
