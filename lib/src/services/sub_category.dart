import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/sub_category.dart';

class SubCategoryService {
  Future<List<SubCategoryModel>> fetchDataSubCategoryModel(int currentPage, int pageSize, int categoryId) async {
    final postUrl = "${dotenv.env['BASE_URL']}/search1/subcategory";

    final response = await http.post(
      Uri.parse(postUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "page": currentPage,
        "size": pageSize,
        "categoryID": categoryId,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final subCategoryList = List<Map<String, dynamic>>.from(
        responseData["students"]["data"],
      );
      print(responseData);
      return subCategoryList.map((subCategoryJson) => SubCategoryModel.fromJson(subCategoryJson)).toList();
    } else {
      throw Exception("Failed to load subcategory data");
    }
  }
}

