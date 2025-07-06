
class Video {
  final int id;
  final String url;

  Video({
    required this.id,
    required this.url,
  });

  Video copyWith({
    int? id,
    String? url,
    double? rating,
    int? ratingNum,
    int? views,
  }) {
    return Video(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }
}
