import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:homepageintern/core/extensions/color_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Homepagesliverheader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final String name;
  final String clientId;
  final String message;
  final String avatarURL;
  final List<FeatureItem> icons;
  final double backgroundScale;

  final PageController _pageController = PageController();

  Homepagesliverheader({
    required this.minHeight,
    required this.maxHeight,
    required this.name,
    required this.clientId,
    required this.message,
    required this.icons,
    required this.avatarURL,
    this.backgroundScale = 1.0,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  double lerp(double min, double max, double t) => min + (max - min) * t;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final double nameFontSize = 32 - (12 * progress);
    final double avatarSize = 44 * progress;
    final double overallYOffset = -15 * progress + 110 * (1 - progress);
    final double textsYOffset = -15 * progress;
    final double avatarYOffset = -2 * progress;
    final int pageCount = (icons.length / 4).ceil();

    double backgroundOffset = -shrinkOffset;
    if (backgroundOffset < -(maxExtent - minExtent)) {
      backgroundOffset = -(maxExtent - minExtent);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Lottie
        Transform.translate(
          offset: Offset(0, backgroundOffset),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: backgroundScale),
            duration: Duration(milliseconds: backgroundScale > 1.0 ? 200 : 400),
            curve: backgroundScale > 1.0 ? Curves.easeOut : Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: Lottie.asset(
                  "assets/images/background.json",
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),

        // Top right icons
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: Row(
            children: [
              _buildTopIcon("assets/icons/magnifying.svg"),
              const SizedBox(width: 16),
              _buildTopIcon("assets/icons/bell.svg"),
            ],
          ),
        ),

        // Nội dung header
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 16,
          ),
          child: Transform.translate(
            offset: Offset(0, (backgroundScale - 1) * 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, overallYOffset),
                  child: Row(
                    children: [
                      Transform.translate(
                        offset: Offset(0, avatarYOffset),
                        child: Container(
                          height: avatarSize,
                          width: avatarSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(avatarURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, textsYOffset),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Stack message và clientId
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Message fade out + đi xuống nhanh hơn
                                  Transform.translate(
                                    offset: Offset(0, progress * 20), // di chuyển xuống
                                    child: Opacity(
                                      opacity: (1.0 - progress * 2).clamp(0.0, 1.0), // fade nhanh
                                      child: Text(
                                        message,
                                        style: GoogleFonts.manrope(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF424242),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // ClientId xuất hiện khi message đã biến mất
                                  if ((1.0 - progress * 2).clamp(0.0, 1.0) <= 0.0)
                                    Positioned(
                                      top: 20, // vị trí trực tiếp dưới tên
                                      child: Text(
                                        clientId,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF424242),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.manrope(
                                      fontSize: nameFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF424242),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SvgPicture.asset(
                                    "assets/icons/arrow.svg",
                                    width: 4,
                                    height: 8,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Feature list / PageView
                Transform.translate(
                  offset: Offset(0, 95 * (1 - progress) + 40 - 40 * progress - 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 85,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pageCount,
                          itemBuilder: (context, pageIndex) {
                            final start = pageIndex * 4;
                            final end = (start + 4 < icons.length) ? start + 4 : icons.length;
                            final items = icons.sublist(start, end);

                            return Row(
                              children: List.generate(items.length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 17),
                                  child: items[i],
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (icons.isNotEmpty)
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: pageCount,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.white,
                            dotColor: Colors.grey.shade400,
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 6,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom gradient overlay
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).blurAnimationHome.withValues(alpha: 0),
                  Theme.of(context).blurAnimationHome.withValues(alpha: 1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant Homepagesliverheader oldDelegate) {
    return name != oldDelegate.name ||
        clientId != oldDelegate.clientId ||
        message != oldDelegate.message ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        icons != oldDelegate.icons ||
        avatarURL != oldDelegate.avatarURL ||
        backgroundScale != oldDelegate.backgroundScale;
  }

  Widget _buildTopIcon(String asset) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF828282).withOpacity(0.3),
      ),
      child: Center(child: SvgPicture.asset(asset)),
    );
  }
}
