// import 'dart:convert';
// import 'package:cammotor_new_version/src/model/category.dart';
// import 'package:http/http.dart' as http;

// List<CategoryModel> cachedCategoryModels = [];

// Future<List<CategoryModel>> fetchDataCategoryModel() async {
//   if (cachedCategoryModels.isNotEmpty) {
//     // If cached data is available, return it immediately.
//     return cachedCategoryModels;
//   }

//   try {
//     final response = await http.get(Uri.parse('http://143.198.217.4:1026/api/category'));

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final List<dynamic> categoryModelListJson = jsonData['category'];

//       // Parse the JSON data into a List of CategoryModel objects
//       List<CategoryModel> categoryModels = categoryModelListJson.map((categoryModelJson) {
//         return CategoryModel.fromJson(categoryModelJson);
        
//       }).toList();

//       // Cache the data for future use
//       cachedCategoryModels = categoryModels;

//       return categoryModels;
//     } else {
//       throw Exception('Failed to load category data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Display an error message to the user.
//     // You can also log the error for debugging purposes.
//     if (cachedCategoryModels.isNotEmpty) {
//       // If cached data is available, return it along with the error.
//       return cachedCategoryModels;
//     } else {
//       throw e; // If there's no cached data, rethrow the error.
//     }
//   }
// }
import 'dart:convert';
import 'package:cammotor_new_version/src/model/category.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

List<CategoryModel> cachedCategoryModels = [];

Future<List<CategoryModel>> fetchDataCategoryModel() async {
  if (cachedCategoryModels.isNotEmpty) {
    // If cached data is available, return it immediately.
    return cachedCategoryModels;
  }

  try {
    final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/category'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> categoryModelListJson = jsonData['category'];

      // Parse the JSON data into a List of CategoryModel objects
      List<CategoryModel> categoryModels = categoryModelListJson.map((categoryModelJson) {
        return CategoryModel.fromJson(categoryModelJson);
        
      }).toList();

      // Cache the data for future use
      cachedCategoryModels = categoryModels;

      return categoryModels;
    } else {
      throw Exception('Failed to load category data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Display an error message to the user.
    // You can also log the error for debugging purposes.
    if (cachedCategoryModels.isNotEmpty) {
      // If cached data is available, return it along with the error.
      return cachedCategoryModels;
    } else {
      throw e; // If there's no cached data, rethrow the error.
    }
  }
}