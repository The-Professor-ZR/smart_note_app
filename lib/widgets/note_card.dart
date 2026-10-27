

import 'package:flutter/material.dart';
import '../core/constant/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/util/date_formatter.dart';
import '../models/note_model.dart';


class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppColors.noteCardsDark : AppColors.noteCardsLight;
    final textPrimary =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Material(
      color: colors[note.colorIndex],
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.imageUrl != null)
              SizedBox(
                height: 110,
                width: double.infinity,
                child: Image.network(
                  note.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: textSecondary.withOpacity(0.15),
                      alignment: Alignment.center,
                      child: const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: textSecondary.withOpacity(0.15),
                    alignment: Alignment.center,
                    child: Icon(Icons.broken_image_outlined,
                        color: textSecondary),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            note.title.isEmpty
                                ? AppStrings.untitled
                                : note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: textPrimary,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: AppStrings.delete,
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (note.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        note.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    DateFormatter.note(note.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}