import 'dart:ui';
import 'package:flutter/material.dart';

class MuaButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double leftRadius = 14; 
    const double rightRadius = 3; 
    const double cutWidth = 6; 

    path.moveTo(0, leftRadius);
    path.quadraticBezierTo(0, 0, leftRadius, 0);

    path.lineTo(size.width - rightRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, rightRadius);

    path.lineTo(size.width - cutWidth, size.height  - rightRadius);

    path.quadraticBezierTo(
      size.width - cutWidth - rightRadius,
      size.height ,
      size.width - cutWidth - 2 * rightRadius,
      size.height ,
    );

    path.lineTo(leftRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - leftRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
