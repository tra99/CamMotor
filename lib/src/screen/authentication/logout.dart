// import 'package:cammotor_new_version/src/screen/authentication/login.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// Future<void> _logout() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token');

//   if (token != null) {
//     // Clear token locally
//     await prefs.remove('token');

//     // Send a request to the server to logout (clear token on the server)
//     final response = await http.post(
//       Uri.parse('http://143.198.217.4:1026/api/auth/logout'),
//       headers: {
//         'Authorization': 'Bearer $token', // Assuming token is sent in the header
//       },
//     );

//     if (response.statusCode == 200) {
//       // Successful logout from the server
//       // Navigate to login screen or perform any other actions
//       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
//     } else {
//       // Handle logout failure from the server
//       // Show error message or retry mechanism
//     }
//   }
// }
