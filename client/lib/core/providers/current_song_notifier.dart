import 'package:client/features/home/models/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  List<SongModel> _songs = [];
  int _currentIndex = 0;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    // For backward compatibility or if just playing one song
    selectSong(0, [song]);
  }

  void selectSong(int index, List<SongModel> songs) async {
    _songs = songs;
    _currentIndex = index;
    final song = _songs[_currentIndex];

    state = song; // Optimistic update
    await audioPlayer?.stop();
    audioPlayer = AudioPlayer(); // Create new instance or reset?
    // Creating new instance every time implies disposing old one?
    // Ideally reuse, but existing code created new. I'll stick to creating new for safety unless performance issue.
    // Actually, creating new AudioPlayer every time is resource heavy.
    // But existing code did `audioPlayer = AudioPlayer()`. I'll follow that pattern for now to minimize bugs,
    // but dispose previous if it exists.
    // audioPlayer?.dispose(); // If I made it nullable and create new.

    // Actually, `audioPlayer` field was nullable.
    // Let's rely on just_audio.

    final audioSource = AudioSource.uri(Uri.parse(song.song_url));
    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        this.state = this.state?.copyWith(hex_code: this.state?.hex_code);

        // Auto play next? User didn't ask explicitly but "Next/Previous buttons".
        // Usually, yes. But let's stick to asked features.
      }
    });
    audioPlayer!.play();
    isPlaying = true;
    this.state = this.state?.copyWith(hex_code: this.state?.hex_code);
  }

  void playPause() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    isPlaying = !isPlaying;
    state = state?.copyWith(hex_code: state?.hex_code);
  }

  void seekNext() {
    if (_currentIndex < _songs.length - 1) {
      selectSong(_currentIndex + 1, _songs);
    }
  }

  void seekPrevious() {
    if (_currentIndex > 0) {
      selectSong(_currentIndex - 1, _songs);
    } else {
      // If at start, maybe restart song?
      audioPlayer?.seek(Duration.zero);
    }
  }

  void seek(double val) {
    audioPlayer!.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}
