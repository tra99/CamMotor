// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../model/bottom_sheet.dart';

// List<Student> cachedData = [];

// Future<List<Student>> fetchData() async {
//   if (cachedData.isNotEmpty) {
//     // If cached data is available, return it immediately.
//     return cachedData;
//   }

//   try {
//     final response = await http.get(Uri.parse('http://143.198.217.4:1026/api/Product'));

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);

//       if (jsonData.containsKey('students')) {
//         final List<dynamic> studentListJson = jsonData['students'];

//         // Parse the JSON data into a List of Student objects
//         List<Student> students = studentListJson.map((studentJson) {
//           return Student.fromJson(studentJson);
//         }).toList();

//         // Cache the data for future use
//         cachedData = students;

//         return students;
//       } else {
//         throw Exception('Invalid JSON structure: Missing "students" key');
//       }
//     } else {

//       throw Exception('Failed to load data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print(e);
//     if (cachedData.isNotEmpty) {
//       // If cached data is available, return it along with the error.
//       return cachedData;
//     } else {
//       throw e; // If there's no cached data, rethrow the error.
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/bottom_sheet.dart';

List<Student> cachedData = [];

Future<List<Student>> fetchData() async {
  if (cachedData.isNotEmpty) {
    // If cached data is available, return it immediately.
    return cachedData;
  }

  final apiUrl = '${dotenv.env['BASE_URL']}/Product'; // The API URL

  try {
    print('Fetching data from: $apiUrl'); // Print the URL
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.containsKey('students')) {
        final List<dynamic> studentListJson = jsonData['students'];

        // Parse the JSON data into a List of Student objects
        List<Student> students = studentListJson.map((studentJson) {
          return Student.fromJson(studentJson);
        }).toList();

        // Cache the data for future use
        cachedData = students;

        return students;
      } else {
        throw Exception('Invalid JSON structure: Missing "students" key');
      }
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Connection error: $e"); // Print the error for debugging purposes
    if (cachedData.isNotEmpty) {
      // If cached data is available, return it along with the error.
      return cachedData;
    } else {
      throw e; // If there's no cached data, rethrow the error.
    }
  }
}
