import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackTap;
  final Color color;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      // We set automaticallyImplyLeading to false to remove the default back button
      automaticallyImplyLeading: false, 
      titleSpacing: 0, // Removes default padding to let the content sit on the left
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
              onPressed: onBackTap,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge,),
            
          ],      
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}