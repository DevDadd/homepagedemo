import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Fifthpage extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const Fifthpage({super.key, this.onNavigateToHome});

  @override
  State<Fifthpage> createState() => _FifthpageState();
}

class _FifthpageState extends State<Fifthpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 130.h),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Center(child: Image.asset("assets/icons/loz.png")),
          ),
          SizedBox(height: 95.h),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Text(
              "Hoàn tất",
              style: GoogleFonts.manrope(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1D1F),
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Text(
              "Bạn có thể sắp xếp & thay đổi nội dung hiển thị trên trang chủ trong mục “Cài đặt”",
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6F767E),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/greencir.svg"),

                SizedBox(width: 10.w),
                Text(
                  "Cá nhân hoá",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1D1F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/greencir.svg"),
                SizedBox(width: 10.w),
                Text(
                  "Mức độ hiểu biết",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1D1F),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Row(
              children: [
                SvgPicture.asset("assets/icons/greencir.svg"),

                SizedBox(width: 10.w),
                Text(
                  "Đề xuất dành cho bạn",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1D1F),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 42),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(160.w, 48.h),
                  backgroundColor: Color(0xFF1AAF74),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (widget.onNavigateToHome != null) {
                    widget.onNavigateToHome!();
                  } else {
                    // Fallback: pop về root
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: Text(
                  "Đến trang chủ",
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
