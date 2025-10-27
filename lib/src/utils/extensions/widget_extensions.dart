import 'package:flutter/material.dart';

/// Widget extensions for common operations
extension WidgetExtensions on Widget {
  /// Add padding
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// Add symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Add padding on all sides
  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Add padding only on specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Add margin (using Container)
  Widget margin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  /// Add symmetric margin
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// Add margin on all sides
  Widget marginAll(double margin) {
    return Container(margin: EdgeInsets.all(margin), child: this);
  }

  /// Center widget
  Widget center() {
    return Center(child: this);
  }

  /// Align widget
  Widget align(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  /// Expanded widget
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// Flexible widget
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }

  /// SizedBox with constraints
  Widget sizedBox({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// FittedBox
  Widget fittedBox({BoxFit fit = BoxFit.contain}) {
    return FittedBox(fit: fit, child: this);
  }

  /// AspectRatio
  Widget aspectRatio(double aspectRatio) {
    return AspectRatio(aspectRatio: aspectRatio, child: this);
  }

  /// Card wrapper
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      child: this,
    );
  }

  /// ClipRRect
  Widget clipRRect({double radius = 8.0}) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  /// ClipOval
  Widget clipOval() {
    return ClipOval(child: this);
  }

  /// Opacity
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Visibility
  Widget visible(bool visible, {Widget? replacement}) {
    return Visibility(
      visible: visible,
      replacement: replacement ?? const SizedBox.shrink(),
      child: this,
    );
  }

  /// Gesture Detector
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }

  /// InkWell
  Widget inkWell({required VoidCallback onTap, BorderRadius? borderRadius}) {
    return InkWell(onTap: onTap, borderRadius: borderRadius, child: this);
  }

  /// Hero animation
  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }

  /// IgnorePointer
  Widget ignorePointer({bool ignoring = true}) {
    return IgnorePointer(ignoring: ignoring, child: this);
  }

  /// AbsorbPointer
  Widget absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(absorbing: absorbing, child: this);
  }

  /// SafeArea
  /// SafeArea
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }

  /// Rotate widget
  Widget rotate({required double angle}) {
    return Transform.rotate(angle: angle, child: this);
  }

  /// Scale widget
  Widget scale({required double scale}) {
    return Transform.scale(scale: scale, child: this);
  }

  /// Translate widget
  Widget translate({required Offset offset}) {
    return Transform.translate(offset: offset, child: this);
  }

  /// Add tooltip
  Widget tooltip(String message) {
    return Tooltip(message: message, child: this);
  }

  /// Scrollable
  Widget scrollable({ScrollPhysics? physics, ScrollController? controller}) {
    return SingleChildScrollView(
      physics: physics,
      controller: controller,
      child: this,
    );
  }

  /// Shimmer effect placeholder
  Widget shimmer({
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: this,
    );
  }

  /// Decorated box
  Widget decorated({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        gradient: gradient,
      ),
      child: this,
    );
  }

  /// Constrained box
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0.0,
        maxWidth: maxWidth ?? double.infinity,
        minHeight: minHeight ?? 0.0,
        maxHeight: maxHeight ?? double.infinity,
      ),
      child: this,
    );
  }

  ///Fractionaly sized box
  Widget fractionalBox({double? widthFactor, double? heightFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }
}
