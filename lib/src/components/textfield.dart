import 'package:flutter/material.dart';

Container reusableTextField(String text, IconData icon, bool isPasswordType,double customHeight) {
  return Container(
    height: customHeight,
    child: TextField(
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            labelText: text,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress),
  );}
Container reusableTextField1(String text, IconData icon, bool isPasswordType,double customHeight) {
  return Container(
    height: customHeight,
    child: TextField(
        obscureText: isPasswordType,
        enableSuggestions: !isPasswordType,
        autocorrect: !isPasswordType,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            labelText: text,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.7),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
        keyboardType: isPasswordType
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress),
  );}