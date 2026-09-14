class Reminder {
  final String id;
  final String title;
  final String details;
  final DateTime dueAt;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reminder({
    required this.id,
    required this.title,
    required this.details,
    required this.dueAt,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? details,
    DateTime? dueAt,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'dueAt': dueAt.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      details: json['details'] as String,
      dueAt: DateTime.parse(json['dueAt'] as String),
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
