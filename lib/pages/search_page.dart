import 'package:flutter/material.dart';
import 'package:music_app/pages/artist_page.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/services/user_service.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/artist_row_item.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:music_app/widgets/user_row_item.dart';
import 'package:provider/provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    loadRecentSearches();
  }

  // Load recent searches from SharedPreferences
  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  // Save a search term
  Future<void> saveSearch(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    // Remove duplicate
    recentSearches.remove(query);

    // Add to top
    recentSearches.insert(0, query);

    // Limit to last 10 searches
    if (recentSearches.length > 10) {
      recentSearches = recentSearches.sublist(0, 10);
    }

    await prefs.setStringList('recent_searches', recentSearches);
    setState(() {}); // Refresh UI
  }

  // Clear all recent searches
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    setState(() => recentSearches.clear());
  }

  @override
  Widget build(BuildContext context) {
    final songsProvider = context.watch<SongsProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
    final usersProvider = context.watch<UsersProvider>();

    // Filter lists based on query
    final filteredSongs = songsProvider.songs.where((s) {
      final artistName = artistsProvider.artistsMap[s.artistId]?.name ?? '';
      final albumName = albumProvider.albumsMap[s.albumId]?.title ?? '';
      final q = query.toLowerCase();
      return s.title.toLowerCase().contains(q) ||
          artistName.toLowerCase().contains(q) ||
          albumName.toLowerCase().contains(q);
    }).toList();

    final filteredArtists = artistsProvider.artists
        .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final filteredUsers = usersProvider.users
        .where((u) => u.firstName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios,size: 20,),
        //   onPressed: () => Navigator.pop(context),
        // ),
          titleSpacing: 0, 
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container( decoration: BoxDecoration( color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(10), ), padding: const EdgeInsets.symmetric(horizontal: 12), 
          
          child:TextField(
          onChanged: (val) => setState(() => query = val),
          onSubmitted: (val) async {
            await saveSearch(val);
          },
        
           decoration: InputDecoration( icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20), hintText: 'Songs, artists, lyrics, playlists...', hintStyle: Theme.of(context).textTheme.bodySmall, border: InputBorder.none, ), ), ),
        ),
        
        automaticallyImplyLeading: false, // removes default back button
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: Colors.black, // text color
          fontSize: 16,fontWeight: FontWeight.normal
        ),
      ),
    ),
  ],
      ),
      body: query.isEmpty
          ? recentSearches.isEmpty
              ? const Center(child: Text('No recent searches'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Searches',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: clearRecentSearches,
                          child:Icon(Icons.cancel_outlined,size:20,color:Colors.black,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...recentSearches.map((search) => ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(search),
                          onTap: () {
                            setState(() => query = search);
                          },
                        )),
                  ],
                )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filteredSongs.isNotEmpty) ...[
                      const Text('Songs',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...filteredSongs.map((s) {
                        final artist = artistsProvider.artistsMap[s.artistId];
                        final album = albumProvider.albumsMap[s.albumId];
                        return GestureDetector(
                              onTap: () {
                                // Handle song tap
                                print('object');
                                 context.read<PlayerProvider>().playSong(
          filteredSongs, // your queue
          filteredSongs.indexOf(s),
              );
                              },
                              child: SongRowItem(
                            index: filteredSongs.indexOf(s).toString(),
                            title: s.title,
                            song: s,
                            subtitle:
                                '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                            imageUrl: album?.coverImageUrl ?? '',
                            isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                          
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                    if (filteredArtists.isNotEmpty) ...[
                      const Text('Artists',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...filteredArtists.map((a) =>ArtistRowItem(
                            name: a.name,
                            imageUrl: a.imageUrl,
                            onTap: () {push(context, ArtistPage(artist: a));},),),
                       SizedBox(height: 16),
                    ],
                    ...filteredUsers.map((u) => UserRowItem(
      name: '${u.firstName} ${u.lastName}',
isFollowed: usersProvider.following.any((f) => f.id == u.id),

      onFollowPressed: () async {
        if (usersProvider.following.any((f) => f.id == u.id)) {
          await UsersService().unfollow(userId: u.id);
        } else {
          await UsersService().follow(userId: u.id);
        }

        await usersProvider.fetchUsersFollowing();
      },

    
)),

                      const SizedBox(height: 16),
                    
                    if (filteredSongs.isEmpty &&
                        filteredArtists.isEmpty &&
                        filteredUsers.isEmpty)
                      const Center(child: Text('No results found')),
                  ],
                ),
              ),
            ),
    );
  }
}
