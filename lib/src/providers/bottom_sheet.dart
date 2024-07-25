// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cammotor_new_version/src/screen/bottom_sheet/copy.dart';
// import 'package:cammotor_new_version/src/screen/bottom_sheet/general.dart';
// import 'package:cammotor_new_version/src/screen/bottom_sheet/original.dart';
// import 'package:cammotor_new_version/src/screen/bottom_sheet/repair.dart';
// import 'package:cammotor_new_version/src/screen/bottom_sheet/thailand.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../components/loading.dart';
// import '../model/bottom_sheet.dart';
// import '../services/buttom_sheet.dart';

// class FetchData extends StatefulWidget {
//   const FetchData({Key? key}) : super(key: key);

//   @override
//   State<FetchData> createState() => _FetchDataState();
// }

// class _FetchDataState extends State<FetchData> {
  
//   @override
//   Widget build(BuildContext context) {
//     CachedNetworkImage(
//        imageUrl: "${dotenv.env['BASE_URL']}/storage/",
//        progressIndicatorBuilder: (context, url, downloadProgress) => 
//                CircularProgressIndicator(value: downloadProgress.progress),
//        errorWidget: (context, url, error) => const Icon(Icons.error),
//     );
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 66, 53, 53),
//       body: FutureBuilder<List<Student>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CustomLoadingWidget());
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available.'));
//           } else {
//             final List<Student> students = snapshot.data!;

//             // set dynamic height of bottom sheet
//             final int itemCount = students.length;
//             final int numRows = (itemCount / 2).ceil();
//             final double dynamicHeight =
//                 numRows * (MediaQuery.of(context).size.height * 0.05);
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildStudentGrid(students),
//                   SizedBox(
//                     height: dynamicHeight,
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   // Card at the top displaying the name and image of the first student
//   // Inside your _buildStudentGrid method

//   Widget _buildStudentGrid(List<Student> students) {
//     final int itemCount = students.length;
//     final int numRows = (itemCount / 2).ceil();

//     final bool isListLengthOdd = students.length % 2 == 1;

//     return GestureDetector( // Wrap the entire grid with GestureDetector
//       onTap: () {

