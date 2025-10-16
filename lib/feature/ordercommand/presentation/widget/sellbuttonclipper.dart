import 'dart:ui';
import 'package:flutter/material.dart';

class SellButtonFlippedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double topLeftRadius = 14;
    const double topRightRadius = 2;
    const double cutWidth = 5;

    // 🔹 Vẽ path xoay 180° (mirror cả ngang và dọc)
    path.moveTo(size.width, size.height - topLeftRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - topLeftRadius, size.height);

    path.lineTo(topRightRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - topRightRadius);

    path.lineTo(cutWidth, topRightRadius + cutWidth);
    path.quadraticBezierTo(
      cutWidth + topRightRadius,
      0,
      cutWidth + 2 * topRightRadius,
      0,
    );

    path.lineTo(size.width - topLeftRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, topLeftRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
