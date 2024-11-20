import 'package:music_app_flutter/Data/Model/song.dart';
import 'package:music_app_flutter/Data/Source/source.dart';

abstract interface class Repository {
  Future<List<Songs>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Songs>?> loadData() async {
    List<Songs> songs = [];

    var remoteSongs = await _remoteDataSource.loadData();
    if (remoteSongs != null) {
      songs.addAll(remoteSongs);
    } else {
      var localSongs = await _localDataSource.loadData();
      if (localSongs != null) {
        songs.addAll(localSongs);
      }
    }
    return songs;
  }
}
