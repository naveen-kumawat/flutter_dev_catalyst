import 'package:flutter/material.dart';

/// Screen breakpoints
class ScreenBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Screen size enum
enum ScreenSize { mobile, tablet, desktop }

/// Responsive Builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;
  final Widget Function(BuildContext context)? mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Factory constructor for specific layouts
  factory ResponsiveBuilder.layouts({
    Key? key,
    required Widget Function(BuildContext context) mobile,
    Widget Function(BuildContext context)? tablet,
    Widget Function(BuildContext context)? desktop,
  }) {
    return ResponsiveBuilder(
      key: key,
      builder: (context, screenSize) {
        switch (screenSize) {
          case ScreenSize.mobile:
            return mobile(context);
          case ScreenSize.tablet:
            return (tablet ?? mobile)(context);
          case ScreenSize.desktop:
            return (desktop ?? tablet ?? mobile)(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(constraints.maxWidth);

        if (mobile != null || tablet != null || desktop != null) {
          switch (screenSize) {
            case ScreenSize.mobile:
              return mobile?.call(context) ?? builder(context, screenSize);
            case ScreenSize.tablet:
              return tablet?.call(context) ??
                  mobile?.call(context) ??
                  builder(context, screenSize);
            case ScreenSize.desktop:
              return desktop?.call(context) ??
                  tablet?.call(context) ??
                  mobile?.call(context) ??
                  builder(context, screenSize);
          }
        }

        return builder(context, screenSize);
      },
    );
  }

  ScreenSize _getScreenSize(double width) {
    if (width >= ScreenBreakpoints.desktop) {
      return ScreenSize.desktop;
    } else if (width >= ScreenBreakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }
}

/// Responsive helper methods
class Responsive {
  /// Check if mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ScreenBreakpoints.mobile;
  }

  /// Check if tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ScreenBreakpoints.mobile &&
        width < ScreenBreakpoints.desktop;
  }

  /// Check if desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ScreenBreakpoints.desktop;
  }

  /// Get screen size
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= ScreenBreakpoints.desktop) {
      return ScreenSize.desktop;
    } else if (width >= ScreenBreakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }

  /// Get responsive value
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive size
  static double size({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return value<double>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive padding
  static EdgeInsets padding({
    required BuildContext context,
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return value<EdgeInsets>(
      context: context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}

/// Responsive extension on BuildContext
extension ResponsiveContext on BuildContext {
  /// Check if mobile
  bool get isMobile => Responsive.isMobile(this);

  /// Check if tablet
  bool get isTablet => Responsive.isTablet(this);

  /// Check if desktop
  bool get isDesktop => Responsive.isDesktop(this);

  /// Get screen size
  ScreenSize get screenSize => Responsive.getScreenSize(this);

  /// Get responsive value
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    return Responsive.value<T>(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
}
