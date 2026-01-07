import '../../domain/entities/folder_entity.dart';

class FolderModel {
  final int? id;
  final String name;
  final int color;
  final DateTime createdAt;

  FolderModel({
    this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'color': color,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  FolderEntity toEntity() => FolderEntity(
        id: id,
        name: name,
        colorValue: color,
        createdAt: createdAt,
      );
}
