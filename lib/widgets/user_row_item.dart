import 'package:flutter/material.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
class UserRowItem extends StatelessWidget {
  final String name;
  final bool isFollowed;
  // final VoidCallback? onTap;
  final VoidCallback onFollowPressed;

  const UserRowItem({
    super.key,
    required this.name,
    required this.isFollowed,
    required this.onFollowPressed,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        'https://tse2.mm.bing.net/th/id/OIP.CIn8fInVEpY4ti24C9LfWgHaFJ?pid=Api&h=220&P=0';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          ),
    
          const SizedBox(width: 15),
    
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
    
          // ElevatedButton(
          //   onPressed: onFollowPressed,
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor:
          //         isFollowed ? Colors.grey.shade700 : Colors.blue,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //   ),
          //   child: Text(isFollowed ? "Unfollow" : "Follow"),
          // ),
          CustomRoundedButton(title: isFollowed ? "Unfollow" : "Follow", width: 100, height: 40, color: isFollowed ? Colors.grey.shade700 : Colors.blue, textColor: Colors.white,
           onTap: onFollowPressed)
        ],
      ),
    );
  }
}
