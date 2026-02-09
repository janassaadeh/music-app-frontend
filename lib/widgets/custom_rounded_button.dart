import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color color;
  final Color textColor;

  final VoidCallback onTap;
  final double fontSize;

  const CustomRoundedButton({
    super.key,
    required this.title,
    required this.width, // Default to full width
    required this.height,           // Default height
    required this.color,
    required this.textColor,
    required this.onTap,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          // Use height/2 to ensure a perfect "stadium" shape (pill shape)
          borderRadius: BorderRadius.circular(height / 2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2, // Adds that professional spaced look
          ),
        ),
      ),
    );
  }
}