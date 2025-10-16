import 'dart:ui';
import 'package:flutter/material.dart';

class MuaButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double leftRadius = 14; // Bo góc bên trái
    const double rightRadius = 3; // Bo góc bên phải
    const double cutWidth = 6; // Độ xiên (càng lớn càng thoải)

    // 🔹 Góc trên trái (bo 8px)
    path.moveTo(0, leftRadius);
    path.quadraticBezierTo(0, 0, leftRadius, 0);

    // 🔹 Cạnh trên đến gần góc phải
    path.lineTo(size.width - rightRadius, 0);

    // 🔹 Bo góc phải trên (4px)
    path.quadraticBezierTo(size.width, 0, size.width, rightRadius);

    // 🔹 Đường xiên xuống dưới phải (thoải)
    path.lineTo(size.width - cutWidth, size.height  - rightRadius);

    // 🔹 Bo góc phải dưới (4px)
    path.quadraticBezierTo(
      size.width - cutWidth - rightRadius,
      size.height ,
      size.width - cutWidth - 2 * rightRadius,
      size.height ,
    );

    // 🔹 Cạnh dưới về bên trái
    path.lineTo(leftRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - leftRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
