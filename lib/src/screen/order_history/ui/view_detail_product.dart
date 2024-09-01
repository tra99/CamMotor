import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cammotor_new_version/src/model/order_model.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  final List<Order> orderList;

  const OrderDetailsScreen({super.key, required this.orderList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 137, 249),
        title: Image.asset(
          "assets/images/logo3.png",
          width: 140,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 36, 87, 197),
            child: const Center(
              child: Text(
                'លម្អិតទំនិញ',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final order = orderList[index];
                double price = double.tryParse(order.price) ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            '${dotenv.env['BASE_URL']}/storage/${order.image}',
                            width: double.infinity,
                            // height: MediaQuery.of(context).size.height*0.6,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ទំនិញ: ${order.name}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text(
                                          'កាលបរិច្ឆេទ:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          ' ${_formatDateTime(order.updatedAt)}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 130, 130, 130),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'តម្លៃ: \$${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Quantity: \$${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'សរុប: \$${(price * order.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'លេខទំនាក់ទនង: 012​ 994 244',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text(
                                          'លម្អិត: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          order.description,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 134, 134, 134),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'ការកម្មង់ជោគជ័យ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr).add(const Duration(hours: 7));
    Map<String, String> khmerMonths = {
      'January': 'មករា',
      'February': 'កុម្ភៈ',
      'March': 'មីនា',
      'April': 'មេសា',
      'May': 'ឧសភា',
      'June': 'មិថុនា',
      'July': 'កក្កដា',
      'August': 'សីហា',
      'September': 'កញ្ញា',
      'October': 'តុលា',
      'November': 'វិច្ឆិកា',
      'December': 'ធ្នូ',
    };
    String day = DateFormat('dd').format(dateTime);
    String year = DateFormat('yyyy').format(dateTime);
    String monthInEnglish = DateFormat('MMMM').format(dateTime);
    String monthInKhmer = khmerMonths[monthInEnglish] ?? monthInEnglish;
    String time = DateFormat('h:mm a').format(dateTime);

    return '$day/$monthInKhmer/$year $time';
  }
}
