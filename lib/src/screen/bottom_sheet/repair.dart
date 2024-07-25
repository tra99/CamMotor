import 'package:flutter/material.dart';

class RepairScreenProduct extends StatefulWidget {
  const RepairScreenProduct({super.key});

  @override
  State<RepairScreenProduct> createState() => _RepairScreenProductState();
}

class _RepairScreenProductState extends State<RepairScreenProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repair'),
      ),
    );
  }
}