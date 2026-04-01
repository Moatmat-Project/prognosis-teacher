class College {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int schoolId;

  College({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.schoolId,
  });

  College copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    int? schoolId,
  }) {
    return College(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      schoolId: schoolId ?? this.schoolId,
    );
  }
}
