import 'package:flutter/material.dart';
import 'package:music_app_flutter/Data/Model/song.dart';

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

class _NowPlayingPageState extends State<NowPlayingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Now Playing'),
      ),
    );
  }
}
