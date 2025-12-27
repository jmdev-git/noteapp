import 'category.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final Category? category;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'category': category?.id,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
