import 'package:flutter/material.dart';

class PlaylistRowItem extends StatelessWidget {
  final String index;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback? fct;


  const PlaylistRowItem({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    this.color,
    this.fct,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
  bool whiteText = (color!=null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
                width: 62, height: 62,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:Icon(Icons.music_note, color: Colors.blue[100], size: 40,), ),
                const SizedBox(width: 12),
          /// TEXT + MORE ICON
          Expanded(
            child: Row(
              children: [
                /// TEXT SIDE (constrained)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:whiteText ? Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white) : Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // // if(isLiked)
                          // Icon(
                          //   Icons.favorite,
                          //   size: 14,
                          //   color: whiteText ? Colors.white : cs.onPrimary,
                          // )else
                          Container(),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: whiteText ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white) : Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(width: 8),
              whiteText?Container():
                /// MORE ICON (fixed size)
                GestureDetector(
                  onTap: fct,
                  child: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
