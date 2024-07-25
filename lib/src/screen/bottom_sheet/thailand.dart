import 'package:flutter/material.dart';

class ThailandScreen extends StatefulWidget {
  const ThailandScreen({super.key});

  @override
  State<ThailandScreen> createState() => _ThailandScreenState();
}

class _ThailandScreenState extends State<ThailandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thailand'),
      ),
    );
  }
}