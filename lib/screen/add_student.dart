import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  
  // Create FocusNode for managing focus
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode courseFocus = FocusNode();

  String? selectedYear;
  bool isEnrolled = false;

  // Year options
  final List<String> yearOptions = ['1', '2', '3', '4', '5'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    courseController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    courseFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              focusNode: firstNameFocus,
              decoration: const InputDecoration(hintText: "First Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              focusNode: lastNameFocus,
              decoration: const InputDecoration(hintText: "Last Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: courseController,
              focusNode: courseFocus,
              decoration: const InputDecoration(hintText: "Course"),
            ),
            const SizedBox(height: 20),

            // Dropdown for year selection
            DropdownButtonFormField<String>(
              value: selectedYear,
              decoration: const InputDecoration(labelText: 'Year'),
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

            // Switch for enrolled status
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
                submitData();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    // Get the form data
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final course = courseController.text;
    final year = selectedYear;
    final enrolled = isEnrolled;

    final Map<String, dynamic> body = {
      "firstName": firstName,
      "lastName": lastName,
      "course": course,
      "year": int.tryParse(year ?? '0'),
      "enrolled": enrolled,
    };

    // Post/submit data to the server
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.32:3000/students'), // Change this if using a remote server
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print('Student added successfully');

        // Show a SnackBar to display the success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Student added successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Clear the text fields and reset the form
        firstNameController.clear();
        lastNameController.clear();
        courseController.clear();
        setState(() {
          selectedYear = null; // Reset the dropdown
          isEnrolled = false; // Reset the switch
        });
      } else {
        print('Failed to add student: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
