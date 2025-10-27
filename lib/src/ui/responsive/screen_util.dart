import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen Util wrapper for responsive sizing
class CatalystScreenUtil {
  /// Initialize screen util
  static void init(BuildContext context) {
    ScreenUtil.init(context);
  }

  /// Get screen width
  static double get screenWidth => ScreenUtil().screenWidth;

  /// Get screen height
  static double get screenHeight => ScreenUtil().screenHeight;

  /// Set width
  static double setWidth(num width) => ScreenUtil().setWidth(width);

  /// Set height
  static double setHeight(num height) => ScreenUtil().setHeight(height);

  /// Set font size
  static double setFontSize(num fontSize) => ScreenUtil().setSp(fontSize);

  /// Set radius
  static double radius(num radius) => ScreenUtil().radius(radius);
}

/// Responsive size extensions
extension ResponsiveSizeExtension on num {
  /// Width
  double get w => ScreenUtil().setWidth(this);

  /// Height
  double get h => ScreenUtil().setHeight(this);

  /// Font size
  double get sp => ScreenUtil().setSp(this);

  /// Radius
  double get r => ScreenUtil().radius(this);

  /// Screen width ratio
  double get sw => ScreenUtil().screenWidth * this;

  /// Screen height ratio
  double get sh => ScreenUtil().screenHeight * this;
}
