// import 'dart:convert';
// import 'package:cammotor_new_version/src/services/add_to_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../model/add_to_card.dart';

// class AddToCardScreenTest extends StatefulWidget {
//   const AddToCardScreenTest({super.key});

//   @override
//   State<AddToCardScreenTest> createState() => _AddToCardScreenTestState();
// }

// class _AddToCardScreenTestState extends State<AddToCardScreenTest> {

//   late Future<List<AddToCardModel>> _futureAddToCardModel;
//   int? userId;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserInfo();
//     _futureAddToCardModel=fetchDataAddToCardModel();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _futureAddToCardModel,
//         builder: (context, snapshot) {
//           if(snapshot.connectionState==ConnectionState.waiting){
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }else if(snapshot.hasError){
//             return Center(
//               child: Text("Error ${snapshot.error}"),
//             );
//           }
//           else{
//             final addToCardModels=snapshot.data!;
//             return ListView.builder(
//               itemCount: addToCardModels.length,
//               itemBuilder: (context,index){
//               final addToCardModel=addToCardModels[index];
//               return ListTile(
//                 title: Text("Order Id: ${addToCardModel.id}"),
//                 subtitle: Text("Order Id: ${addToCardModel.quantity_order}"),
//                 trailing: Text("Order Id: ${addToCardModel.total}"),
//                 onTap: () {
//                   print("UserId: $userId".toString());
//                 },
//               );
//             });
//           }
//         },
//       ),
//     );
//   }

//   Future<void> fetchUserInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? authToken = prefs.getString('token');

//     if (authToken != null) {
//       final response = await http.get(
//         Uri.parse('${dotenv.env['BASE_URL']}/auth/user/check'),
//         headers: {
//           'Authorization': 'Bearer $authToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         setState(() {
//           userId=responseData['test']['id'];
//         });
//         print(responseData);
//       } else {
//         print('Failed to fetch user info');
//       }
//     } else {
//       print('Authentication token not found');
//     }
//   }
// }