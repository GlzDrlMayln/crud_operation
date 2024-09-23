import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/student_model.dart'; 

class ApiService {
  final String baseUrl = 'http://192.168.0.32:3000/students'; // Your API URL

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((student) => Student.fromJson(student)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add student');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
