import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/w3.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.9), // Adjust opacity here
              BlendMode.dstATop, // You can use different BlendMode options
            ),
          ),
        ),
        child: Form(
          child: Text("Username")
        )
      ),
    );
  }
}
