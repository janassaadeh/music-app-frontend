import 'package:flutter/material.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/pages/album_page.dart';
import 'package:music_app/pages/artist_page.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/services/user_service.dart';
import 'package:music_app/utils/shorcuts.dart' show pop, push;
import 'package:music_app/widgets/artist_row_item.dart';
import 'package:music_app/widgets/layout/app_bar.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:music_app/widgets/user_row_item.dart';
import 'package:provider/provider.dart';

class SeeMore extends StatelessWidget {
  final String title;
  final List? items; // New parameter to accept list of items
  final String? itemType; // New parameter to specify type of items (e.g., 'user', 'song', etc.)    
  
  const SeeMore({super.key, required this.title, this.items, this.itemType});

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<UsersProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
    final songsProvider = context.watch<SongsProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: title,
        onBackTap: () => pop(context), // Uses your pop function
      ),
      body: itemType == 'user' 
          ?
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListView.builder(
                itemCount: items?.length ?? 0,
                itemBuilder: (context, index) {
                  final user = items?[index];
                  return
                               
              UserRowItem( name: '${user?.firstName} ${user?.lastName}',
             isFollowed: usersProvider.following.any((f) => f.id == user?.id),
                   onFollowPressed: () async {
                     if (usersProvider.following.any((f) => f.id == user?.id)) {
                       await UsersService().unfollow(userId: user!.id);
                     } else {
                       await UsersService().follow(userId: user!.id);
                     }
             
                     await usersProvider.fetchUsersFollowing();
                   },
             
                 
             );
                },
              ),
           ):
           itemType == 'artist' 
          ?
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListView.builder(
                itemCount: items?.length ?? 0,
                itemBuilder: (context, index) {
                  final Artist = items?[index];
                  return
                               
              ArtistRowItem( name: '${Artist?.name}',
             imageUrl: Artist?.imageUrl ?? '',
             onTap: () {push(context, ArtistPage(artist: Artist));},             
                 
             );
                },
              ),
           ):
              itemType == 'song' 
          ?
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListView.builder(
                itemCount: items?.length ?? 0,
                itemBuilder: (context, index) {
                  final s = items?[index];

                   final artist = artistsProvider.artistsMap[s.artistId];
                              final album = albumProvider.albumsMap[s.albumId];
                              return SongRowItem(
                                index: items!.indexOf(s).toString(),
                                title: s.title,
                                subtitle:
                                    '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                                imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                              isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                                song: s,
                                
                              );
                },
              ),
           )

          
          : Center(child: Text('No items to display')),
    );
  }
}