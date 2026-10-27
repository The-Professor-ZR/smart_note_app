

import 'package:flutter/material.dart';

import '../core/constant/app_strings.dart';

class Loading extends StatelessWidget {
  final String message;

  const Loading({super.key, this.message = AppStrings.loadingNotes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}