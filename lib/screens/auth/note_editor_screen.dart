


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constant/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../models/note_model.dart';
import '../../providers/providers.dart';
import '../../services/note_services.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';


class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _title =
  TextEditingController(text: widget.note?.title ?? '');
  late final TextEditingController _content =
  TextEditingController(text: widget.note?.content ?? '');

  File? _newImage;
  bool _removeImage = false;

  bool get _isEditing => widget.note != null;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1280,
    );
    if (picked == null) return;
    setState(() {
      _newImage = File(picked.path);
      _removeImage = false;
    });
  }

  void _clearImage() {
    setState(() {
      _newImage = null;
      _removeImage = true;
    });
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final title = _title.text.trim();
    final content = _content.text.trim();

    if (title.isEmpty && content.isEmpty && _newImage == null) {
      _showMessage('Add a title or some text first');
      return;
    }

    final ok = await ref.read(notesControllerProvider.notifier).save(
      id: widget.note?.id,
      title: title,
      content: content,
      newImage: _newImage,
      existingImageUrl: widget.note?.imageUrl,
      removeImage: _removeImage,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      _showMessage(AppStrings.errorGeneric);
    }
  }

  Widget? _imagePreview() {
    if (_newImage != null) {
      return Image.file(_newImage!, fit: BoxFit.cover);
    }
    final url = widget.note?.imageUrl;
    if (!_removeImage && url != null) {
      return Image.network(url, fit: BoxFit.cover);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkPrimary : AppColors.primary;
    final preview = _imagePreview();
    final saving = ref.watch(notesControllerProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 20, 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed:
                    saving ? null : () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing
                            ? AppStrings.editNoteLabel
                            : AppStrings.newNoteLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        _isEditing ? AppStrings.editNote : AppStrings.addNote,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.captureMind,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _title,
                          label: AppStrings.noteTitleLabel,
                          hint: AppStrings.noteTitleHint,
                          enabled: !saving,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _content,
                          label: AppStrings.noteBodyLabel,
                          hint: AppStrings.noteBodyHint,
                          minLines: 9,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          enabled: !saving,
                        ),
                        if (preview != null) ...[
                          const SizedBox(height: 18),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: preview,
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Material(
                                  color: Colors.black54,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: saving ? null : _clearImage,
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        PrimaryButton(
                          label: AppStrings.saveNote,
                          icon: Icons.check,
                          isLoading: saving,
                          onPressed: _save,
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          label: preview == null
                              ? AppStrings.addImage
                              : 'Change image',
                          icon: Icons.image_outlined,
                          tonal: true,
                          onPressed: saving ? null : _pickImage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}