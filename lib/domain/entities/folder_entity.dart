class FolderEntity {
  final int? id;
  final String name;
  final int colorValue;
  final DateTime createdAt;

  const FolderEntity({
    this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
  });
}
