import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app_flutter/Data/Model/song.dart';
import 'package:music_app_flutter/UI/Now_Playing/audio_player_manager.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.songs, required this.playingSong});

  final Songs playingSong;
  final List<Songs> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage(
      {super.key, required this.songs, required this.playingSong});

  final Songs playingSong;
  final List<Songs> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Songs _song;

  @override
  void initState() {
    super.initState();
    _song = widget.playingSong;
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 12000),
    );
    _audioPlayerManager =
        AudioPlayerManager(songUrl: widget.playingSong.source);
    _audioPlayerManager.init();
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);
  }

  @override
  Widget build(BuildContext context) {
    // return const Scaffold(
    //   body: Center(
    //     child: Text('Now Playing'),
    //   ),
    // );
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Now Playing',
          ),
          trailing:
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ),
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_song.album),
                const SizedBox(height: 16),
                const Text('_ ___ _'),
                const SizedBox(
                  height: 48,
                ),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/icon.png',
                      image: _song.image,
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/icon.png',
                          width: screenWidth - delta,
                          height: screenWidth - delta,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Column(
                          children: [
                            Text(
                              _song.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              _song.artist,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_outline),
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 32,
                    left: 24,
                    right: 24,
                    bottom: 10,
                  ),
                  child: _progressBar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 24,
                    right: 24,
                    bottom: 2,
                  ),
                  child: _mediaButtons(),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    super.dispose();
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: null,
              icon: Icons.shuffle,
              color: Colors.deepPurple,
              size: 24),
          MediaButtonControl(
              function: _setPrevSong,
              icon: Icons.skip_previous,
              color: Colors.deepPurple,
              size: 36),
          _playButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next,
              color: Colors.deepPurple,
              size: 36),
          MediaButtonControl(
              function: null,
              icon: Icons.repeat,
              color: Colors.deepPurple,
              size: 24),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5,
            // bufferedBarColor: Colors.amberAccent, //color of time
            // progressBarColor: Colors.red, //color of time was playing
            // thumbGlowColor: Colors.red, //color when you raise buffer or click
          );
        });
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playState = snapshot.data;
          final processingState = playState?.processingState;
          final playing = playState?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.play();
                },
                icon: Icons.play_arrow_outlined,
                color: null,
                size: 48);
          } else if (processingState != ProcessingState.completed) {
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.pause();
                },
                icon: Icons.pause,
                color: null,
                size: 48);
          } else {
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.seek(Duration.zero);
                },
                icon: Icons.replay,
                color: null,
                size: 48);
          }
        });
  }

  void _setNextSong() {
    ++_selectedItemIndex;
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    setState(() {
      _song = nextSong;
    });
  }

  void _setPrevSong() {
    --_selectedItemIndex;
    final prevSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(prevSong.source);
    setState(() {
      _song = prevSong;
    });
  }
}

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final double? size;
  final Color? color;

  @override
  State<StatefulWidget> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.function,
      icon: Icon(widget.icon),
      iconSize: widget.size,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}