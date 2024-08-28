import 'package:flutter/material.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 231, 255),
      appBar: AppBar(
        title: Image.asset(
              "assets/images/logo3.png",
              width: 140,
            ),
        backgroundColor: const Color.fromARGB(255, 0, 137, 249),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false, 
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: const Color.fromARGB(255, 36, 87, 197),
              child: const Center(
                  child: Text(
                'ការលក់',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
              )),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), 
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_rounded,color: Color.fromARGB(255, 36, 87, 197),size: 46,),
                    Text('មកដល់ឆាប់ៗ...',style: TextStyle(color: Color.fromARGB(255, 36, 87, 197),fontSize: 20),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}