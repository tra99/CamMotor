// // service.dart
// import 'dart:convert';
// import 'package:cammotor_new_version/src/model/pagination.dart';
// import 'package:http/http.dart' as http;

// // original screen service
// class StudentService {
//   Future<List<Model>> fetchStudentData(int currentPage, int pageSize) async {
//     const postUrl = "http://143.198.217.4:1026/api/all/model";
//     final requestBody = jsonEncode({
//       "size": pageSize,
//       "page": currentPage,
//       "id": 11,
//     });

//     final response = await http.post(
//       Uri.parse(postUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: requestBody,
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final studentList = List<Map<String, dynamic>>.from(
//         responseData["student"]["data"],
//       );
//       print(responseData);

//       return studentList.map((studentJson) => Model.fromJson(studentJson)).toList();
//     } else {
//       throw Exception("Failed to load student data");
//     }
//   }
// }
// class CopyService {
//   Future<List<Model>> fetchCopyData(int currentPage, int pageSize) async {
//     const postUrl = "http://143.198.217.4:1026/api/all/model";
//     final requestBody = jsonEncode({
//       "size": pageSize,
//       "page": currentPage,
//       "id": 12,
//     });

//     final response = await http.post(
//       Uri.parse(postUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: requestBody,
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       final studentList = List<Map<String, dynamic>>.from(
//         responseData["student"]["data"],
//       );

//       return studentList.map((studentJson) => Model.fromJson(studentJson)).toList();
//     } else {
//       throw Exception("Failed to load student data");
//     }
//   }
// }
// service.dart
import 'dart:convert';
import 'package:cammotor_new_version/src/model/pagination.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// original screen service
class StudentService {
  Future<List<Model>> fetchStudentData(int currentPage, int pageSize) async {
    var postUrl = "${dotenv.env['BASE_URL']}/all/model";
    final requestBody = jsonEncode({
      "size": pageSize,
      "page": currentPage,
      "id": 20,
    });

    final response = await http.post(
      Uri.parse(postUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final studentList = List<Map<String, dynamic>>.from(
        responseData["student"]["data"],
      );
      print(responseData);

      return studentList.map((studentJson) => Model.fromJson(studentJson)).toList();
    } else {
      throw Exception("Failed to load student data");
    }
  }
}
class CopyService {
  Future<List<Model>> fetchCopyData(int currentPage, int pageSize) async {
    var postUrl = "${dotenv.env['BASE_URL']}/all/model";
    final requestBody = jsonEncode({
      "size": pageSize,
      "page": currentPage,
      "id": 21,
    });

    final response = await http.post(
      Uri.parse(postUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final studentList = List<Map<String, dynamic>>.from(
        responseData["student"]["data"],
      );

      return studentList.map((studentJson) => Model.fromJson(studentJson)).toList();
    } else {
      throw Exception("Failed to load student data");
    }
  }
}