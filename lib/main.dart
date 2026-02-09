import 'package:flutter/material.dart';
import 'package:music_app/pages/auth/splash_screen.dart';
import 'package:music_app/pages/library_tab.dart';
import 'package:music_app/pages/explore_tab.dart';
import 'package:music_app/pages/search_tab.dart';
import 'package:music_app/pages/play_tab.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/playlist_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/widgets/global_player.dart';
import 'package:music_app/widgets/layout/app_bottom_nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongsProvider()),
        ChangeNotifierProvider(create: (_) => ArtistsProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Theming',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor:  Colors.white, // Light background
        primaryColor: const Color(0xFF6200EE), // Light accent
        secondaryHeaderColor: Colors.grey.shade200,
        colorScheme: const ColorScheme.light(
          surfaceContainerLow:Color.fromARGB(66, 158, 158, 158),
             primaryContainer: Color.fromARGB(255, 234, 232, 232),

          primary: Color(0xFF6200EE),
          // background: Color(0xFFF5F5F5),
          onPrimary: Colors.black,
          // onBackground: Colors.black,
        ),
        textTheme:  TextTheme(
          bodySmall: TextStyle(color: Colors.black, fontSize: 13),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 17,fontWeight: FontWeight.w900),
          labelSmall: TextStyle(color: Colors.black, fontSize: 13,fontWeight: FontWeight.w900),
          labelLarge: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w900),
          
          titleMedium: GoogleFonts.oswald(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),

          titleLarge: GoogleFonts.oswald(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900),
          
        ),
      ),
      darkTheme: ThemeData( 
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
        primaryColor: const Color(0xFFBB86FC), // Dark accent
        secondaryHeaderColor: Colors.grey.shade800,

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC),
          
          // background: Color(0xFF121212),
          onPrimary: Colors.white,
          // onBackground: Colors.white,
        ),
        textTheme:TextTheme(
            bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
            titleLarge: GoogleFonts.oswald(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
         
        ),

      ),
      themeMode: ThemeMode.system, // Uses system theme
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  int _selectedIndex = 0;
  bool _initialized = false;
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeProviders();
  });
}


Future<void> _initializeProviders() async {
  if (_initialized) return;
  _initialized = true;

  await context.read<AlbumProvider>().fetchAlbums();
  await context.read<ArtistsProvider>().fetchArtists();
  await context.read<ArtistsProvider>().fetchFollowedArtist();

  await context.read<SongsProvider>().fetchSongs(); 
  await context.read<SongsProvider>().fetchLikedSongs(); 

  await context.read<SongsProvider>().fetchRecentlyPlayedSongs();
  await context.read<SongsProvider>().fetchMostPlayedSongs();

  await context.read<UsersProvider>().fetchUsers();
  await context.read<UsersProvider>().getCurrentUser();
  await context.read<UsersProvider>().fetchUsersFollowing();
  await context.read<UsersProvider>().fetchUsersFollowers();

  await context.read<PlaylistProvider>().fetchPlaylists();
  await context.read<PlayerProvider>().playCurrentSong();


}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // ---------------- Main App Tabs ----------------
        IndexedStack(
          index: _selectedIndex,
          children: const [
            ExploreTab(),
            SearchTab(),
            LibraryTab(),
          ],
        ),

        // ---------------- Global Player ----------------
        const GlobalPlayerWidget(),
      ],
    ),

    // Bottom navigation remains clickable
    bottomNavigationBar: AppBottomNav(
      selectedIndex: _selectedIndex,
      onSelected: (index) {
        setState(() => _selectedIndex = index);
      },
    ),
  );
}
}