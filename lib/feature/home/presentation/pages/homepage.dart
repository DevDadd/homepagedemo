import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:homepageintern/feature/home/presentation/widgets/homepagesliverheader.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:sliver_tools/sliver_tools.dart';

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
  double _overscrollOffset = 0.0;

  static const double _maxOverscrollDistance = 150.0;
  static const double _maxScaleMultiplier = 0.2;
  static const double _maxScale = 1.0 + _maxScaleMultiplier;

  final double _minHeader = 310;
  final double _maxHeader = 380;

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
      setState(() {
        _bgScale = scale.clamp(1.0, _maxScale);
        _overscrollOffset = overscroll / 2;
      });
    } else {
      if (_bgScale != 1.0 || _overscrollOffset != 0) {
        setState(() {
          _bgScale = 1.0;
          _overscrollOffset = 0;
        });
      }
    }
  }

  void _handleSnap() {
    if (!_scrollController.hasClients) return;

    final double collapseOffset = _maxHeader - _minHeader;
    final double current = _scrollController.offset;
    final double snapThreshold = collapseOffset / 2;

    if (current < 0 || current > collapseOffset) return;

    double targetOffset;
    if (current <= snapThreshold) {
      targetOffset = 0;
    } else {
      targetOffset = collapseOffset;
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            _handleSnap();
          }
          return false;
        },
        child: extended.ExtendedNestedScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          floatHeaderSlivers: true,
          pinnedHeaderSliverHeightBuilder: () => 0,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverStack(
                insetOnOverlap: false,
                children: <Widget>[
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, _overscrollOffset),
                      child: Container(
                        height: 170.h,
                        margin: const EdgeInsets.only(top: 390),
                        decoration: BoxDecoration(
                          color: const Color(0XFFFCFCFC),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDCE8ED).withOpacity(0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _buildMoneyCard(),
                        ),
                      ),
                    ),
                  ),

                  // 🟦 Header nằm trên cùng của Stack
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: Homepagesliverheader(
                      minHeight: _minHeader,
                      maxHeight: _maxHeader,
                      name: "Trinh Van Quyet",
                      clientId: "0C93123131",
                      message: "Chúc mừng năm mới",
                      avatarURL: "assets/images/ava.jpeg.webp",
                      icons: items,
                      backgroundScale: _bgScale,
                    ),
                  ),
                ],
              ),
            ];
          },
          body: const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showNav ? Offset.zero : const Offset(0, 1),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.white,
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

  Widget _buildMoneyCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 3),
          child: Row(
            children: [
              Text(
                "Tiền và CK của tôi",
                style: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6F767E),
                ),
              ),
              const Spacer(),
              SvgPicture.asset("assets/icons/eye.svg"),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "5.000.000.000",
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "+1,200,000",
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: const Color(0xFF1AAF74),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 137.34,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF51D6A1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),
            Container(width: 29.43, height: 8, color: Color(0xFFC682F3)),
            Container(width: 52.32, height: 8, color: Color(0xFF5DC6D2)),
            Expanded(
              child: Container(
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB56C),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendDot(const Color(0xFF51D6A1), "Cơ Sở 24%"),
            const SizedBox(width: 12),
            _legendDot(const Color(0xFFC682F3), "Phái sinh 17%"),
            const SizedBox(width: 12),
            _legendDot(const Color(0xFFFFB56C), "GD trong ngày 68%"),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6F767E),
          ),
        ),
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
