import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic1/fifthpage.dart';

class Fourthpage extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const Fourthpage({super.key, this.onNavigateToHome});

  @override
  State<Fourthpage> createState() => _FourthpageState();
}

class _FourthpageState extends State<Fourthpage> {
  int index = -1;
  Timer? _timer;
  String title = "Đang xử lý";
  String description =
      "Bạn có thể sắp xếp & thay đổi nội dung hiển thị trên trang chủ trong mục “Cài đặt”";
  bool isDone = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        index++;
        if (index >= 2) {
          timer.cancel();
          setState(() {
            isDone = true;
            title = "Hoàn tất";
            description =
                "Bạn có thể sắp xếp & thay đổi nội dung hiển thị trên trang chủ trong mục “Cài đặt”";
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
              title,
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
              description,
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
                index >= 0
                    ? SvgPicture.asset("assets/icons/greencir.svg")
                    : SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1AAF74),
                        ),
                      ),
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
                index >= 1
                    ? SvgPicture.asset("assets/icons/greencir.svg")
                    : SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1AAF74),
                        ),
                      ),
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
                index >= 2
                    ? SvgPicture.asset("assets/icons/greencir.svg")
                    : SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: Color(0xFF1AAF74),
                        ),
                      ),
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

          isDone
              ? Padding(
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
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
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
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
