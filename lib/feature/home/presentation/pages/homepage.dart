import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/core/extensions/color_extension.dart';
import 'package:homepageintern/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:homepageintern/feature/home/presentation/widgets/homepagesliverheader.dart';
import 'package:homepageintern/feature/ordercommand/presentation/pages/commandorder.dart';
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

  final double _minHeader = 270;
  final double _maxHeader = 410;

  final List<FeatureItem> items = [
    FeatureItem(
      colors: const Color(0xFFEEAD70).withOpacity(0.3),
      imageURL: "assets/icons/coin.svg",
      label: "Nộp tiền",
    ),
    FeatureItem(
      colors: const Color(0xFFFF79F4).withOpacity(0.3),
      imageURL: "assets/icons/cs.svg",
      label: "Chuyên viên",
    ),
    FeatureItem(
      colors: const Color(0xFFFFC24D).withOpacity(0.3),
      imageURL: "assets/icons/money.svg",
      label: "EzSaving",
    ),
    FeatureItem(
      colors: const Color(0xFF8270EE).withOpacity(0.3),
      imageURL: "assets/icons/analyst.svg",
      label: "Phân tích",
    ),
    FeatureItem(
      colors: const Color(0xFF4CAF50).withOpacity(0.3),
      imageURL: "assets/icons/wallet.svg",
      label: "Ví điện tử",
    ),
    FeatureItem(
      colors: const Color(0xFF2196F3).withOpacity(0.3),
      imageURL: "assets/icons/chart.svg",
      label: "Báo cáo",
    ),
    FeatureItem(
      colors: const Color(0xFF9C27B0).withOpacity(0.3),
      imageURL: "assets/icons/function.svg",
      label: "Cài đặt",
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
        _overscrollOffset = overscroll / 20; // <-- Chậm hơn cực kỳ
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

              SliverClip(
                child: SliverStack(
                  insetOnOverlap: true,
                  children: [
                    SliverToBoxAdapter(
                      child: Transform.translate(
                        offset: Offset(0, _overscrollOffset),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: _buildMoneyCard(),
                        ),
                      ),
                    ),

                    SliverPositioned.fill(
                      top: 0,
                      bottom: 0,
                      child: Stack(
                        children: [
                          Container(
                            height: 32.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(
                                    context,
                                  ).blurAnimationHome.withValues(alpha: 1),
                                  Theme.of(
                                    context,
                                  ).blurAnimationHome.withValues(alpha: 0),
                                ],
                                stops: const [0.0024, .96],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // Navigate to Commandorder
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Commandorder()),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
        backgroundColor: Colors.white,
        showNav: _showNav,
      ),
    );
  }

  /// Money Card giữ nguyên logic
  Widget _buildMoneyCard() {
    return Container(
      height: 170.h,
      width: 351.w,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0XFFFCFCFC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDCE8ED).withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + icon
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

          /// Total money
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "5.000.000.000",
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          /// Profit
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

          /// Bar chart
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
              Container(
                width: 29.43,
                height: 8,
                color: const Color(0xFFC682F3),
              ),
              Container(
                width: 52.32,
                height: 8,
                color: const Color(0xFF5DC6D2),
              ),
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

          /// Legend
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
      ),
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
}
