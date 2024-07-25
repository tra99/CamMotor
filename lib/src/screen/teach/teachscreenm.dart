import 'package:flutter/material.dart';

class TeachScreen extends StatefulWidget {
  const TeachScreen({super.key});

  @override
  State<TeachScreen> createState() => _TeachScreenState();
}

class _TeachScreenState extends State<TeachScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 217, 217, 217),
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo3.png',
            width: 200,
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  // code here
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3.0),
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'),
                      ),
                    ),
                  ),
                ))
          ]),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 3)
              )
            ]
          ),
          child: const ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/cover3.png'),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover, 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
