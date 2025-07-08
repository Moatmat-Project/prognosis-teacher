class Video {
  final int id;
  final String url;
  final String teacherId;

  Video({
    required this.id,
    required this.url,
    required this.teacherId,
  });

  Video copyWith({
    int? id,
    String? url,
    String? teacherId,
  }) {
    return Video(
      id: id ?? this.id,
      url: url ?? this.url,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}
