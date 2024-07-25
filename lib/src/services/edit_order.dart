// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// Future<void> updateOrder(int total, int status, int orderId, int userId) async {
//   try {
//     // Log the orderId and userId to check their values
//     print('Updating order with orderId: $orderId and userID: $userId');

//     // Perform the POST request to update the order
//     final response = await http.post(
//       Uri.parse('${dotenv.env['BASE_URL']}/order/$orderId/edit'),
//       body: jsonEncode({
//         'total': total,
//         'status': status,
//         'userID': userId, // Send userID as an integer
//       }),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );

//     final responseBody = response.body;
//     print('Update response: $responseBody');

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(responseBody);
//       if (jsonData.containsKey('status') && jsonData['status'] == 200) {
//         print('Order Updated Successfully');
//       } else {
//         throw Exception('Unexpected response format or error: ${jsonData['message']}');
//       }
//     } else {
//       throw Exception('Failed to update order: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Exception caught: $e');
//     print('Error updating order: $e');
//   }
// }
