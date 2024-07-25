// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// class CarouselWidget extends StatefulWidget {
//   final List<Map<String, String>> imageList;
//   final CarouselController carouselController;

//   CarouselWidget({required this.imageList, required this.carouselController});

//   @override
//   _CarouselWidgetState createState() => _CarouselWidgetState();
// }

// class _CarouselWidgetState extends State<CarouselWidget> {
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: Stack(
//             children: [
//               CarouselSlider(
//                 items: widget.imageList.map((item) {
//                   return Builder(builder: (BuildContext context) {
//                     return Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Opacity(
//                               opacity: 0.9,
//                               child: Image.asset(
//                                 item['image_path']!,
//                                 fit: BoxFit.cover,
//                                 width: MediaQuery.of(context).size.width,
//                                 height: MediaQuery.of(context).size.height,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: MediaQuery.of(context).size.height * 0.08,
//                           left: MediaQuery.of(context).size.height * 0.1,
//                           child: SizedBox(
//                             width: 250.0,
//                             child: DefaultTextStyle(
//                               style: const TextStyle(
//                                 fontSize: 30.0,
//                                 fontFamily: 'Bobbers',
//                               ),
//                               child: AnimatedTextKit(
//                                 animatedTexts: [
//                                   TyperAnimatedText(
//                                     'Cammotor ជាទំនុកចិត្តរបស់លោកអ្នក',
//                                     textStyle: TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.w600,
//                                       foreground: Paint()
//                                         ..style = PaintingStyle.stroke
//                                         ..strokeWidth = 1
//                                         ..color =  Colors.white,
//                                     ),
//                                     speed: const Duration(milliseconds: 100),
//                                     textAlign: TextAlign.center
//                                   ),
//                                 ],
//                                 onTap: () {
//                                   print("Tap Event");
//                                 },
//                               ),
//                             ),
//                           )
//                         )
//                       ],
//                     );
//                   });
//                 }).toList(),
//                 carouselController: widget.carouselController,
//                 options: CarouselOptions(
//                   scrollPhysics: const BouncingScrollPhysics(),
//                   autoPlay: true,
//                   aspectRatio: 2,
//                   viewportFraction: 1,
//                   onPageChanged: (index, reason) {
//                     setState(() {
//                       currentIndex = index;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
