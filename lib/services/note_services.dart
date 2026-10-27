import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/note_model.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(_uid).collection('notes');

  Stream<List<Note>> notesStream() => _col
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map(Note.fromDoc).toList());

  Future<void> save({
    String? id,
    required String title,
    required String content,
    File? newImage,
    String? existingImageUrl,
    bool removeImage = false,
  }) async {
    final doc = id == null ? _col.doc() : _col.doc(id);
    String? imageUrl = removeImage ? null : existingImageUrl;

    if (newImage != null) {
      final ref = _storage.ref('users/$_uid/notes/${doc.id}.jpg');
      await ref.putFile(newImage);
      imageUrl = await ref.getDownloadURL();
    } else if (removeImage) {
      await _deleteImage(doc.id);
    }

    await doc.set({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> delete(Note note) async {
    await _col.doc(note.id).delete();
    if (note.imageUrl != null) await _deleteImage(note.id);
  }

  Future<void> _deleteImage(String noteId) async {
    try {
      await _storage.ref('users/$_uid/notes/$noteId.jpg').delete();
    } catch (_) {}
  }
}