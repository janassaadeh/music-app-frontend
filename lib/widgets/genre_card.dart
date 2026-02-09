import 'dart:math' as math;

import 'package:flutter/material.dart';
class CustomCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color color;

  const CustomCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // 👈 fixed height keeps layout consistent
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 👈 align text vertically
        children: [
          Transform.translate(
            offset: const Offset(-15, 0),
            child: Transform.rotate(
              angle: -math.pi / 30,
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),


          Expanded(
            child: Text(
              title,
              maxLines: null,   // 👈 unlimited lines
    softWrap: true,                   // 👈 stays on one line
              // overflow: TextOverflow.ellipsis, // 👈 prevents overflow
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
