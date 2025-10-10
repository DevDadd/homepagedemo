import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    super.key,
    required this.colors,
    required this.imageURL,
    required this.label,
    this.width = 55,
    this.height = 28,
    this.iconSize = 24,
    this.fontSize = 12,
    this.iconBoxSize = 48,
  });

  final Color colors;
  final String imageURL;
  final String label;
  final double width;
  final double height;
  final double iconSize;
  final double fontSize;
  final double iconBoxSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: iconBoxSize,
              width: iconBoxSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            Center(
              child: SvgPicture.asset(
                imageURL,
                width: iconSize + 8,
                height: iconSize + 8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: width,
          height: height,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
