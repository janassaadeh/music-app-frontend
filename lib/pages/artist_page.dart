import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/album_page.dart';
import 'package:music_app/pages/more/see_more.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/services/artist_service.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatelessWidget {
  final Artist artist;
  const ArtistPage({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final songsProvider = context.watch<SongsProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final playerProvider = context.read<PlayerProvider>();
      final albumProvider = context.watch<AlbumProvider>();
    /// ✅ Provider driven data
    final artistSongs = songsProvider.getSongsByArtist(artist);
    final similarArtists = artistsProvider.getSimilarArtists(artist);
    /// ✅ Album fast lookup
    final albumMap = {for (var a in artist.albums) a.id: a};
bool isFollowed=
      artistsProvider.followedArtists.any((f) => f.id == artist.id);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// ================= HEADER =================
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 1.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(artist.imageUrl),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(21.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artist.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 30,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              /// ================= PLAY BUTTON =================
              Padding(
                padding: const EdgeInsets.all(21.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRoundedButton(
                      title: "Play",
                      width: 170,
                      height: 40,
                      textColor: Colors.white,
                      color: cs.primary,
                      onTap: artistSongs.isEmpty
                          ? () {}
                          : () => playerProvider.playSong(artistSongs, 0),
                      fontSize: 13,
                    ),
                    const SizedBox(width: 20),
                    CustomRoundedButton(
  title: artistsProvider.followedArtists.any((f) => f.id == artist.id)
      ? "Following"
      : "Follow",
  width: 170,
  height: 40,
  textColor: Colors.black,
  color: cs.primaryContainer,
  fontSize: 13,

  onTap: () async {
    if (artistsProvider.followedArtists.any((f) => f.id == artist.id)) {
      await ArtistsService().unfollow(artistId: artist.id);
      isFollowed=false;
    } else {

      await ArtistsService().follow(artistId: artist.id);
      isFollowed=false;

    }

    await artistsProvider.fetchFollowedArtist();
  },
),

                  ],
                ),
              ),

              /// ================= ALL TIME HITS =================
              // if (artistSongs.isNotEmpty) ...[
              //   SectionTitle(
              //     title: "All Time Hits",
              //     onMoreTap: () => Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => SeeMore(title: "All Time Hits"))),
              //   ),
              //   SizedBox(
              //     height: 180,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: artistSongs.length,
              //       itemBuilder: (_, index) {
              //         final song = artistSongs[index];
              //         final album = albumMap[song.albumId];

              //         return SongRowItem(
              //           index: "${index + 1}",
              //           title: song.title,
              //           subtitle: album?.title ?? "Unknown Album",
              //           imageUrl: album?.coverImageUrl ??
              //               "https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg",
              //           isLiked: songsProvider.likedSongs
              //               .any((s) => s.id == song.id),
              //           song: song,
              //         );
              //       },
              //     ),
              //   ),
              // ],
if (artistSongs.isNotEmpty) ...[
                            SectionTitle(
                  title: "All Time Hits",
                  onMoreTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SeeMore(title: "All Time Hits", items: artistSongs, itemType: "song",))),
                ),
                
                          const SizedBox(height: 8),
                          ...artistSongs.take(5).map((s) {
                            final artist = artistsProvider.artistsMap[s.artistId];
                            final album = albumProvider.albumsMap[s.albumId];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: SongRowItem(
                                index: artistSongs.indexOf(s).toString(),
                                title: s.title,
                                subtitle:
                                    '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                                imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                                isLiked: songsProvider.likedSongs.any((song) => song.id == s.id),
                              
                                song: s,
                                ),
                            );
                          }),
                        ],
              const SizedBox(height: 25),

              /// ================= ALBUMS =================
              if (artist.albums.isNotEmpty) ...[
                SectionTitle(
                  title: "Albums",
                  onMoreTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SeeMore(title: "Albums"))),
                ),
                SizedBox(height: 8,),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                  child: SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: artist.albums.length,
                      itemBuilder: (_, index) {
                        final album = artist.albums[index];
                  
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AlbumPage(album: album)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    album.coverImageUrl,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    album.title,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 25),

              /// ================= SIMILAR ARTISTS =================
              if (similarArtists.isNotEmpty) ...[
                SectionTitle(
                  title: "Similar Artists",
                  onMoreTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SeeMore(title: "Similar Artists", items: similarArtists, itemType: "artist",),))),
              
                SizedBox(height: 8,),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarArtists.length,
                    itemBuilder: (_, index) {
                      final simArtist = similarArtists[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ArtistPage(artist: simArtist)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: simArtist.imageUrl.isNotEmpty ? NetworkImage(simArtist.imageUrl) : null,
                  child: simArtist.imageUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(height: 10),
                Text(
                  simArtist.name,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= SECTION TITLE =================
class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onMoreTap;

  const SectionTitle({
    super.key,
    required this.title,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          CustomRoundedButton(
            title: "More",
            textColor: Colors.black,
            width: 70,
            height: 35,
            color: Theme.of(context).colorScheme.primaryContainer,
            onTap: onMoreTap,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
