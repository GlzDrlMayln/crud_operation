import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_student.dart'; 

class StudentDetail extends StatelessWidget {
  final String studentId;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  const StudentDetail({
    Key? key,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  }) : super(key: key);

  // Function to delete the student
  Future<void> deleteStudent(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.32:3000/students/$studentId'), // Your API URL
      );

      if (response.statusCode == 200) {
        print('Student deleted successfully');
        Navigator.pop(context); // Go back to the previous screen
      } else {
        print('Failed to delete student: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to navigate to edit page
  void navigateToEditPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudent(
          studentId: studentId,
          firstName: firstName,
          lastName: lastName,
          course: course,
          year: year,
          enrolled: enrolled,
        ),
      ),
    ).then((_) {
      Navigator.pop(context); // Return to the student list after editing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$firstName $lastName'), // Display student name
        actions: [
          IconButton(
            icon: const Icon(Icons.edit), // Edit icon
            onPressed: () => navigateToEditPage(context), // Navigate to edit page
          ),
          IconButton(
            icon: const Icon(Icons.delete), // Delete icon
            onPressed: () {
              deleteStudent(context); // Delete the student
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: $firstName', style: TextStyle(fontSize: 18)),
            Text('Last Name: $lastName', style: TextStyle(fontSize: 18)),
            Text('Course: $course', style: TextStyle(fontSize: 18)),
            Text('Year: $year', style: TextStyle(fontSize: 18)),
            Text('Enrolled: ${enrolled ? 'Yes' : 'No'}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
