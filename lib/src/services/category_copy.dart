// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../model/logo_company.dart';

// // Create a cache to store the fetched data
// List<CompanyLogo> cachedCompanyLogos = [];

// Future<List<CompanyLogo>> fetchDataCompanyLogoCopy() async {
//   // Check if the cache is not empty, and if so, return the cached data
//   if (cachedCompanyLogos.isNotEmpty) {
//     return cachedCompanyLogos;
//   }

//   final url = Uri.parse('http://143.198.217.4:1026/api/search1/company');
//   final headers = {'Content-Type': 'application/json'};
//   final body = jsonEncode({"type_productID": 12});

//   final response = await http.post(url, headers: headers, body: body);

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
    
//     if (jsonData.containsKey('students') && jsonData['students'] is List) {
//       List<dynamic> companyLogoListJson = jsonData['students'];
//       List<CompanyLogo> companyLogos = companyLogoListJson.map((companyLogoJson) {
//         return CompanyLogo.fromJson(companyLogoJson);
//       }).toList();

//       // Cache the fetched data for future use
//       cachedCompanyLogos = companyLogos;

//       return companyLogos;
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

import '../model/logo_company.dart';

// Create a cache to store the fetched data
List<CompanyLogo> cachedCompanyLogos = [];

Future<List<CompanyLogo>> fetchDataCompanyLogoCopy() async {
  // Check if the cache is not empty, and if so, return the cached data
  if (cachedCompanyLogos.isNotEmpty) {
    return cachedCompanyLogos;
  }

  final url = Uri.parse('${dotenv.env['BASE_URL']}/search1/company');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({"type_productID": 21});

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    
    if (jsonData.containsKey('students') && jsonData['students'] is List) {
      List<dynamic> companyLogoListJson = jsonData['students'];
      List<CompanyLogo> companyLogos = companyLogoListJson.map((companyLogoJson) {
        return CompanyLogo.fromJson(companyLogoJson);
      }).toList();

      // Cache the fetched data for future use
      cachedCompanyLogos = companyLogos;

      return companyLogos;
    } else {
      throw Exception('Invalid data format');
    }
  } else {
    throw Exception('Failed to load data');
  }
}