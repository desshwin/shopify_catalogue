import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PaginationLoaderWidget extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMore;
  final int itemCount;
  final String? paginationError;
  final VoidCallback? onRetryPagination;

  const PaginationLoaderWidget({
    super.key,
    required this.isLoadingMore,
    required this.hasMore,
    required this.itemCount,
    this.paginationError,
    this.onRetryPagination,
  });

  @override
  Widget build(BuildContext context) {
    if (paginationError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load more.', style: TextStyle(color: AppTheme.errorRed, fontSize: 12)),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onRetryPagination,
                child: const Text('Retry', style: TextStyle(color: AppTheme.primaryIndigo)),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryIndigo),
          ),
        ),
      );
    }

    if (!hasMore && itemCount > 5) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            'Loading more crafted essentials...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}