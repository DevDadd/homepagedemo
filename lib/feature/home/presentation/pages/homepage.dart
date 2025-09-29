import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:homepageintern/feature/home/presentation/widgets/homepagesliverheader.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  bool _showNav = true;
  late ScrollController _scrollController;

  final List<Listview> items = [
    Listview(
        colors: const Color(0xFFEEAD70).withOpacity(0.3),
        imageURL: "assets/icons/coin.svg",
        lable: "Nộp tiền"),
    Listview(
        colors: const Color(0xFFFF79F4).withOpacity(0.3),
        imageURL: "assets/icons/cs.svg",
        lable: "Chuyên viên\nTVDT"),
    Listview(
        colors: const Color(0xFFFFC24D).withOpacity(0.3),
        imageURL: "assets/icons/money.svg",
        lable: "EzSaving"),
    Listview(
        colors: const Color(0xFF8270EE).withOpacity(0.3),
        imageURL: "assets/icons/analyst.svg",
        lable: "Phân tích"),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showNav) setState(() => _showNav = false);
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showNav) setState(() => _showNav = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Lottie.asset(
              "assets/images/background.json",
              fit: BoxFit.cover,
            ),
          ),

          // ExtendedNestedScrollView với ScrollController
          SafeArea(
            child: extended.ExtendedNestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverToBoxAdapter(child: SizedBox(height: 70)),

                // Header
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: Homepagesliverheader(
                    minHeight: kToolbarHeight + 30,
                    maxHeight: 250,
                    name: "Quyet Trinh",
                    clientId: "0C93123131",
                    message: "Chúc mừng năm mới",
                    icons: items,
                  ),
                ),
              ],
              body: Builder(
                builder: (context) {
                  return ListView(
                    padding: const EdgeInsets.only(top: 200), // container xuyên header
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Container(
                        height: 500,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Top icons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildTopIcon("assets/icons/magnifying.svg"),
                  const SizedBox(width: 16),
                  _buildTopIcon("assets/icons/bell.svg"),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showNav ? Offset.zero : const Offset(0, 1),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFFF4F4F4).withOpacity(0.3),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1AAF74),
          unselectedItemColor: const Color(0xFF6F767E),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle:
              GoogleFonts.manrope(fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              GoogleFonts.manrope(fontWeight: FontWeight.w500),
          items: [
            _buildBottomNavItem("Trang chủ", "assets/icons/house.svg"),
            _buildBottomNavItem("Danh mục", "assets/icons/chart.svg"),
            _buildBottomNavItem("Đặt lệnh", "assets/icons/hammer.svg"),
            _buildBottomNavItem("Số dư GD", "assets/icons/wallet.svg"),
            _buildBottomNavItem("Chức năng", "assets/icons/function.svg"),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon(String asset) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF82828266),
          ),
        ),
        SvgPicture.asset(asset),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(String label, String iconPath) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(iconPath, color: const Color(0xFFAFB3BE)),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath, color: const Color(0xFF1AAF74)),
          const SizedBox(height: 6),
          SvgPicture.asset("assets/icons/line.svg"),
        ],
      ),
    );
  }
}
