import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: AppTheme.textMuted),
          const SizedBox(height: 16),
          Text(
            'No products found.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}