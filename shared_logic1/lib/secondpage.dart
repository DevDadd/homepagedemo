import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic1/thirdpage.dart';
import 'package:shared_logic1/widgets/checkbox.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Secondpage extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const Secondpage({super.key, this.onNavigateToHome});

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111315),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 130.h),
          Center(
            child: SimpleShadow(
              child: SvgPicture.asset("assets/icons/chart2.svg"),
            ),
          ),
          SizedBox(height: 29.h),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "Mức độ hiểu biết",
              style: GoogleFonts.manrope(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "Hãy chia sẻ mức độ hiểu biết của bạn về chứng khoán",
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6F767E),
              ),
            ),
          ),
          SizedBox(height: 24.5),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Checkbox12(
                title: "Mới tìm hiểu",
                isSelected: selectedIndex == 0,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Checkbox12(
                title: "Đã có kinh nghiệm",
                isSelected: selectedIndex == 1,
              ),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
              child: Checkbox12(
                title: "Chuyên gia",
                isSelected: selectedIndex == 2,
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
                        builder: (context) => Thirdpage(
                          selectedIndex: selectedIndex,
                          onNavigateToHome: widget.onNavigateToHome,
                        ),
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
