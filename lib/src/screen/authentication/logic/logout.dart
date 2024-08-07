import 'package:cammotor_new_version/src/screen/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        print('Failed to logout from the server: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during logout request: $error');
    }
  }
}