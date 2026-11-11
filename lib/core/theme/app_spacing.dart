import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Design baseline: 390 x 844 (see ScreenUtilInit in main.dart).
/// Spacing => .w / .h, radius => .r, text => .sp. None of these are const.
class AppSpacing {
  AppSpacing._();

  // Basic scale (base unit 4)
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;
  static double get large => 40.w;
  static double get extraLarge => 48.w;

  // Layout
  static double get screenHorizontal => 16.w;
  static double get cardPadding => 16.w;
  static double get betweenCards => 12.w;
  static double get betweenSections => 24.h;
}

/// Component sizes, radii and icon sizes from the dev spec.
class AppSizes {
  AppSizes._();

  // Radius
  static double get cardRadius => 16.r;
  static double get cardRadiusLg => 20.r;
  static double get buttonRadius => 14.r;
  static double get buttonRadiusLg => 16.r;
  static double get searchRadius => 28.r;
  static double get pillRadius => 20.r;
  static double get chipRadius => 12.r;
  static double get badgeRadius => 16.r;
  static double get ratingRadius => 6.r;
  static double get listImageRadius => 12.r;

  // Heights
  static double get searchBarHeight => 52.h;
  static double get chipHeight => 40.h;
  static double get buttonHeight => 56.h;
  static double get buttonHeightSm => 48.h;
  static double get badgeHeight => 28.h;
  static double get ratingHeight => 20.h;
  static double get navBarHeight => 64.h;
  static double get topRowHeight => 64.h;
  static double get bottomRowHeight => 56.h;
  static double get resultsHeaderHeight => 32.h;

  // Images
  static double get homeCardWidth => 164.w;
  static double get homeImageHeight => 128.h;
  static double get listImage => 96.w;

  // Icons
  static double get iconSm => 14.r;
  static double get iconMd => 20.r;
  static double get iconLg => 24.r;
  static double get iconCircle => 40.r;

  // Border
  static const double border = 1;
}
