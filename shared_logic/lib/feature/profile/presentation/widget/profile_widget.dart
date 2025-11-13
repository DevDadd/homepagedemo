import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key, required this.title, required this.value , this.showDivider = true});
  String title;
  String value;
  bool showDivider;
  @override
  Widget build(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 12,
            color: Color(0xFFFCFCFC),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: Color(0xFFFCFCFC),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (showDivider)
          const Divider(color: Colors.grey, thickness: 0.5, height: 16),
      ],
    );
  }
}