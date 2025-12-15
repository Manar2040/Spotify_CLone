import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  List<SongModel> _queue = [];
  int _currentIndex = 0;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  void updateSong(SongModel song) async {
    await _playSong(song);
  }

  void selectSong(int index, List<SongModel> songs) async {
    _currentIndex = index;
    _queue = songs;
    await _playSong(songs[index]);
  }

  Future<void> _playSong(SongModel song) async {
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer();
      audioPlayer!.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          seekNext();
        }
      });
    }

    if (isPlaying) {
      await audioPlayer!.stop();
    }

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        title: song.song_name,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    await audioPlayer!.setAudioSource(audioSource);

    _homeLocalRepository.uploadLocalSong(song);

    audioPlayer!.play();
    isPlaying = true;
    state = song;
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

  void seek(double val) {
    if (audioPlayer != null && audioPlayer!.duration != null) {
      audioPlayer!.seek(
        Duration(
          milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
        ),
      );
    }
  }

  void seekNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await _playSong(_queue[_currentIndex]);
    } else {
      // Loop back to start or stop? Let's stop for now or just replay last.
      // For a proper playlist feel, typically you might stop or loop.
      // Let's loop to start if it's the last song.
      _currentIndex = 0;
      await _playSong(_queue[_currentIndex]);
    }
  }

  void seekPrevious() async {
    if (audioPlayer != null && audioPlayer!.position.inSeconds > 2) {
      audioPlayer!.seek(Duration.zero);
      return;
    }

    if (_currentIndex > 0) {
      _currentIndex--;
      await _playSong(_queue[_currentIndex]);
    } else {
      // Go to last song if at beginning?
      _currentIndex = _queue.length - 1;
      await _playSong(_queue[_currentIndex]);
    }
  }
}
