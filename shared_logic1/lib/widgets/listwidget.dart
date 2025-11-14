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
  static const List<String> highlightTitles = [
    "Tài sản",
    "Chỉ số thị trường",
    "Nhóm cổ phiếu",
  ];
  static const List<String> highlightTitles2 = [
    "Tài sản",
    "Chỉ số thị trường",
    "Nhóm cổ phiếu",
    "Danh sách sở hữu",
    "Tin tức",
  ];
  static const List<String> highlightTitles3 = [
    "Tài sản",
    "Chỉ số thị trường",
    "Nhóm cổ phiếu",
    "Danh sách sở hữu",
    "Tin tức",
    "Bản đồ nhiệt",
    "Hiệu quả đầu tư",
  ];

  @override
  Widget build(BuildContext context) {
    bool shouldHighlight = false;
    if (widget.selectedIndex == 0) {
      shouldHighlight = highlightTitles.contains(widget.title);
    } else if (widget.selectedIndex == 1) {
      shouldHighlight = highlightTitles2.contains(widget.title);
    } else if (widget.selectedIndex == 2) {
      shouldHighlight = highlightTitles3.contains(widget.title);
    }

    if (widget.isSelected) {
      shouldHighlight = true;
    }

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
