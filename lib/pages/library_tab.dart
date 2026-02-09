import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/pages/more/see_more.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:music_app/pages/settings_tab.dart';
import 'package:music_app/pages/song_option.dart';
import 'package:music_app/provider/playlist_provider.dart';
import 'package:music_app/provider/users_provider.dart';
import 'package:music_app/services/playlist_service.dart';
import 'package:music_app/utils/shorcuts.dart';
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:music_app/widgets/playlist_row_item.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:music_app/widgets/tags.dart';
import 'package:provider/provider.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final playlistProvider = context.watch<PlaylistProvider>();
    final userProvider = context.watch<UsersProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 0),
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
                      "MUSIC LIBRARY",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                      // const SizedBox(height: 20),
                    ],
                  ),
                 IconButton(onPressed: () => push(context, SettingsTab()), icon: Icon(Icons.settings, color: cs.onPrimary, size: 25)),
                
               
                
              
              ],
            
            ),
             const SizedBox(height: 20),
          Tags(),
          SizedBox(height: 25,),
       Row(
         children: [
           Expanded(
             child: Container(
              // width: ,
              height: 50,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                // Use height/2 to ensure a perfect "stadium" shape (pill shape)
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.purple, size: 30),
                    const SizedBox(width: 8),
                    Text(
                      "Likes",
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
                   ),
           ),
                 SizedBox(width: 20,),
                 Expanded(
                   child: Container(
                               // width: ,
                               height: 50,
                               decoration: BoxDecoration(
                                 color: cs.primaryContainer,
                                 // Use height/2 to ensure a perfect "stadium" shape (pill shape)
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               alignment: Alignment.center,
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   // mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                    Icon(Icons.history, color: Colors.purple[200], size: 30),
                    const SizedBox(width: 8),
                    Text(
                      "Recently Played ",
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                                   ],
                                 ),
                               ),
                   ),
                 ),
         ],
       ),
        const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Playlist', style: Theme.of(context).textTheme.bodyMedium,),
                          CustomRoundedButton(title: "+ New Playlist", width: 150, height: 40, fontSize: 13.0,
                          
                           color: cs.primaryContainer, textColor: Colors.black, onTap: () {
                            _showCreatePlaylistModal(context);
                            
                          })
                        ],
                      ),
          const SizedBox(height: 20),
//            Row(
//               children: [
                   
//                 Container(
//                   width: 62, height: 62,
//                   decoration: BoxDecoration(
//                     color: Colors.blue[200],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child:Icon(Icons.music_note, color: Colors.blue[100], size: 40,), ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           // push(context, PlaylistPage(playlist: playl));
//                         },
//                         child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
                        
//                           children: [
//                           Text("My Playlist", style: Theme.of(context).textTheme.labelSmall,),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Text("15 songs", style: Theme.of(context).textTheme.bodySmall,),
//                             SizedBox(width: 4),
//                             Icon(Icons.circle, size: 4, color: cs.onPrimary,),
//                             SizedBox(width: 4),
//                             Text("By you", style: Theme.of(context).textTheme.bodySmall,),
//                           ],
//                         ),
//                           ],
//                         ),
//                       ),
                     
// IconButton(
//   onPressed: () async {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Allows sheet to height of content
//       backgroundColor: Colors.transparent, // Required for custom rounded corners
//       builder: (context) => const FractionallySizedBox(
//         heightFactor: 0.55, // Adjust how high the sheet goes
//         child: SongOptionsSheet(),
//       ),
//     );
//   },
//   icon: Icon(Icons.more_horiz, size: 20, color: cs.onPrimary),
// )
//                     ],
//                   ),
//                 ),
                
//               ],
//             ),
              if (playlistProvider.playlist.isNotEmpty) ...[
                          
                          const SizedBox(height: 8),
                          ...playlistProvider.playlist.where((p) => p.ownerId == userProvider.currentUser?.id).map((p) {
                            
                            return GestureDetector(
                              onTap: (){
                    push(context, PlaylistPage(playlist: p));

                              },
                              child: PlaylistRowItem(
                                index: playlistProvider.playlist.indexOf(p).toString(),
                                title: p.name,
                                subtitle:p.description,
                                    
                              ),
                            );
                          }),
                        ],
          ],

        ),
        ),
    );
  }
}void _showCreatePlaylistModal(BuildContext context) {
  final FocusNode focusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });

      return Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create a playlist',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                CustomRoundedButton(
                  title: "Save",
                  width: 70,
                  height: 36,
                  color: const Color(0xFFFF56F3),
                  textColor: Colors.white,
                  fontSize: 13,
                  onTap: () async {
                    final name = nameController.text.trim();
                    final description =
                        descriptionController.text.trim();

                    if (name.isEmpty) return;

                    Playlist? playlist =await PlaylistService().createPlaylist(
                      name: name,
                      description: description,
                    );
                    await context.read<PlaylistProvider>().fetchPlaylists();

                    Navigator.pop(context);

                    push(context, PlaylistPage(playlist: playlist));
                  },
                )
              ],
            ),

            const SizedBox(height: 15),

            /// Name
            Text(
              'Playlist name*',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Description
            Text(
              'Playlist description',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Tell us more about your playlist',
                hintStyle:
                    TextStyle(color: Colors.grey[500], fontSize: 13),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ).then((_) {
    focusNode.dispose();
 
  });
}
