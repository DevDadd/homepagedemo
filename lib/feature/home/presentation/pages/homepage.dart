import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:homepageintern/feature/home/presentation/widgets/homepagesliverheader.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  bool _showNav = true;
  late ScrollController _scrollController;

  double _bgScale = 1.0;

  static const double _maxOverscrollDistance = 150.0;
  static const double _maxScaleMultiplier = 0.2;
  static const double _maxScale = 1.0 + _maxScaleMultiplier;

  final List<FeatureItem> items = [
    FeatureItem(
      colors: const Color(0xFFEEAD70).withOpacity(0.3),
      imageURL: "assets/icons/coin.svg",
      lable: "Nộp tiền",
    ),
    FeatureItem(
      colors: const Color(0xFFFF79F4).withOpacity(0.3),
      imageURL: "assets/icons/cs.svg",
      lable: "Chuyên viên",
    ),
    FeatureItem(
      colors: const Color(0xFFFFC24D).withOpacity(0.3),
      imageURL: "assets/icons/money.svg",
      lable: "EzSaving",
    ),
    FeatureItem(
      colors: const Color(0xFF8270EE).withOpacity(0.3),
      imageURL: "assets/icons/analyst.svg",
      lable: "Phân tích",
    ),
    FeatureItem(
      colors: const Color(0xFF4CAF50).withOpacity(0.3),
      imageURL: "assets/icons/wallet.svg",
      lable: "Ví điện tử",
    ),
    FeatureItem(
      colors: const Color(0xFF2196F3).withOpacity(0.3),
      imageURL: "assets/icons/chart.svg",
      lable: "Báo cáo",
    ),
    FeatureItem(
      colors: const Color(0xFF9C27B0).withOpacity(0.3),
      imageURL: "assets/icons/function.svg",
      lable: "Cài đặt",
    ),
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

    if (_scrollController.position.pixels < 0) {
      double overscroll = _scrollController.position.pixels.abs();
      double normalizedOverscroll = (overscroll / _maxOverscrollDistance).clamp(
        0.0,
        1.0,
      );
      double scale =
          1.0 +
          (normalizedOverscroll * normalizedOverscroll * _maxScaleMultiplier);
      setState(() => _bgScale = scale.clamp(1.0, _maxScale));
    } else {
      if (_bgScale != 1.0) {
        setState(() => _bgScale = 1.0);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double pinnedHeaderHeight =
        MediaQuery.of(context).padding.top + kToolbarHeight + 145;

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Stack(
        children: [
          extended.ExtendedNestedScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            floatHeaderSlivers: true,
            pinnedHeaderSliverHeightBuilder: () => pinnedHeaderHeight,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: Homepagesliverheader(
                  minHeight: kToolbarHeight + 190,
                  maxHeight: 390,
                  name: "Quyet Trinh",
                  clientId: "0C93123131",
                  message: "Chúc mừng năm mới",
                  avatarURL: "assets/images/ava.jpeg.webp",
                  icons: items,
                  backgroundScale: _bgScale,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFCFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFCFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            body: const SizedBox.shrink(),
          ),
        ],
      ),

      /// Bottom nav
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
          selectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
          ),
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
