import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic1/secondpage.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Startpage extends StatelessWidget {
  final VoidCallback? onNavigateToHome;

  const Startpage({super.key, this.onNavigateToHome});

  @override
  Widget build(BuildContext context) {
    final onNavigateToHome = this.onNavigateToHome;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 150.h),
          SimpleShadow(
            child: Center(
              child: SvgPicture.asset(
                "packages/shared_logic1/assets/star.svg",
                width: 142.59.w,
                height: 136.28.h,
              ),
            ),
          ),
          SizedBox(height: 45.87.h),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "Cá nhân hoá",
              style: GoogleFonts.manrope(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Color(0xFF424242),
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "Nhằm mang lại trải nghiệm tốt nhất cho bạn",
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6F767E),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 37.5,
              left: 36,
              right: 27.25,
            ),
            child: Row(
              children: [
                Text(
                  "Bỏ qua",
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6F767E),
                  ),
                ),
                SizedBox(width: 173),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Secondpage(onNavigateToHome: onNavigateToHome),
                      ),
                    );
                  },
                  child: Text(
                    "Tiếp theo",
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1AAF74),
                    ),
                  ),
                ),
                SizedBox(width: 11.25),
                SvgPicture.asset("assets/icons/greenarr.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
