import 'package:flutter/material.dart';

/// Button types
enum CatalystButtonType { elevated, text, outlined, icon }

/// Button sizes
enum CatalystButtonSize { small, medium, large }

/// Catalyst Button widget
class CatalystButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final CatalystButtonType type;
  final CatalystButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const CatalystButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.type = CatalystButtonType.elevated,
    this.size = CatalystButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderRadius,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
  });

  /// Elevated button constructor
  factory CatalystButton.elevated({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    CatalystButtonSize size = CatalystButtonSize.medium,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CatalystButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: CatalystButtonType.elevated,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Text button constructor
  factory CatalystButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    CatalystButtonSize size = CatalystButtonSize.medium,
    Color? foregroundColor,
    bool isLoading = false,
  }) {
    return CatalystButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: CatalystButtonType.text,
      size: size,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
    );
  }

  /// Outlined button constructor
  factory CatalystButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    CatalystButtonSize size = CatalystButtonSize.medium,
    Color? foregroundColor,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return CatalystButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      type: CatalystButtonType.outlined,
      size: size,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Icon button constructor
  factory CatalystButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    CatalystButtonSize size = CatalystButtonSize.medium,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isLoading = false,
  }) {
    return CatalystButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      type: CatalystButtonType.icon,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidget = _buildButton(context);

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: buttonWidget);
    }

    return buttonWidget;
  }

  Widget _buildButton(BuildContext context) {
    final buttonPadding = padding ?? _getPadding();
    final buttonBorderRadius = borderRadius ?? BorderRadius.circular(8);

    if (isLoading) {
      return _buildLoadingButton(context, buttonPadding);
    }

    switch (type) {
      case CatalystButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            elevation: elevation,
            padding: buttonPadding,
            shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
          ),
          child: _buildButtonContent(),
        );

      case CatalystButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: buttonPadding,
            shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
          ),
          child: _buildButtonContent(),
        );

      case CatalystButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: buttonPadding,
            shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
            side: BorderSide(
              color: foregroundColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          child: _buildButtonContent(),
        );

      case CatalystButtonType.icon:
        return IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: foregroundColor,
          iconSize: _getIconSize(),
          padding: buttonPadding,
        );
    }
  }

  Widget _buildLoadingButton(BuildContext context, EdgeInsetsGeometry padding) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
      child: SizedBox(
        height: _getHeight(),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
          Text(text!, style: TextStyle(fontSize: _getFontSize())),
        ],
      );
    } else if (icon != null) {
      return Icon(icon, size: _getIconSize());
    } else if (text != null) {
      return Text(text!, style: TextStyle(fontSize: _getFontSize()));
    }
    return const SizedBox.shrink();
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CatalystButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case CatalystButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case CatalystButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    }
  }

  double _getHeight() {
    switch (size) {
      case CatalystButtonSize.small:
        return 32;
      case CatalystButtonSize.medium:
        return 40;
      case CatalystButtonSize.large:
        return 48;
    }
  }

  double _getFontSize() {
    switch (size) {
      case CatalystButtonSize.small:
        return 12;
      case CatalystButtonSize.medium:
        return 14;
      case CatalystButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CatalystButtonSize.small:
        return 16;
      case CatalystButtonSize.medium:
        return 20;
      case CatalystButtonSize.large:
        return 24;
    }
  }
}
