import 'package:flutter/material.dart';

/// Error widget types
enum ErrorWidgetType { simple, detailed, fullScreen }

/// Catalyst Error Widget
class CatalystErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final String? details;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final ErrorWidgetType type;
  final Color? color;

  const CatalystErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.details,
    this.icon,
    this.onRetry,
    this.retryButtonText,
    this.type = ErrorWidgetType.simple,
    this.color,
  });

  /// Simple error widget
  factory CatalystErrorWidget.simple({
    Key? key,
    required String message,
    VoidCallback? onRetry,
    Color? color,
  }) {
    return CatalystErrorWidget(
      key: key,
      message: message,
      onRetry: onRetry,
      type: ErrorWidgetType.simple,
      color: color,
    );
  }

  /// Detailed error widget
  factory CatalystErrorWidget.detailed({
    Key? key,
    required String message,
    String? title,
    String? details,
    IconData? icon,
    VoidCallback? onRetry,
    String? retryButtonText,
    Color? color,
  }) {
    return CatalystErrorWidget(
      key: key,
      message: message,
      title: title,
      details: details,
      icon: icon,
      onRetry: onRetry,
      retryButtonText: retryButtonText,
      type: ErrorWidgetType.detailed,
      color: color,
    );
  }

  /// Full screen error widget
  factory CatalystErrorWidget.fullScreen({
    Key? key,
    required String message,
    String? title,
    IconData? icon,
    VoidCallback? onRetry,
    String? retryButtonText,
    Color? color,
  }) {
    return CatalystErrorWidget(
      key: key,
      message: message,
      title: title,
      icon: icon,
      onRetry: onRetry,
      retryButtonText: retryButtonText,
      type: ErrorWidgetType.fullScreen,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ErrorWidgetType.simple:
        return _buildSimpleError(context);
      case ErrorWidgetType.detailed:
        return _buildDetailedError(context);
      case ErrorWidgetType.fullScreen:
        return _buildFullScreenError(context);
    }
  }

  Widget _buildSimpleError(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = color ?? theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: errorColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: errorColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: errorColor,
                  ),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                child: Text(retryButtonText ?? 'Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedError(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = color ?? theme.colorScheme.error;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon ?? Icons.error_outline, color: errorColor, size: 48),
            const SizedBox(height: 16),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: errorColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  details!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenError(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = color ?? theme.colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.error_outline, color: errorColor, size: 80),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: errorColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class CatalystEmptyWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final Widget? action;

  const CatalystEmptyWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_outlined,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
