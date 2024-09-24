import 'package:crud_operation/screen/add_student.dart';
import 'package:crud_operation/screen/student_detail.dart'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<dynamic> students = []; // List to hold student data
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchStudents(); // Fetch students when the widget loads
  }

  // Function to fetch students from the API
  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse('https://nodeapi-puce.vercel.app/students'), // Your API URL
      );

      if (response.statusCode == 200) {
        setState(() {
          students = jsonDecode(response.body); // Decode the JSON
          isLoading = false; // Stop loading
        });
      } else {
        print('Failed to load students');
        setState(() {
          isLoading = false; // Stop loading on failure
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  // Function to delete a student by ID
  Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://nodeapi-puce.vercel.app/students/$id'), // Your API URL
      );

      if (response.statusCode == 200) {
        print('Student deleted successfully');
        fetchStudents(); // Refresh the student list
      } else {
        print('Failed to delete student: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to navigate to the Add Student page
  void navigateToAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStudent(),
      ),
    ).then((_) {
      fetchStudents(); // Refresh the student list when coming back
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'), // Title of the app bar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage, // Navigate to AddStudent when pressed
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Shows loading indicator
            )
          : RefreshIndicator(
              onRefresh: fetchStudents, // The function to call when refreshing
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Add padding to the ListView
                child: ListView.builder(
                  itemCount: students.length, // Number of students
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          '${students[index]['firstName']} ${students[index]['lastName']}', // Student name
                        ),
                        onTap: () {
                          // Navigate to StudentDetail when the student card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetail(
                                studentId: students[index]['_id'],
                                firstName: students[index]['firstName'],
                                lastName: students[index]['lastName'],
                                course: students[index]['course'],
                                year: students[index]['year'].toString(),
                                enrolled: students[index]['enrolled'],
                              ),
                            ),
                          ).then((_) {
                            fetchStudents(); // Refresh the student list when coming back
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
