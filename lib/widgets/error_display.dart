import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Standardized error display widget for consistent error handling
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    required this.error,
    this.onRetry,
    this.title = 'Fehler',
    super.key,
  });

  final String error;
  final VoidCallback? onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 48,
              color: scheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: AppTheme.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Erneut versuchen'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading indicator with optional message
class LoadingDisplay extends StatelessWidget {
  const LoadingDisplay({
    this.message = 'Wird geladen...',
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state display when no data is available
class EmptyStateDisplay extends StatelessWidget {
  const EmptyStateDisplay({
    required this.message,
    this.icon = Icons.inbox_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
