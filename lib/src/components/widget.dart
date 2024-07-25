import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Color.fromARGB(255, 234, 232, 234), fontWeight: FontWeight.w500),
  focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 234, 232, 234), width: 2)),
  enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(255, 234, 232, 234), width: 2)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 169, 8, 13), width: 2)),
);