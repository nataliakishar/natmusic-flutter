class MusicModel {
  String title;
  final String path;

  MusicModel({
    required this.title,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'path': path,
      };

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      title: json['title'],
      path: json['path'],
    );
  }
}
