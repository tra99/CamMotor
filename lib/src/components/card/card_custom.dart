// for card grid 4 items in home screen
import 'package:flutter/material.dart';

class choices {
  const choices({required this.name, required this.image});
  final String name;
  final ImageProvider image;
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.ch}) : super(key: key);
  final choices ch;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: ch.image, width: 80),
            Text(
              ch.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 105, 114, 106),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class choice {
  const choice({required this.name, required this.image});
  final String name;
  final ImageProvider image;
}

class SelectCardPopup extends StatelessWidget {
  const SelectCardPopup({Key? key, required this.chs}) : super(key: key);
  final choices chs;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        color: Colors.grey.shade300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chs.name,
                style: const TextStyle(
                  color: Color.fromARGB(255, 105, 114, 106),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: -20,
        right: -20,
        child: Image(
          image: chs.image,
          width: 100,
        ),
      )
    ]);
  }
  
}