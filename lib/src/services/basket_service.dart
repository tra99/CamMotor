import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveBasketItem(String productName, int quantity, String img) async {
  final prefs = await SharedPreferences.getInstance();
  final basketItems = prefs.getStringList('basketItems') ?? [];
  final itemIndex = basketItems.indexWhere((item) {
    final decodedItem = jsonDecode(item);
    return decodedItem['productName'] == productName;
  });

  if (itemIndex != -1) {
    final decodedItem = jsonDecode(basketItems[itemIndex]);
    decodedItem['quantity'] += quantity;
    basketItems[itemIndex] = jsonEncode(decodedItem);
  } else {
    final basketItem = jsonEncode({
      'productName': productName,
      'quantity': quantity,
      'img': img,
    });
    basketItems.add(basketItem);
  }

  await prefs.setStringList('basketItems', basketItems);
}

Future<void> updateBasketItemQuantity(String productName, int quantity) async {
  final prefs = await SharedPreferences.getInstance();
  final basketItems = prefs.getStringList('basketItems') ?? [];
  final itemIndex = basketItems.indexWhere((item) {
    final decodedItem = jsonDecode(item);
    return decodedItem['productName'] == productName;
  });

  if (itemIndex != -1) {
    final decodedItem = jsonDecode(basketItems[itemIndex]);
    decodedItem['quantity'] = quantity;
    basketItems[itemIndex] = jsonEncode(decodedItem);
    await prefs.setStringList('basketItems', basketItems);
  }
}
