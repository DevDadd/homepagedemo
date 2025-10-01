import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    return Color.fromRGBO(
      (this.red * (red ?? 1)).round(),
      (this.green * (green ?? 1)).round(),
      (this.blue * (blue ?? 1)).round(),
      alpha ?? this.opacity,
    );
  }
}

extension ThemeExtension on ThemeData {
  Color get blurAnimationHome {
    if (brightness == Brightness.light) {
      return const Color(0xFFF4F4F4);
    } else {
      return const Color(0xFF111315);
    }
  }
}
