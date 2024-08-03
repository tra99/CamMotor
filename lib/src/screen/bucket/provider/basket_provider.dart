import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BasketProvider with ChangeNotifier {
  List<Map<String, dynamic>> _basketItems = [];
  Map<int, bool> _checkedItems = {};
  String? _orderId;

  List<Map<String, dynamic>> get basketItems => _basketItems;
  Map<int, bool> get checkedItems => _checkedItems;
  String? get orderId => _orderId;

  BasketProvider() {
    _loadBasketItems();
  }

  Future<void> _loadBasketItems() async {
    final prefs = await SharedPreferences.getInstance();
    final basketStringList = prefs.getStringList('basketItems') ?? [];

    _basketItems = basketStringList.map((item) {
      return Map<String, dynamic>.from(jsonDecode(item));
    }).toList();

    _orderId = prefs.getString('orderId');
    notifyListeners();
  }

  Future<void> _storeOrderId(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    _orderId = orderId;
    notifyListeners();
  }

  Future<void> addItemToBasket(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final basketStringList = prefs.getStringList('basketItems') ?? [];

    basketStringList.add(jsonEncode(item));

    await prefs.setStringList('basketItems', basketStringList);

    _basketItems.add(item);
    notifyListeners();
  }

  Future<void> removeBasketItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final itemToRemove = _basketItems[index];
    _basketItems.removeAt(index);

    final updatedBasketStringList = _basketItems.map((item) {
      return jsonEncode(item);
    }).toList();

    await prefs.setStringList('basketItems', updatedBasketStringList);
    notifyListeners();

    if (_basketItems.isEmpty && _orderId != null) {
      _orderId = null;
      prefs.remove('orderId');
    }
  }

  void updateCheckedItems(int index, bool value) {
    _checkedItems[index] = value;
    notifyListeners();
  }

  double calculateTotal() {
    double total = 0.0;
    for (var item in _basketItems) {
      if (_checkedItems[_basketItems.indexOf(item)] == true) {
        total += (item['price'] ?? 0.0) * (item['quantity'] ?? 0);
      }
    }
    return total;
  }

  final _basketCountController = StreamController<int>.broadcast();
  int _basketCount = 0;

  Stream<int> get basketCountStream => _basketCountController.stream;

  void incrementBasketCount() {
    _basketCount++;
    _basketCountController.sink.add(_basketCount);
  }

  void decrementBasketCount() {
    if (_basketCount > 0) {
      _basketCount--;
      _basketCountController.sink.add(_basketCount);
    }
  }

  void setBasketCount(int count) {
    _basketCount = count;
    _basketCountController.sink.add(_basketCount);
  }

  void dispose() {
    _basketCountController.close();
  }
}
