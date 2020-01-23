
class Song {
  final String path;
  final String title;
  final String artist;
  final String lirik;
  final String lirik2;
  final String lirik3;
  final String time;

  Song({this.path, this.title, this.artist, this.lirik, this.lirik2, this.lirik3, this.time});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      path: json['path'],
      title: json['title'],
      artist: json['artist'],
      lirik: json['lirik'],
      lirik2: json['lirik2'],
      lirik3: json['lirik3'],
      time: json['time'],
    );
  }
}