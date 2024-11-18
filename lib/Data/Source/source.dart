import 'dart:convert';

import 'package:music_app_flutter/Data/Model/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<Songs>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Songs>?> loadData() async {
    const url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final bodyContent = utf8.decode(response
          .bodyBytes); //receive data in internet have  vietnamese character, so you must use it
      var songWrapper = jsonDecode(bodyContent) as Map; //response.body to don't need vietnamese character
      var songList = songWrapper['songs'] as List;
      List<Songs> songs = songList.map((song) => Songs.fromJson(song)).toList();
      return songs;
    } else {
      return null;
    }
  }
}

//flutter pub add http , command help receive data from internet
class LocalDataSource implements DataSource {
  @override
  Future<List<Songs>?> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}
