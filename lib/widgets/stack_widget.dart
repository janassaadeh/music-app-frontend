import 'package:flutter/material.dart';

class StackWidget extends StatelessWidget{
  const StackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return   SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.onSecondaryContainer.withValues(
                      alpha: 0.1,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: cs.onSecondaryContainer,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Premium',
                      style: TextStyle(color: cs.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

}
