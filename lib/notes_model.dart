class NotesModel {
  final int id;
  final String title;
  final String? description;
  final DateTime createdAt;

  NotesModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
