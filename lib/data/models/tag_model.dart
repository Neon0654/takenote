import '../../domain/entities/tag_entity.dart';

class TagModel {
  final int? id;
  final String name;

  TagModel({this.id, required this.name});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'],
      name: map['name'],
    );
  }

  TagEntity toEntity() => TagEntity(
        id: id,
        name: name,
      );
}
