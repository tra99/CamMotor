import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/real_product.dart';

class RealProductService {
  Future<List<RealProductModel>> fetchProductData(int currentPage, int pageSize, int subcategoryID) async {
    final postUrl = "${dotenv.env['BASE_URL']}/search1/productd";

    final response = await http.post(
      Uri.parse(postUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "page": currentPage,
        "size": pageSize,
        "subcategoryID": subcategoryID,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final productList = List<Map<String, dynamic>>.from(
        responseData["students"]["data"],
      );
      // print(responseData);
      return productList.map((productJson) => RealProductModel.fromJson(productJson)).toList();
    } else {
      throw Exception("Failed to load product data");
    }
  }
}