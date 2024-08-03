import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  List<Map<String, dynamic>> _orders = [];

  int? get userId => _userId;
  List<Map<String, dynamic>> get orders => _orders;

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('id');
    if (storedId != null) {
      _userId = int.tryParse(storedId);
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    if (_userId != null) {
      try {
        final response = await http.get(
          Uri.parse('${dotenv.env['BASE_URL']}/orders/$_userId'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['AUTH_TOKEN']}',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = json.decode(response.body);
          _orders = responseData.cast<Map<String, dynamic>>();
          notifyListeners();
        } else {
          print('Failed to fetch orders: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching orders: $e');
      }
    }
  }
}
