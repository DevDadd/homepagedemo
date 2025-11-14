import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Listwidget extends StatefulWidget {
  final String title;
  final int selectedIndex;
  final int itemIndex;
  final bool isSelected;
  final VoidCallback? onTap;

  Listwidget({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.itemIndex,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<Listwidget> createState() => _ListwidgetState();
}

class _ListwidgetState extends State<Listwidget> {
  @override
  Widget build(BuildContext context) {
    // Chỉ highlight khi isSelected = true
    // Logic highlight dựa trên selectedIndex đã được xử lý ở parent component
    bool shouldHighlight = widget.isSelected;

    final Color backgroundColor = shouldHighlight
        ? Color(0xFF1AAF74)
        : Color(0xFF1A1D1F);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 351.w,
        height: 48.h,
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Color(0xFF1A1D1F),
          border: Border.all(color: backgroundColor, width: 1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                SizedBox(width: 10.w),
                SvgPicture.asset("assets/icons/three.svg"),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1AAF74),
                    ),
                  ),
                ),
                shouldHighlight
                    ? SvgPicture.asset("assets/icons/greencir.svg")
                    : SizedBox(width: 24.w, height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
