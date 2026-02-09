import 'package:flutter/material.dart';

// Top-level function for pushing
void push(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

// Top-level function for replacing
void pushReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

// Top-level function for popping
void pop(BuildContext context) {
  Navigator.pop(context);
}

// Useful non-navigation utility: Close keyboard
void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

// Useful utility: Get screen width
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
String limitedText(String text, int max) {
  return text.length > max ? '${text.substring(0, max)}...' : text;
}
