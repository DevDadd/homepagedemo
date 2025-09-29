import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Listview extends StatelessWidget {
  const Listview({
    super.key,
    required this.colors,
    required this.imageURL,
    required this.lable,
  });

  final Color colors;
  final String imageURL;
  final String lable;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
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
            Center(child: SvgPicture.asset(imageURL)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 55,
          child: Text(
            lable,
            style: GoogleFonts.manrope(
              fontSize: 12,
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
