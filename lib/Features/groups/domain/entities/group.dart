import 'package:moatmat_teacher/Features/groups/domain/entities/group_item.dart';

class Group {
  final int id;
  final String name;
  final String classRoom;
  final List<GroupItem> items;

  Group({
    required this.id,
    required this.name,
    required this.classRoom,
    required this.items,
  });

  Group copyWith({
    int? id,
    String? name,
    String? classRoom,
    List<GroupItem>? items,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
      classRoom: classRoom ?? this.classRoom,
    );
  }
}
