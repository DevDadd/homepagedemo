import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Checkbox12 extends StatelessWidget {
  String title;
  bool isSelected;
  Checkbox12({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      height: 67.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color(0xFF1AAF74) : Color(0xFF1A1D1F),
          width: 1,
        ),
        color: Color(0xFF1A1D1F),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: isSelected
                  ? SvgPicture.asset("assets/icons/pressed.svg")
                  : SvgPicture.asset("assets/icons/checkbut.svg"),
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? Color(0xFF1AAF74) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
