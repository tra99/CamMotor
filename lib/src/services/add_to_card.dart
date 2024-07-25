import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrderItemService {
  Future<void> addOrderItem(int orderId, Map<String, dynamic> item) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['BASE_URL']}/order_items'),
      body: jsonEncode({
        'quantity_order': item['quantity_order'],
        'total': item['total'],
        'orderID': orderId,
        'productID': item['productID'],
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add order item: ${response.statusCode}');
    }
  }
}
