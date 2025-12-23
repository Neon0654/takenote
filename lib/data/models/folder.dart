class Folder {
  final int? id;
  final String name;
  final int color; // lưu Color.value
  final DateTime createdAt;

  Folder({
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

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