//       },
//       child: Column(
//         children: [
//           if (isListLengthOdd)
//             GestureDetector(
//               onTap: () {
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OriginalScreen()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Center(
//                   child: Column(
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.only(top: 16),
//                         child: Center(
//                           child: Text(
//                             'សំភារៈម៉ូតូ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10,),
//                       Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.15,
//                             width: MediaQuery.of(context).size.width * 0.48,
//                             child: Card(
//                               color: Colors.grey.shade300,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     students.isNotEmpty ? students[0].name : '',
//                                     style: const TextStyle(
//                                       color: Color.fromARGB(255, 115, 110, 110),
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                                   const Text(
//                                     'គ្រឿងបន្លាស់',
//                                     style: TextStyle(
//                                       color: Color.fromARGB(255, 115, 110, 110),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: MediaQuery.of(context).size.height * (-0.01),
//                             top: MediaQuery.of(context).size.height * (-0.01),
//                             child: 
//                             Image(
//                               image: CachedNetworkImageProvider(
//                                 '${dotenv.env['BASE_URL']}/storage/${students.isNotEmpty ? students[0].icons : ''}',maxWidth: 50
//                               ),
//                             ),

//                           )
//                         ]),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           // Grid of students
//           Column(
//             children: List.generate(numRows, (rowIndex) {
//               return Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: List.generate(2, (columnIndex) {
//                       int index = rowIndex * 2 + columnIndex + 1;
//                       if (index < itemCount) {
//                         return GestureDetector(
//                           onTap: () {
//                             // Check the index and navigate to the corresponding screen.
//                             if (index == 1) {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => const CopyScreen()));
//                             } 
//                             else if (index == 2) {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralScreen()));
//                             }
//                             else if (index == 3) {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => const ThailandScreen()));
//                             }
//                             else if (index == 4) {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => const RepairScreenProduct()));
//                             }
//                           },
//                           child: _buildCard(students[index]),
//                         );
//                       } else {
//                         return const SizedBox();
//                       }
//                     }),
//                   ),
//                   Container(
//                     height: 10.0,
//                   ),
//                 ],
//               );
//             }),
//           )

//         ],
//       ),
//     );
//   }

//   Widget _buildCard(Student student) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.15,
//           width: MediaQuery.of(context).size.width * 0.48,
//           child: Card(
//             color: Colors.grey.shade300,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   student.name,
//                   style: const TextStyle(
//                     color: Color.fromARGB(255, 115, 110, 110),
//                     fontSize: 20,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const Text(
//                   'គ្រឿងបន្លាស់',
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 115, 110, 110),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           right: MediaQuery.of(context).size.height * (-0.01),
//           top: MediaQuery.of(context).size.height * (-0.01),
//           child: Image(
//             image: CachedNetworkImageProvider(
//               '${dotenv.env['BASE_URL']}/storage/${student.icons}',
//               maxWidth: 50,
//             ),
//           ),
//         )
//       ]);
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/copy.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/general.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/original.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/repair.dart';
import 'package:cammotor_new_version/src/screen/bottom_sheet/thailand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../components/loading.dart';
import '../model/bottom_sheet.dart';
import '../services/buttom_sheet.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  
  @override
  Widget build(BuildContext context) {
    CachedNetworkImage(
       imageUrl: "${dotenv.env['BASE_URL']}/storage/",
       progressIndicatorBuilder: (context, url, downloadProgress) => 
               CircularProgressIndicator(value: downloadProgress.progress),
       errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 53, 53),
      body: FutureBuilder<List<Student>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoadingWidget());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            final List<Student> students = snapshot.data!;

            // set dynamic height of bottom sheet
            final int itemCount = students.length;
            final int numRows = (itemCount / 2).ceil();
            final double dynamicHeight =
                numRows * (MediaQuery.of(context).size.height * 0.05);
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildStudentGrid(students),
                  SizedBox(
                    height: dynamicHeight,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Card at the top displaying the name and image of the first student
  // Inside your _buildStudentGrid method

  Widget _buildStudentGrid(List<Student> students) {
    final int itemCount = students.length;
    final int numRows = (itemCount / 2).ceil();

    final bool isListLengthOdd = students.length % 2 == 1;

    return GestureDetector( // Wrap the entire grid with GestureDetector
      onTap: () {

      },
      child: Column(
        children: [
          if (isListLengthOdd)
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OriginalScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            'សំភារៈម៉ូតូ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.48,
                            child: Card(
                              color: Colors.grey.shade300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    students.isNotEmpty ? students[0].name : '',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 115, 110, 110),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Text(
                                    'គ្រឿងបន្លាស់',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 115, 110, 110),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: MediaQuery.of(context).size.height * (-0.01),
                            top: MediaQuery.of(context).size.height * (-0.01),
                            child: 
                            Image(
                              image: CachedNetworkImageProvider(
                                '${dotenv.env['BASE_URL']}/storage/${students.isNotEmpty ? students[0].icons : ''}',maxWidth: 50
                              ),
                            ),

                          )
                        ]),
                    ],
                  ),
                ),
              ),
            ),
          // Grid of students
          Column(
            children: List.generate(numRows, (rowIndex) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(2, (columnIndex) {
                      int index = rowIndex * 2 + columnIndex + 1;
                      if (index < itemCount) {
                        return GestureDetector(
                          onTap: () {
                            // Check the index and navigate to the corresponding screen.
                            if (index == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CopyScreen()));
                            } 
                            else if (index == 2) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralScreen()));
                            }
                            else if (index == 3) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ThailandScreen()));
                            }
                            else if (index == 4) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RepairScreenProduct()));
                            }
                          },
                          child: _buildCard(students[index]),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ),
                  Container(
                    height: 10.0,
                  ),
                ],
              );
            }),
          )

        ],
      ),
    );
  }

  Widget _buildCard(Student student) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.48,
          child: Card(
            color: Colors.grey.shade300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 115, 110, 110),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'គ្រឿងបន្លាស់',
                  style: TextStyle(
                    color: Color.fromARGB(255, 115, 110, 110),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.height * (-0.01),
          top: MediaQuery.of(context).size.height * (-0.01),
          child: Image(
            image: CachedNetworkImageProvider(
              '${dotenv.env['BASE_URL']}/storage/${student.icons}',
              maxWidth: 50,
            ),
          ),
        )
      ]);
  }
}