import 'package:flutter/material.dart';
import 'package:music_app/pages/search_page.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/genre_card.dart';
import 'package:provider/provider.dart';
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Fixed header
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SEARCH & DISCOVER",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
             GestureDetector(
  onTap: () => push(context, const SearchPage()), // navigate to search page
  child: Container(
    decoration: BoxDecoration(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    child: Row(
      children: [
        Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
        const SizedBox(width: 8),
        Text(
          'Songs, artists, lyrics, playlists...',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
      ],
    ),
  ),
)

            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 20),
              Text("Popular", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 17),

              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      title: "TOP",
                      imageUrl: "https://picsum.photos/200?random=1",
                      color: Color(0xffc800ff),
                    ),
                  ),
                  const SizedBox(width: 17),
                  Expanded(
                    child: CustomCard(
                      title: "NEW MUSIC",
                      imageUrl: "https://picsum.photos/200?random=2",
                      color:  Color(0xff4b3cff),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text("Moods & Genres", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 17),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          title: "CHILLING",
                          imageUrl: "https://picsum.photos/200?random=3",
                          color: Color(0xff699cff),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomCard(
                          title: "DECADES",
                          imageUrl: "https://picsum.photos/200?random=4",
                          color: Color(0xffff3c9c),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          title: "DRIVING",
                          imageUrl: "https://picsum.photos/200?random=5",
                          color: Color(0xffffb366),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomCard(
                          title: "NEW MUSIC",
                          imageUrl: "https://picsum.photos/200?random=6",
                          color: Color(0xffff6a00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          title: "SLEEP",
                          imageUrl: "https://picsum.photos/200?random=7",
                          color: Color(0xff00d2ff),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomCard(
                          title: "WORKOUT",
                          imageUrl: "https://picsum.photos/200?random=8",
                          color:Color(0xff00ff85),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          title: "HAPPY",
                          imageUrl: "https://picsum.photos/200?random=9",
                          color: Color(0xff00c853),
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomCard(
                          title: "WORKOUT",
                          imageUrl: "https://picsum.photos/200?random=10",
                          color:Color(0xffffd600),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 17),
                  Row(
                    children: [
                      Expanded(
                        child: CustomCard(
                          title: "ARABIC",
                          imageUrl: "https://picsum.photos/200?random=11",
                          color: Color(0xffff5722)
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: CustomCard(
                          title: "FRENCH",
                          imageUrl: "https://picsum.photos/200?random=12",
                          color:Color(0xffd500f9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
