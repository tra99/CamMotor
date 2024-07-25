// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/model_bike.dart';

// // Create a cache to store the fetched bike models
// List<BikeModel> cachedBikeModels = [];

// Future<List<BikeModel>> fetchDataBikeModel() async {
//   // Check if the cache is not empty, and if so, return the cached data
//   if (cachedBikeModels.isNotEmpty) {
//     return cachedBikeModels;
//   }

//   final response = await http.get(Uri.parse('http://143.198.217.4:1026/api/model'));

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
    
//     if (jsonData.containsKey('students') && jsonData['students'] is List) {
//       List<dynamic> bikeModelListJson = jsonData['students'];
//       List<BikeModel> bikeModels = bikeModelListJson.map((bikeModelJson) {
//         return BikeModel.fromJson(bikeModelJson);
//       }).toList();

//       // Cache the fetched data for future use
//       cachedBikeModels = bikeModels;

//       return bikeModels;
//     } else {
//       throw Exception('Invalid data format');
//     }
//   } else {
//     throw Exception('Failed to load data');
//   }
// }
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/model_bike.dart';

// Create a cache to store the fetched bike models
List<BikeModel> cachedBikeModels = [];

Future<List<BikeModel>> fetchDataBikeModel() async {
  // Check if the cache is not empty, and if so, return the cached data
  if (cachedBikeModels.isNotEmpty) {
    return cachedBikeModels;
  }

  final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/model'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    
    if (jsonData.containsKey('students') && jsonData['students'] is List) {
      List<dynamic> bikeModelListJson = jsonData['students'];
      List<BikeModel> bikeModels = bikeModelListJson.map((bikeModelJson) {
        return BikeModel.fromJson(bikeModelJson);
      }).toList();

      // Cache the fetched data for future use
      cachedBikeModels = bikeModels;

      return bikeModels;
    } else {
      throw Exception('Invalid data format');
    }
  } else {
    throw Exception('Failed to load data');
  }
}