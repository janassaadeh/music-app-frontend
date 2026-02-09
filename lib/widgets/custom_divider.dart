import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget{
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return  Padding(
            padding: const EdgeInsets.only(right:16,left:16),
            child: Container(
              color: Colors.grey,
              width: double.infinity, 
              height: 1, 
            ),
    );
  }

}
