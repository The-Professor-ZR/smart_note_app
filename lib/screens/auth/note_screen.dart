


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constant/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import '../../models/note_model.dart';
import '../../providers/providers.dart';
import '../../services/auth_services.dart';
import '../../services/note_services.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading.dart';
import '../../widgets/note_card.dart';
import '../../widgets/note_search_bar.dart';
import 'note_editor_screen.dart';


class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openEditor([Note? note]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
    );
  }

  Future<void> _delete(Note note) async {
    final confirmed = await showConfirmDeleteDialog(context);
    if (!confirmed) return;
    final ok = await ref.read(notesControllerProvider.notifier).delete(note);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final notesAsync = ref.watch(notesStreamProvider);
    final filtered = ref.watch(filteredNotesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newNote),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
              child: Row(
                children: [
                  const AppLogo(size: 44, showTitle: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appNameUpper,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          AppStrings.myNotes,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Theme',
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                    onPressed: () => ref
                        .read(themeControllerProvider.notifier)
                        .toggle(isDark),
                  ),
                  IconButton(
                    tooltip: 'Logout',
                    icon: const Icon(Icons.logout),
                    onPressed: () => ref.read(authServiceProvider).logout(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: NotesSearchBar(
                controller: _search,
                onChanged: (v) =>
                ref.read(searchQueryProvider.notifier).state = v,
                onClear: () {
                  _search.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
            ),
            Expanded(
              child: notesAsync.when(
                loading: () => const Loading(),
                error: (_, __) => const EmptyState(
                  icon: Icons.error_outline,
                  title: 'Something went wrong',
                  message: AppStrings.errorGeneric,
                ),
                data: (all) {
                  if (all.isEmpty) {
                    return EmptyState(
                      icon: Icons.description_outlined,
                      title: AppStrings.noNotesTitle,
                      message: AppStrings.noNotesBody,
                      actionLabel: AppStrings.createFirstNote,
                      onAction: () => _openEditor(),
                    );
                  }
                  if (filtered.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search,
                      title: AppStrings.noMatchesTitle,
                      message: AppStrings.noMatchesBody,
                    );
                  }
                  return _NotesGrid(
                    notes: filtered,
                    onOpen: _openEditor,
                    onDelete: _delete,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final void Function(Note) onOpen;
  final void Function(Note) onDelete;

  const _NotesGrid({
    required this.notes,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 3 : (width >= 600 ? 2 : 1);

        final lists = List.generate(columns, (_) => <Note>[]);
        for (var i = 0; i < notes.length; i++) {
          lists[i % columns].add(notes[i]);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var c = 0; c < columns; c++) ...[
                if (c > 0) const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    children: [
                      for (final note in lists[c])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: NoteCard(
                            note: note,
                            onTap: () => onOpen(note),
                            onDelete: () => onDelete(note),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}