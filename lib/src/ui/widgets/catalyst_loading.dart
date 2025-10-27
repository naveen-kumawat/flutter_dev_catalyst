import 'package:flutter/material.dart';

/// Loading indicator types
enum LoadingType { circular, linear, custom }

/// Loading sizes
enum LoadingSize { small, medium, large }

/// Catalyst Loading widget
class CatalystLoading extends StatelessWidget {
  final LoadingType type;
  final LoadingSize size;
  final Color? color;
  final String? message;
  final double? value;
  final Widget? customLoader;

  const CatalystLoading({
    super.key,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.value,
    this.customLoader,
  });

  /// Circular loading constructor
  factory CatalystLoading.circular({
    Key? key,
    LoadingSize size = LoadingSize.medium,
    Color? color,
    String? message,
  }) {
    return CatalystLoading(
      key: key,
      type: LoadingType.circular,
      size: size,
      color: color,
      message: message,
    );
  }

  /// Linear loading constructor
  factory CatalystLoading.linear({
    Key? key,
    Color? color,
    double? value,
    String? message,
  }) {
    return CatalystLoading(
      key: key,
      type: LoadingType.linear,
      color: color,
      value: value,
      message: message,
    );
  }

  /// Custom loading constructor
  factory CatalystLoading.custom({
    Key? key,
    required Widget customLoader,
    String? message,
  }) {
    return CatalystLoading(
      key: key,
      type: LoadingType.custom,
      customLoader: customLoader,
      message: message,
    );
  }

  /// Full screen loading overlay
  // Line 84 - Replace WillPopScope with PopScope
  static void show(
      BuildContext context, {
        String? message,
        bool barrierDismissible = false,
      }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (context) => PopScope(  // Changed from WillPopScope
        canPop: barrierDismissible,    // Changed from onWillPop
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CatalystLoading(
                message: message,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hide loading overlay
  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loaderColor = color ?? theme.colorScheme.primary;

    Widget loader;

    switch (type) {
      case LoadingType.circular:
        loader = SizedBox(
          width: _getSize(),
          height: _getSize(),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            strokeWidth: _getStrokeWidth(),
          ),
        );
        break;

      case LoadingType.linear:
        loader = LinearProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
          backgroundColor: loaderColor.withOpacity(0.2),
        );
        break;

      case LoadingType.custom:
        loader = customLoader ?? const SizedBox.shrink();
        break;
    }

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loader,
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loader;
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.small:
        return 24.0;
      case LoadingSize.medium:
        return 40.0;
      case LoadingSize.large:
        return 60.0;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2.0;
      case LoadingSize.medium:
        return 3.0;
      case LoadingSize.large:
        return 4.0;
    }
  }
}

/// Shimmer loading effect
class CatalystShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final bool enabled;

  const CatalystShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<CatalystShimmer> createState() => _CatalystShimmerState();
}

class _CatalystShimmerState extends State<CatalystShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 - _controller.value * 2, 0),
              end: Alignment(1.0 + _controller.value * 2, 0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Skeleton loading widget
class CatalystSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const CatalystSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// Circle skeleton
  factory CatalystSkeleton.circle({
    Key? key,
    required double size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return CatalystSkeleton(
      key: key,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  /// Rectangular skeleton
  factory CatalystSkeleton.rectangular({
    Key? key,
    double? width,
    double? height,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return CatalystSkeleton(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBaseColor =
        baseColor ??
        (isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0));
    final effectiveHighlightColor =
        highlightColor ??
        (isDark ? const Color(0xFF616161) : const Color(0xFFF5F5F5));

    return CatalystShimmer(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBaseColor,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}
