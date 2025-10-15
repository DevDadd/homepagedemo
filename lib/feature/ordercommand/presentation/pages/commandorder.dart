import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/dottedlinepainter.dart';
import 'package:marquee/marquee.dart';

class Commandorder extends StatefulWidget {
  const Commandorder({super.key});

  @override
  State<Commandorder> createState() => _CommandorderState();
}

class _CommandorderState extends State<Commandorder>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                        insets: EdgeInsetsGeometry.symmetric(horizontal: 3),
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
                          SizedBox(width: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color(0xFF6F767E).withOpacity(0.3),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "HOSE",
                                style: GoogleFonts.manrope(
                                  color: Color(0xFF6F767E),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "100.90",
                            style: GoogleFonts.manrope(
                              color: Color(0xFFA43EE7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "94.30",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xFFFF9F41),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "87.70",
                            style: GoogleFonts.manrope(
                              color: Color(0xFF3FC2EB),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset("assets/icons/button2.svg"),
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
