// {
// "songs": [
// {
// "id": "1121429554",
// "title": "Chạy Về Khóc Với Anh",
// "album": "Chạy Về Khóc Với Anh(Single)",
// "artist": "ERIK",
// "source": "https://thantrieu.com/resources/music/1121429554.mp3",
// "image": "https://thantrieu.com/resources/arts/1121429554.webp",
// "duration": 224,
// "favorite": "false",
// "counter": 20,
// "replay": 0
// },
import 'package:flutter/material.dart';

class Songs {
  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  int duration;

  Songs(
      {required this.id,
      required this.title,
      required this.album,
      required this.artist,
      required this.source,
      required this.image,
      required this.duration});

  factory Songs.fromJson(Map<String, dynamic> map) {
    return Songs(id: map['id'], title: map['title'], album: map['album'], artist: map['artist'], source: map['source'], image: map['image'], duration: map['duration']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Songs && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
