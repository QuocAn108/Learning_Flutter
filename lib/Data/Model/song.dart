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

  @override
  String toString() {
    return 'Songs{id: $id, title: $title, album: $album, artist: $artist, source: $source, image: $image, duration: $duration}';
  }
}
