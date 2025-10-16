import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/buybuttonclipper.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/dottedlinepainter.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/sellbuttonclipper.dart';
import 'package:marquee/marquee.dart';

class Commandorder extends StatefulWidget {
  const Commandorder({super.key});

  @override
  State<Commandorder> createState() => _CommandorderState();
}

class _CommandorderState extends State<Commandorder>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabController1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController1 = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111315),
      appBar: AppBar(
        toolbarHeight: 44,
        backgroundColor: const Color(0xFF111315),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(-60, 0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      dividerColor: Colors.transparent,
                      labelPadding: const EdgeInsets.only(right: 10),
                      indicator: UnderlineTabIndicator(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 3),
                      ),
                      labelStyle: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                      unselectedLabelStyle: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                      tabs: const [
                        Tab(text: "Cơ Sở"),
                        Tab(text: "Phái sinh"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              SvgPicture.asset("assets/icons/clock.svg"),
              const SizedBox(width: 3.12),
              Text(
                "Thoả thuận",
                style: GoogleFonts.manrope(
                  color: const Color(0xFF1AAF74),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          SvgPicture.asset("assets/icons/idk.svg"),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.83),
                            child: SvgPicture.asset(
                              "assets/icons/magnifying.svg",
                              width: 16,
                              height: 16,
                              color: const Color(0xFF6F767E),
                            ),
                          ),
                          const SizedBox(width: 4.83),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Text(
                                "FPT",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, 13),
                                child: Container(
                                  width: 28,
                                  height: 1.5,
                                  color: const Color(0xFF6F767E),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            "94.20",
                            style: GoogleFonts.manrope(
                              color: const Color(0xFFF34859),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "-0.10",
                            style: GoogleFonts.manrope(
                              color: const Color(0xFFF34859),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "(0.11%)",
                            style: GoogleFonts.manrope(
                              color: const Color(0xFFF34859),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset("assets/icons/button1.svg"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 20,
                                child: Marquee(
                                  text: "Công ty cổ phần FPT",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: const Color(0xFF6F767E),
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  blankSpace: 10.0,
                                  velocity: 40.0,
                                  startPadding: 0.0,
                                  accelerationDuration: const Duration(
                                    seconds: 1,
                                  ),
                                  accelerationCurve: Curves.linear,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: CustomPaint(
                                  size: const Size(double.infinity, 1),
                                  painter: DottedLinePainter(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xFF6F767E).withOpacity(0.3),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "HOSE",
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF6F767E),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "100.90",
                            style: GoogleFonts.manrope(
                              color: const Color(0xFFA43EE7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "94.30",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: const Color(0xFFFF9F41),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "87.70",
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF3FC2EB),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset("assets/icons/button2.svg"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 21),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController1,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding: EdgeInsets.symmetric(horizontal: 20),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        indicatorColor: Colors.white,
                        dividerColor: Colors.transparent,
                        labelStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB8B3B3),
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6F767E),
                          fontSize: 12,
                        ),
                        indicator: UnderlineTabIndicator(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 3,
                            color: Color(0xFF1AAF74),
                          ),
                          insets: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        tabs: const [
                          Tab(text: "Giá"),
                          Tab(text: "Biểu đồ"),
                          Tab(text: "Khớp lệnh"),
                          Tab(text: "Thanh khoản"),
                        ],
                      ),
                      AutoScaleTabBarView(
                        controller: _tabController1,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 19,
                              right: 12,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "KL",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Color(0xFF6F767E),
                                          ),
                                        ),
                                        SizedBox(width: 103.5),
                                        Text(
                                          "Giá mua",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Color(0xFF6F767E),
                                          ),
                                        ),
                                        SizedBox(width: 24),
                                        Text(
                                          "Giá bán",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Color(0xFF6F767E),
                                          ),
                                        ),
                                        SizedBox(width: 107.5),
                                        Text(
                                          "KL",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: Color(0xFF6F767E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "20,000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                          SizedBox(width: 85.5),
                                          Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: 18),
                                                  Container(
                                                    width: 33,
                                                    height: 21,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  4,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  4,
                                                                ),
                                                          ),
                                                      color: Color(
                                                        0xFF1AAF74,
                                                      ).withOpacity(0.3),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "94.20",
                                                  style: GoogleFonts.manrope(
                                                    color: Color(0xFFF34859),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 33,
                                                      height: 21,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        color: Color(
                                                          0xFFF34859,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                ),
                                                child: Text(
                                                  "94.30",
                                                  style: GoogleFonts.manrope(
                                                    color: Color(0xFFFF9F41),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            "10.000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "30,000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                          SizedBox(width: 51.w),
                                          Stack(
                                            children: [
                                              Container(
                                                height: 21.h,
                                                width: 79.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4),
                                                        bottomLeft:
                                                            Radius.circular(4),
                                                      ),
                                                  color: Color(
                                                    0xFF1AAF74,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 34,
                                                ),
                                                child: Text(
                                                  "94.10",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                height: 21.h,
                                                width: 79.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(4),
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      ),
                                                  color: Color(
                                                    0xFFF34859,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                ),
                                                child: Text(
                                                  "94.40",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            "15,000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            "50,000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                          SizedBox(width: 27),
                                          Stack(
                                            children: [
                                              Container(
                                                height: 21,
                                                width: 109,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4),
                                                        bottomLeft:
                                                            Radius.circular(4),
                                                      ),
                                                  color: Color(
                                                    0xFF1AAF74,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 56,
                                                ),
                                                child: Text(
                                                  "94.00",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                height: 21,
                                                width: 101,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(4),
                                                        bottomRight:
                                                            Radius.circular(4),
                                                      ),
                                                  color: Color(
                                                    0xFFF34859,
                                                  ).withOpacity(0.3),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 14,
                                                ),
                                                child: Text(
                                                  "94.50",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            "20,000",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 19,
                              ),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Lịch sử",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Khác",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  height: 200,
                  width: 375,
                  decoration: BoxDecoration(
                    color: Color(0xFF2F3437),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: -16,
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12, top: 12),
                              child: ClipPath(
                                clipper: MuaButtonClipper(),
                                child: Container(
                                  width: 84.75,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1AAF74).withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Mua",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Color(0xFF1AAF74),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ClipPath(
                              clipper: SellButtonFlippedClipper(),
                              child: Container(
                                width: 84.75,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3A4247),
                                ),
                                child: Center(
                                  child: Text(
                                    "Bán",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Color(0xFFC4C4C4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Center(
              child: Text(
                "Nội dung Phái sinh",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
