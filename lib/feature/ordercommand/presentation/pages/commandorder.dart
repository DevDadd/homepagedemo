import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
        toolbarHeight: 44, // 👈 chỉnh độ cao AppBar ở đây
        backgroundColor: const Color(0xFF111315),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 👇 TabBar bám sát lề trái
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(-60, 0), // điều chỉnh sát hơn nữa
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
              SizedBox(width: 3.12),
              Text(
                "Thoả thuận",
                style: GoogleFonts.manrope(
                  color: Color(0xFF1AAF74),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          SvgPicture.asset("assets/icons/idk.svg"),
          SizedBox(width: 12),
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
          children:  [
            Column(children: [
              Container(
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.83),
                      child: SvgPicture.asset("assets/icons/magnifying.svg",width: 16,height: 16,color:Color(0xFF6F767E),),
                    ),
                    SizedBox(width: 4.83,),
                    Text("FPT",style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16, decoration: TextDecoration.underline,decorationColor: Colors.white))
                  ],
                ),
              ),
            ]),
            Center(
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
