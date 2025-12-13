import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<SongModel> testSongs = [
      SongModel(
        id: '1',
        song_name: 'Test Song 1',
        artist: 'Artist 1',
        thumbnail_url:
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
        song_url:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        hex_code: '#FF0000',
      ),
      SongModel(
        id: '2',
        song_name: 'Test Song 2',
        artist: 'Artist 2',
        thumbnail_url:
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
        song_url:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        hex_code: '#00FF00',
      ),
      SongModel(
        id: '3',
        song_name: 'Test Song 3',
        artist: 'Artist 3',
        thumbnail_url:
            'https://images.unsplash.com/photo-1493225255756-d9584f8606e9',
        song_url:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        hex_code: '#0000FF',
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const UploadSongPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: testSongs.length,
        itemBuilder: (context, index) {
          final song = testSongs[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(song.thumbnail_url),
            ),
            title: Text(song.song_name),
            subtitle: Text(song.artist),
            onTap: () {
              ref
                  .read(currentSongProvider.notifier)
                  .selectSong(index, testSongs);
            },
          );
        },
      ),
    );
  }
}
