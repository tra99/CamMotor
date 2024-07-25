import 'package:flutter/material.dart';
import '../services/store_basket.dart';

class StoreBasketScreenTest extends StatefulWidget {
  @override
  _StoreBasketScreenTestState createState() => _StoreBasketScreenTestState();
}

class _StoreBasketScreenTestState extends State<StoreBasketScreenTest> {
  final TextEditingController _totalController = TextEditingController();
  String? _result = '';

  void _fetchDataStoreBasketModel() {
    // Call the function to fetch data passing the total amount
    int total = int.tryParse(_totalController.text) ?? 0;
    fetchDataStoreBasketModel(total)
        .then((storeBasketModels) {
          // Handle the result here
          setState(() {
            _result = 'Success: ${storeBasketModels.toString()}';
          });
        })
        .catchError((error) {
          // Handle any errors here
          setState(() {
            _result = 'Error: $error';
            print("$error"); // Print the error for debugging
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _totalController,
              decoration: const InputDecoration(
                labelText: 'Total Amount',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchDataStoreBasketModel,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 16.0),
            Text('Result: $_result'),
          ],
        ),
      ),
    );
  }
}
