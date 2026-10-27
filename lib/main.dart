import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_note_app/screens/auth/note_screen.dart';
import 'package:smart_note_app/widgets/loading.dart';
import 'core/constant/app_strings.dart';
import 'core/theme/app_themes.dart';
import 'core/theme/theme_controller.dart';
import 'firebase_options.dart';
import 'providers/providers.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: DevixoNotesApp()));
}

class DevixoNotesApp extends ConsumerWidget {
  const DevixoNotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return auth.when(
      data: (user) =>
      user != null ? const NotesScreen() : const WelcomeScreen(),
      loading: () => const Scaffold(body: Loading(message: '')),
      error: (_, __) => const WelcomeScreen(),
    );
  }
}