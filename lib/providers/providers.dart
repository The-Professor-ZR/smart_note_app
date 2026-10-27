

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constant/app_strings.dart';
import '../models/note_model.dart';
import '../services/auth_services.dart';
import '../services/note_services.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final notesServiceProvider = Provider<NotesService>((ref) => NotesService());

final authStateProvider = StreamProvider<User?>(
      (ref) => ref.watch(authServiceProvider).authChanges,
);

final notesStreamProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(notesServiceProvider).notesStream();
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredNotesProvider = Provider.autoDispose<List<Note>>((ref) {
  final notes = ref.watch(notesStreamProvider).valueOrNull ?? const <Note>[];
  final query = ref.watch(searchQueryProvider);
  return notes.where((n) => n.matches(query)).toList();
});

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return null;
    } on AuthException catch (e) {
      state = const AsyncData(null);
      return e.message;
    } catch (_) {
      state = const AsyncData(null);
      return AppStrings.errorGeneric;
    }
  }

  Future<String?> login(String email, String password) =>
      _run(() => ref.read(authServiceProvider).login(email, password));

  Future<String?> register(String email, String password) =>
      _run(() => ref.read(authServiceProvider).register(email, password));

  Future<String?> sendReset(String email) =>
      _run(() => ref.read(authServiceProvider).sendResetEmail(email));
}

final authControllerProvider =
AsyncNotifierProvider<AuthController, void>(AuthController.new);

class NotesController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save({
    String? id,
    required String title,
    required String content,
    File? newImage,
    String? existingImageUrl,
    bool removeImage = false,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(notesServiceProvider).save(
        id: id,
        title: title,
        content: content,
        newImage: newImage,
        existingImageUrl: existingImageUrl,
        removeImage: removeImage,
      );
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> delete(Note note) async {
    try {
      await ref.read(notesServiceProvider).delete(note);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final notesControllerProvider =
AsyncNotifierProvider<NotesController, void>(NotesController.new);