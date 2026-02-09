import 'package:flutter/material.dart';
import 'package:music_app/pages/artist_page.dart';
import 'package:music_app/pages/more/see_more.dart';
import 'package:music_app/pages/profile_edit.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/artist_row_item.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:music_app/widgets/global_player.dart';
import 'package:music_app/widgets/layout/app_bar.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final songsProvider = context.watch<SongsProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
    final usersProvider = context.watch<UsersProvider>();

    
    
    return Scaffold(
      appBar: CustomAppBar(title: "", onBackTap: () => pop(context)),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(21),
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 70),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:16.0),
                        child: CircleAvatar(
                          radius: 65,
                            backgroundColor: Colors.grey.shade200,
            backgroundImage: NetworkImage("https://tse2.mm.bing.net/th/id/OIP.CIn8fInVEpY4ti24C9LfWgHaFJ?pid=Api&h=220&P=0"),
                        )
                            
                          
                      ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text("${usersProvider.currentUser?.firstName ?? "Guest"} ${usersProvider.currentUser?.lastName ?? "User"}", style: Theme.of(context).textTheme.bodyMedium,),
                              SizedBox(height: 12),
                            
                              GestureDetector(
                                onTap: () => push(context, SeeMore(title: 'Following', items: usersProvider.following, itemType: 'user',)),
                                child: Row(
                                  children: [
                                    Text('${usersProvider.following.length} Following', style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios,size: 12,color:cs.onPrimary),
                                  ],
                                ),
                              ), 
                              SizedBox(height: 8),
                          
                               GestureDetector(
                                 onTap: () => push(context, SeeMore(title: 'Followers', items: usersProvider.followers, itemType: 'user',)),
                                 child: Row(
                                  children: [
                                    Text('${usersProvider.followers.length} Followers', style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios,size: 12,color:cs.onPrimary),
                                  ],
                                                     ),
                               ),            
                            ]
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 25,),
                  CustomRoundedButton(
                    title: "Edit Profile",
                    width: double.infinity,
                    height: 35,
                    textColor: Colors.white,
                    color: cs.primary,
                    onTap: () {
                      // Handle button tap
                      push(context, ProfileEditPage());
                    },
                    fontSize: 14.0,
                  ),
                  const SizedBox(height: 40),
                              Text('Most Played Songs', style: Theme.of(context).textTheme.bodyMedium,),
                  if (songsProvider.mostPlayedSongs.isNotEmpty) ...[
                          
                          const SizedBox(height: 8),
                          ...songsProvider.mostPlayedSongs.take(5).map((s) {
                            final artist = artistsProvider.artistsMap[s.artistId];
                            final album = albumProvider.albumsMap[s.albumId];
                            return SongRowItem(
                              index: songsProvider.mostPlayedSongs.indexOf(s).toString(),
                              title: s.title,
                              subtitle:
                                  '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                              imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                              isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                            
                              song: s,
                              );
                          }),
                        ],
                      
                  
                  // const SizedBox(height: 20),
                              
                  //  Row(
                  //       children: [
                  //             Text('1', style: Theme.of(context).textTheme.bodyMedium,),
                  //         const SizedBox(width: 25),
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: Image.network("https://upload.wikimedia.org/wikipedia/en/5/5c/Moral_of_the_Story_-_Ashe.jpg", width: 62, height: 62, fit: BoxFit.cover),
                  //         ), 
                  //         const SizedBox(width: 12),
                  //         Expanded(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
              
                  //                 children: [
                  //                 Text("Moral of the Story", style: Theme.of(context).textTheme.labelSmall,),
                  //               const SizedBox(height: 4),
                  //               Row(
                  //                 children: [
                  //                   Icon(Icons.favorite,size: 14,color:cs.onPrimary),
                  //                   SizedBox(width: 4),
                  //                   Text("Ashe", style: Theme.of(context).textTheme.bodySmall,),
                  //                 ],
                  //               ),
                  //                 ],
                  //               ),
                  //               Icon(Icons.more_horiz,size: 20,color:cs.onPrimary),
              
                  //             ],
                  //           ),
                  //         ),
                          
                  //       ],
                  //     ),
                      SizedBox(height: 25,),
                  Center(
                    child: CustomRoundedButton(
                      title: "More",
                      textColor: Colors.black,
                      width: 300,
                      height: 35,
                      color: cs.primaryContainer,
                      onTap: () {
                        // Handle button tap
                        push(context, SeeMore(title: 'Most Played Songs'));
                      },
                      fontSize: 14.0,
                    ),
                  ),
                   const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Followed Artists', style: Theme.of(context).textTheme.bodyMedium,),
                                Center(
                    child: CustomRoundedButton(
                      title: "More",
                      textColor: Colors.black,
                      width: 70,
                      height: 35,
                      color: cs.primaryContainer,
                      onTap: () {
                        push(context, SeeMore(title: 'Followed Artists', itemType: "artist", items: artistsProvider.followedArtists,));
                      },
                      fontSize: 14.0,
                    ),
                  ),
                                ],
                              ),
                  // const SizedBox(height: 20),
                  // GestureDetector(
                  //   onTap: () => push(context, Container()),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //     CircleAvatar(
                  //           radius: 60,
                  //           child: Image.network("https://i.pinimg.com/1200x/f3/3b/6d/f33b6dbcddc9e307e2baf23d097fc75b.jpg"),),
                        
                  //     SizedBox(height: 10,),
                  //     Text("Selena Gomez", style: Theme.of(context).textTheme.labelSmall,),
                              
                  //   ],),
                  // ),
                    if (artistsProvider.followedArtists
                    .isNotEmpty) ...[
                          
                          // const SizedBox(height: 8),
                          ...artistsProvider.followedArtists.take(5).map((a) =>ArtistRowItem(
                                name: a.name,
                                imageUrl: a.imageUrl,
                                onTap: () {push(context, ArtistPage(artist: a));}),),
                           SizedBox(height: 16),
                        ],
                   SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Likes', style: Theme.of(context).textTheme.bodyMedium,),]),
                  
                   if (songsProvider.likedSongs.isNotEmpty) ...[
                          
                          const SizedBox(height: 8),
                          ...songsProvider.likedSongs.take(5).map((s) {
                            final artist = artistsProvider.artistsMap[s.artistId];
                            final album = albumProvider.albumsMap[s.albumId];
                            return SongRowItem(
                              index: songsProvider.likedSongs.indexOf(s).toString(),
                              title: s.title,
                              subtitle:
                                  '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                              imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                              isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                           song: s,
                            );
                          }),
                        ],
                      
                  
                      SizedBox(height: 25,),
              Center(
                    child: CustomRoundedButton(
                      title: "More",
                      textColor: Colors.black,
                      width: 300,
                      height: 35,
                      color: cs.primaryContainer,
                      onTap: () {
                        push(context, SeeMore(title: 'Likes', itemType: "song", items: songsProvider.likedSongs,));
                      },
                      fontSize: 14.0,
                    ),
                  ),
                    SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Recently Played', style: Theme.of(context).textTheme.bodyMedium,),]),
                  if (songsProvider.recentlyPlayedSongs.isNotEmpty) ...[
                          
                          const SizedBox(height: 8),
                          ...songsProvider.recentlyPlayedSongs.take(5).map((s) {
                            final artist = artistsProvider.artistsMap[s.artistId];
                            final album = albumProvider.albumsMap[s.albumId];
                            return SongRowItem(
                              index: songsProvider.recentlyPlayedSongs.indexOf(s).toString(),
                              title: s.title,
                              subtitle:
                                  '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                              imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                             isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                            song: s,
                            );
                          }),
                        ],
                      
                      SizedBox(height: 25,),
              Center(
                    child: CustomRoundedButton(
                      title: "More",
                      textColor: Colors.black,
                      width: 300,
                      height: 35,
                      color: cs.primaryContainer,
                      onTap: () {
                        push(context, SeeMore(title: 'Recently Played', itemType: "song", items: songsProvider.recentlyPlayedSongs,));
                      },
                      fontSize: 14.0,
                    ),
                  ),
                          
                ],
              )
            ),
          ),
        const GlobalPlayerWidget(),

        ],
      ),
    );
  }
}
