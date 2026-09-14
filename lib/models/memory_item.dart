class MemoryItem {
  const MemoryItem({
    required this.id,
    required this.title,
    required this.details,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String details;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemoryItem copyWith({
    String? title,
    String? details,
    String? category,
    DateTime? updatedAt,
  }) {
    return MemoryItem(
      id: id,
      title: title ?? this.title,
      details: details ?? this.details,
      category: category ?? this.category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'id': id,
        'title': title,
        'details': details,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory MemoryItem.fromJson(Map<String, Object?> json) {
    return MemoryItem(
      id: json['id']! as String,
      title: json['title']! as String,
      details: json['details']! as String,
      category: (json['category'] as String?) ?? 'Other',
      createdAt: DateTime.parse(json['createdAt']! as String),
      updatedAt: DateTime.parse(json['updatedAt']! as String),
    );
  }
}
