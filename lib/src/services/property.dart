// import 'dart:convert';
// import 'package:cammotor_new_version/src/model/category.dart';
// import 'package:cammotor_new_version/src/model/property.dart';
// import 'package:http/http.dart' as http;

// List<PropertyModel> cachedProperty = [];

// Future<List<PropertyModel>> fetchPropertyModel() async {
//   if (cachedProperty.isNotEmpty) {
//     // If cached data is available, return it immediately.
//     return cachedProperty;
//   }

//   try {
//     final response = await http.get(Uri.parse('http://143.198.217.4:1026/api/property'));

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final List<dynamic> propertyModelListJson = jsonData['property'];

//       // Parse the JSON data into a List of CategoryModel objects
//       List<PropertyModel> propertyModel = propertyModelListJson.map((categoryModelJson) {
//         return PropertyModel.fromJson(categoryModelJson);
        
//       }).toList();

//       // Cache the data for future use
//       cachedProperty = propertyModel;

//       return propertyModel;
//     } else {
//       throw Exception('Failed to load category data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     if (cachedProperty.isNotEmpty) {
//       return cachedProperty;
//     } else {
//       throw e;
//     }
//   }
// }
import 'dart:convert';
import 'package:cammotor_new_version/src/model/category.dart';
import 'package:cammotor_new_version/src/model/property.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

List<PropertyModel> cachedProperty = [];

Future<List<PropertyModel>> fetchPropertyModel() async {
  if (cachedProperty.isNotEmpty) {
    // If cached data is available, return it immediately.
    return cachedProperty;
  }

  try {
    final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/property'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> propertyModelListJson = jsonData['property'];

      // Parse the JSON data into a List of PropertyModel objects
      List<PropertyModel> propertyModel = propertyModelListJson.map((propertyModelJson) {
        return PropertyModel.fromJson(propertyModelJson);
      }).toList();

      // Cache the data for future use
      cachedProperty = propertyModel;

      return propertyModel;
    } else {
      throw Exception('Failed to load property data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    if (cachedProperty.isNotEmpty) {
      return cachedProperty;
    } else {
      throw e;
    }
  }
}
