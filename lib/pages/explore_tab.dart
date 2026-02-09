import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/pages/album_page.dart';
import 'package:music_app/pages/artist_page.dart';
import 'package:music_app/pages/more/see_more.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/album_cover.dart';
import 'package:music_app/widgets/artist_row_item.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import '../widgets/mini_player.dart';
import '../widgets/full_player.dart';
import '../widgets/queue_sheet.dart';
import '../utils/color_pick.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> with SingleTickerProviderStateMixin {
 

  @override
  Widget build(BuildContext context) {
   final cs = Theme.of(context).colorScheme;
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
    final songsProvider = context.watch<SongsProvider>();
    
final genres = songsProvider.allGenres;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 0, top: 50, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EXPLORE",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                  Row(
                    children: [
                Icon(Icons.notifications, color: cs.onPrimary, size: 25),
                SizedBox(width: 20,),
            
                      Padding(
                        padding: EdgeInsetsGeometry.only(right:18),
                        child: CircleAvatar(
                                          radius: 17,
                                          child: Image.network(
                                            'https://tse2.mm.bing.net/th/id/OIP.CIn8fInVEpY4ti24C9LfWgHaFJ?pid=Api&h=220&P=0',
                                            fit: BoxFit.cover,
                                          ),),
                      )
                    ],
                  ),  
                
              
              ],
            
            ),
             const SizedBox(height: 40),
                      Text('Music from your friends', style: Theme.of(context).textTheme.bodyMedium,),
          const SizedBox(height: 20),
          
                      Column(
                        children: [
                       Container(
  padding: const EdgeInsets.all(3), // border thickness
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [
        Color(0xFFfeda75),
        Color(0xFFfa7e1e),
        Color(0xFFd62976),
        Color(0xFF962fbf),
        Color(0xFF4f5bd5),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: CircleAvatar(
    radius: 22,
    backgroundColor: Colors.white, // thin white ring like Insta
    child: CircleAvatar(
      radius: 20,
      backgroundImage: NetworkImage(
        'https://tse2.mm.bing.net/th/id/OIP.CIn8fInVEpY4ti24C9LfWgHaFJ?pid=Api&h=220&P=0',
      ),
    ),
  ),
),
 SizedBox(height: 5,),
                        Text("Me",style: Theme.of(context).textTheme.labelSmall,),
                        ],
                      ),
             const SizedBox(height: 25),  
       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Artists based on your taste', style: Theme.of(context).textTheme.bodyMedium,),
                        Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CustomRoundedButton(
                title: "More",
                textColor: Colors.black,
                width: 70,
                height: 35,
                color: cs.primaryContainer,
                onTap: () {
                  push(context, SeeMore(title: 'Artists based on your taste', itemType: "artist", items: artistsProvider.artists,));
                },
                fontSize: 14.0,
              ),
            ),
          ),
          ],
                      ),
                      const SizedBox(height: 20),

                       if (artistsProvider.artists
                    .isNotEmpty) ...[
                          
                          // const SizedBox(height: 8),
                         if (artistsProvider.artists.isNotEmpty) ...[
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ...artistsProvider.artists.map((a) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              push(context, ArtistPage(artist: a));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: a.imageUrl.isNotEmpty ? NetworkImage(a.imageUrl) : null,
                  child: a.imageUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(height: 10),
                Text(
                  a.name,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        )),
      ],
    ),
  ),
]

                        ],
         
             const SizedBox(height: 25),  
       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Just For You', style: Theme.of(context).textTheme.bodyMedium,),
                        Center(
            child:  Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child:  CustomRoundedButton(
                title: "More",
                textColor: Colors.black,
                width: 70,
                height: 35,
                color: cs.primaryContainer,
                onTap: () {
                  push(context, SeeMore(title: 'Just For You', itemType: "album", items: albumProvider.albums,));
                },
                fontSize: 14.0,
              ),
            ),
          ),
          ],
                      ),
                      const SizedBox(height: 20),
            if (albumProvider.albums
                    .isNotEmpty) ...[
                          
                          // const SizedBox(height: 8),
                         if (albumProvider.albums.isNotEmpty) ...[
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ...albumProvider.albums.map((a) => 
         
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              push(context, AlbumPage(album: a));
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(a.coverImageUrl, fit: BoxFit.cover,width: 150,height: 150,),
                
                ),
                SizedBox(height: 10,),
              Text(a.title, style: Theme.of(context).textTheme.labelSmall,),
              ],
            ),
          ),

          )
          
        )]))]
                        ],
          
      
             const SizedBox(height: 25),  
       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Charts', style: Theme.of(context).textTheme.bodyMedium,),
                        Center(
            child: CustomRoundedButton(
              title: "More",
              textColor: Colors.black,
              width: 70,
              height: 35,
              color: cs.primaryContainer,
              onTap: () {
                // push(context, SeeMore(title: 'Charts', itemType: "song", items: songsProvider.songs,));
              },
              fontSize: 14.0,
            ),
          ),
          ],
                      ),
                      const SizedBox(height: 20),
          
          Column(
            children: [
              Container(
                width: 150,height: 150,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF962fbf),
                ),
                // child: Image.network("https://cdn-images.dzcdn.net/images/cover/cae2245174d0f56b69e81cfb39f14b6e/250x250-000000-80-0-0.jpg"),
                child: Icon(Icons.music_note, color: Colors.white, size: 100,)
              
              ),
              SizedBox(height: 10,),
            Text("Top Charts", style: Theme.of(context).textTheme.labelSmall,),
            ],
          ),
          GridView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: genres.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1,
  ),
  itemBuilder: (context, index) {
    final genre = genres[index];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final songs =
                songsProvider.getSongsByGenre(genre.id);

            // Navigate to genre songs screen
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF962fbf),
            ),
            child: Icon(Icons.music_note,
                color: Colors.white,
                size: 100),
          ),
        ),
        SizedBox(height: 10),
        Text(
          genre.name,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  },
)

          ],
        )
        ),
    );
  }
}
