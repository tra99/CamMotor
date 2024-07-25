import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/store_basket.dart';
import '../homepage.dart';
import 'basket_notifier.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({Key? key}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<Map<String, dynamic>> basketItems = [];
  Map<int, bool> _checkedItems = {};
  String? _orderId;

  @override
  void initState() {
    super.initState();
    _loadBasketItems();
  }

  Future<void> _storeOrderId(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId); 
    print('Stored order ID: $orderId');
  }

  Future<void> _loadBasketItems() async {
    final prefs = await SharedPreferences.getInstance();
    final basketStringList = prefs.getStringList('basketItems') ?? [];

    List<Map<String, dynamic>> loadedItems = basketStringList.map((item) {
      final decodedItem = Map<String, dynamic>.from(jsonDecode(item));
      return decodedItem;
    }).toList();

    setState(() {
      basketItems = loadedItems;
      _orderId = prefs.getString('orderId');
    });

    print('Loaded order ID: $_orderId');
    _updateBasketCount();
  }

  Future<void> _addItemToBasket(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final basketStringList = prefs.getStringList('basketItems') ?? [];

    basketStringList.add(jsonEncode(item));

    await prefs.setStringList('basketItems', basketStringList);

    setState(() {
      basketItems.add(item);
    });

    _updateBasketCount();
  }

  Future<void> _removeBasketItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final itemToRemove = basketItems[index];
    basketItems.removeAt(index);
    final updatedBasketStringList = basketItems.map((item) {
      return jsonEncode(item);
    }).toList();

    await prefs.setStringList('basketItems', updatedBasketStringList);
    setState(() {});
    BasketNotifier.decrementCount(itemToRemove['quantity'] as int);

    if (basketItems.isEmpty && _orderId != null) {
      setState(() {
        _orderId = null;
      });
      prefs.remove('orderId');
    }
  }

  void _updateBasketCount() {
    final totalCount = basketItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    BasketNotifier.updateCount(totalCount);
  }

  Future<void> _fetchDataStoreBasketModel(int subcategoryID) async {
    try {
      final response = await fetchDataStoreBasketModel(subcategoryID);
      print('Server response: $response');

      if (response.containsKey('orderId')) {
        final orderId = response['orderId'].toString();
        print('Extracted order ID: $orderId');
        setState(() {
          _orderId = orderId;
        });
        await _storeOrderId(orderId);
      } else {
        print('Unexpected response structure');
        setState(() {
          _orderId = null;
        });
      }
      print('Loaded order ID: $_orderId');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _postOrderItem(Map<String, dynamic> item) async {
    final String url = '${dotenv.env['BASE_URL']}/order_items';

    final int quantity = item['quantity'] ?? 0;
    final double? price = item['price']?.toDouble();

    if (quantity == 0 || price == null) {
      print('Error: Quantity or price is null');
      print('Item: $item');
      return;
    }

    final body = {
      "quantity_order": quantity,
      "total": price * quantity,
      "orderID": _orderId,
      "productID": item['productId'],
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        print('Order item posted successfully');
      } else {
        print('Failed to post order item. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting order item: $e');
    }
  }

  Future<bool> _updateOrder(int subcategoryID) async {
    final result = await fetchDataStoreBasketModel(subcategoryID);
    if (result.containsKey('orderId') && result.containsKey('userID')) {
      final orderId = result['orderId'];
      final userId = result['userID'];
      await updateOrder(subcategoryID, 0, orderId, userId);
      return true;
    } else {
      return false;
    }
  }

  bool _isAnyItemChecked() {
    return _checkedItems.values.any((isChecked) => isChecked);
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var item in basketItems) {
      if (_checkedItems[basketItems.indexOf(item)] == true) {
        total += (item['price'] ?? 0.0) * (item['quantity'] ?? 0);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 233, 233),
        title: const Text('កន្ត្រកទំនិញរបស់ខ្ញុំ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: basketItems.isEmpty
                ? const Center(child: Text('Your basket is empty'))
                : ListView.builder(
                    itemCount: basketItems.length,
                    itemBuilder: (context, index) {
                      final item = basketItems[index];
                      final imageUrl = '${item['img']}';
                      return Card(
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _checkedItems[index] ?? false,
                                checkColor: const Color.fromARGB(255, 8, 98, 11),
                                focusColor: Colors.green,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checkedItems[index] = value ?? false;
                                    _postOrderItem(item);
                                  });
                                },
                                activeColor: const Color.fromARGB(255, 231, 219, 219),
                              ),
                              item['img'] != null
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          title: Text(item['productName'] ?? 'Unknown Product'),
                          subtitle: Text('ចំនួន x ${item['quantity']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              print('Removing item: $item');
                              _removeBasketItem(index);
                            },
                          ),
                          onTap: () async {
                            print('Item: $item');
                            print('Product ID: ${item['productId']}');
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: _isAnyItemChecked()
                  ? () async {
                      if (_orderId != null) {
                        final orderUpdated = await _updateOrder(2);
                        if (orderUpdated) {
                          _dialogSuccess(_calculateTotal());
                        } else {
                          print('Failed to update order');
                        }
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('orderId');
                        setState(() {
                          _orderId = null;
                        });
                      } else {
                        print('No order ID found');
                      }
                    }
                  : null,

                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 80, 70, 72),
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  shadowColor: Colors.blueGrey,
                  elevation: 5,
                ),
                child: const Text('ទិញ'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

  void _dialogSuccess(double total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Order Success!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 80, 70, 72),
                      shadowColor: Colors.grey,
                      side: const BorderSide(color: Colors.white, width: 2),
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified),
                        SizedBox(width: 8.0),
                        Text(
                          'ទិញបានជោគជ័យ',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
