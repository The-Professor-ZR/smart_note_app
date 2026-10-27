import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.updatedAt,
  });

  factory Note.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final ts = data['updatedAt'];
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      updatedAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  int get colorIndex =>
      id.codeUnits.fold<int>(0, (sum, c) => sum + c) % 5;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        content.toLowerCase().contains(q);
  }
}