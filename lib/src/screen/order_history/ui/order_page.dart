import 'package:cammotor_new_version/src/screen/order_history/bloc/order_bloc.dart';
import 'package:cammotor_new_version/src/screen/order_history/ui/view_detail_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late int _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    _userId = await _getUserId();
    setState(() {
      _isLoading = false;
    });
  }

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('id') ?? '0';
    final userId = int.tryParse(storedId) ?? 0;
    // print('UserID: $userId');
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 255),
      body: BlocProvider(
        create: (context) => OrderBloc()..add(FetchOrder(_userId)),
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: const Color.fromARGB(255, 36, 87, 197),
                    child: const Center(
                      child: Text(
                        'ប្រវត្តិការកម្មង់',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.orders.keys.length,
                      itemBuilder: (context, index) {
                        final orderId = state.orders.keys.elementAt(index);
                        final orderList = state.orders[orderId]!;

                        double totalOrderPrice = 0.0;
                        int totalQuantity = 0;

                        for (var order in orderList) {
                          double price = double.tryParse(order.price) ?? 0.0;
                          totalOrderPrice += price * order.quantity;
                          totalQuantity += order.quantity;
                        }

                        String updatedAt = orderList.isNotEmpty ? orderList[0].updatedAt : '';
                        String formatDate(String dateStr) {
                          DateTime date = DateTime.parse(dateStr);
                          String day = DateFormat('dd').format(date);
                          String year = DateFormat('yyyy').format(date);

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

                          String monthInEnglish = DateFormat('MMMM').format(date);
                          String monthInKhmer = khmerMonths[monthInEnglish] ?? monthInEnglish;

                          return '$day/$monthInKhmer/$year';
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(orderList: orderList),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topRight,
                                      child: Text('មើលបន្ថែម...'),
                                    ),
                                    Row(
                                      children: orderList.map((order) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                '${dotenv.env['BASE_URL']}/storage/${order.image}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'ថ្ងៃកម្មង់: ${formatDate(updatedAt)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'ចំនួនសរុប: $totalQuantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'តម្លៃសរុប: \$${totalOrderPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'ការកម្មង់បានជោគជ័យ',
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is OrderError) {
              print( 'Error: ${state.message}');
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No orders loaded'));
            }
          },
        ),
      ),
    );
  }
}
