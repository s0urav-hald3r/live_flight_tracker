import 'package:flutter/widgets.dart';

extension SizeExtensions on num {
  /// Scales the width based on the Figma design width (375 in this example)
  double get w =>
      this *
      (MediaQueryData.fromView(WidgetsBinding.instance.window).size.width /
          375);

  /// Scales the height based on the Figma design height (812 in this example)
  double get h =>
      this *
      (MediaQueryData.fromView(WidgetsBinding.instance.window).size.height /
          812);
}
