import 'dart:async';

import 'package:music_app_flutter/Data/Model/song.dart';
import 'package:music_app_flutter/Data/Repository/Repository.dart';

class MusicAppViewModel {
  StreamController<List<Songs>> songStream = StreamController();
  void loadSong() {
    final repository = DefaultRepository();
    repository.loadData().then((value) => songStream.add(value!));
  }
}
