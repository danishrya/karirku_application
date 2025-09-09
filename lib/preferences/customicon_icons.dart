// Place fonts/CustomIcon.ttf in your fonts/ directory and
// add the following to your pubspec.yaml
// flutter:
//   fonts:
//    - family: CustomIcon
//      fonts:
//       - asset: fonts/CustomIcon.ttf
import 'package:flutter/widgets.dart';

class CustomIcon {
  CustomIcon._();

  static const String _fontFamily = 'CustomIcon';

  static const IconData vector1 = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData vector = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData search = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData group = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData equalizer = IconData(0xe992, fontFamily: _fontFamily);
  static const IconData heart = IconData(0xe9da, fontFamily: _fontFamily);
}
