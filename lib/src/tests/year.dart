// import 'package:cammotor_new_version/src/model/model_bike.dart';
// import 'package:cammotor_new_version/src/services/year_model.dart';
// import 'package:flutter/material.dart';

// class YearScreen extends StatefulWidget {
//   const YearScreen({Key? key}) : super(key: key);

//   @override
//   State<YearScreen> createState() => _YearScreenState();
// }

// class _YearScreenState extends State<YearScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Year Model'),
//       ),
//       body: FutureBuilder<List<YearModel>>(
//         future: fetchDataYearModel(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final List<YearModel> yearModels = snapshot.data!;
//             return Center(
//               child: GestureDetector(
//                 onTap: () => _dialogBuilder(context, yearModels),
//                 child: Semantics(
//                   label: 'Open Dialog',
//                   child: const Text('Open Dialog'),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _dialogBuilder(BuildContext context, List<YearModel> yearModels) async {
//     bool dismissed = false;

//     try {
//       await showGeneralDialog(
//         context: context,
//         barrierDismissible: true,
//         barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//         barrierColor: Colors.black.withOpacity(0.5),
//         pageBuilder: (context, animation1, animation2) {
//           return WillPopScope(
//             onWillPop: () async {
//               dismissed = true;
//               Navigator.of(context).pop();
//               return false;
//             },
//             child: Center(
//               child: Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.width * 0.35,
//                 decoration: const BoxDecoration(
//                   color: Color.fromARGB(255, 31, 31, 31),
//                 ),
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: yearModels.length,
//                   itemBuilder: (context, index) => Padding(
//                     padding: const EdgeInsets.all(18),
//                     child: Container(
//                       width: 100,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30.0),
//                         border: Border.all(
//                           width: 2.0,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       child: Semantics(
//                         label: 'Year ${yearModels[index].year}',
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(40),
//                           child: Center(
//                             child: Text(
//                               yearModels[index].year,
//                               style: const TextStyle(
//                                 fontSize: 24,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 decoration: TextDecoration.none,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     } catch (e) {
//       // Handle any exceptions that occur during dialog creation.
//       print('Error creating dialog: $e');
//     }
//   }
// }
