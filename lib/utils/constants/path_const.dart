// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class PathConst {
  static const ASSETS = "assets/";
  static const SVG = "assets/svg/";
  static const PROFILE_IMAGES = "assets/profile_images/";
  static const IMAGES = "assets/images";
  static const TEMP = "assets/temp/";

  static const HOME_PAGE = "assets/home_page/";
  static const SETTINGS_PAGE = "assets/settings_page/";
}

extension PathExt on String {
  String get SVG => "${this}svg/";
  String get IMAGES => "${this}images/";
}
