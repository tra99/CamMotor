import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/model_bike.dart';

Map<int, List<YearModel>> cachedYearModels = {};

Future<List<YearModel>> fetchDataYearModel(int selectedModelId) async {
  // Check if the data for the selected model is cached, return if found
  if (cachedYearModels.containsKey(selectedModelId)) {
    return cachedYearModels[selectedModelId]!;
  }

  try {
    final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}/year'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> yearModelListJson = jsonData['students'];

      // Parse the JSON data into a List of YearModel objects
      List<YearModel> yearModels = yearModelListJson
          .map((yearModelJson) => YearModel.fromJson(yearModelJson))
          .where((yearModel) => yearModel.modelId == selectedModelId)
          .toList();

      // Cache the fetched data for the selected model
      cachedYearModels[selectedModelId] = yearModels;

      return yearModels;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Disconnected');
  }
}