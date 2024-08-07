import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderCard({super.key, required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  List<Map<String, dynamic>> orderItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderItems();
  }

  Future<void> _fetchOrderItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final items = await fetchOrderItems(widget.order['id']);
      setState(() {
        orderItems = items;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderItems(int orderId) async {
    final url = '${dotenv.env['BASE_URL']}/search1/order_items';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'orderID': orderId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('students')) { 
          final List<dynamic> items = data['students'];
          return items.map((item) => item as Map<String, dynamic>).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load order items');
      }
    } catch (e) {
      throw Exception('Error fetching order items: $e');
    }
  }

  int getTotalQuantity() {
    return orderItems.fold(0, (total, item) => total + (item['quantity_order'] as int));
  }

  double getTotalPrice() {
    return orderItems.fold(0.0, (total, item) => total + (item['total'] as num).toDouble());
  }


  @override
  Widget build(BuildContext context) {
    int totalQuantity = getTotalQuantity(); 
    double totalPrice = getTotalPrice();    

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/logo01.png",
                          width: 100,
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Cammotor (24H)",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            Text("${widget.order['created_at']}"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_right_sharp),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orderItems.map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ឈ្មោះទំនិញ: ${item['name']}'),
                        ],
                      );
                    }).toList(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ចំនួនសរុប x $totalQuantity"),
                      Text("តម្លៃសរុប: \$${totalPrice.toStringAsFixed(2)}"),
                      const Text(
                        "ការកម្មង់បានបញ្ចប់",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}