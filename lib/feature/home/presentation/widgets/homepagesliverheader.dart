import 'dart:ui';
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    final double nameFontSize = lerp(32, 20, progress);
    final double avatarSize = lerp(0, 44, progress);
    final double overallYOffset = -15 * progress + 110 * (1 - progress);
    final double textsYOffset = -20 * progress;
    final double avatarYOffset = -2 * progress;
    final int pageCount = (icons.length / 4).ceil();

    double backgroundOffset = -shrinkOffset * 0.5;
    if (backgroundOffset < -(maxExtent - minExtent)) {
      backgroundOffset = -(maxExtent - minExtent);
    }

    final double messageOpacity = (1.0 - progress * 1.8).clamp(0.0, 1.0);
    final double messageYOffset = progress * 55;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        // ================= BACKGROUND =================
        Transform.translate(
          offset: Offset(0, backgroundOffset),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 1.0,
              end: backgroundScale > 1.0 ? backgroundScale : 1.0,
            ),
            duration: Duration(milliseconds: backgroundScale > 1.0 ? 200 : 600),
            curve: backgroundScale > 1.0 ? Curves.easeOut : Curves.elasticOut,
            builder: (context, tweenScale, child) {
              final double dynamicScale =
                  1.0 + (shrinkOffset < 0 ? (-shrinkOffset / 250) : 0);

              return Transform.scale(
                scale: tweenScale * dynamicScale,
                alignment: Alignment.topCenter,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: const Color(0xFFF4F4F4)),
                    Positioned.fill(
                      child: Lottie.asset(
                        "assets/images/yellow_autumn.json",
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // ================= GRADIENT Ở ĐÁY HEADER =================
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: -shrinkOffset *
        //       0.2, // giúp gradient di chuyển mượt cùng header khi scroll
        //   height: 40,
        //   child: IgnorePointer(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors: [
        //             Theme.of(context)
        //                 .blurAnimationHome
        //                 .withValues(alpha: 0.95),
        //             Theme.of(context)
        //                 .blurAnimationHome
        //                 .withValues(alpha: 0.7),
        //             Theme.of(context)
        //                 .blurAnimationHome
        //                 .withValues(alpha: 0.3),
        //             Theme.of(context)
        //                 .blurAnimationHome
        //                 .withValues(alpha: 0),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        // ================= TOP ICONS =================
        Positioned(
          top: MediaQuery.of(context).padding.top + 3,
          right: 8,
          child: Row(
            children: [
              _buildTopIcon("assets/icons/magnifying.svg"),
              const SizedBox(width: 16),
              _buildTopIcon("assets/icons/bell.svg"),
            ],
          ),
        ),

        // ================= FOREGROUND CONTENT =================
        Container(
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
                // AVATAR + NAME + MESSAGE
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
                            image: avatarSize > 0
                                ? DecorationImage(
                                    image: AssetImage(avatarURL),
                                    fit: BoxFit.cover,
                                  )
                                : null,
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
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Opacity(
                                    opacity: messageOpacity,
                                    child: Transform.translate(
                                      offset: Offset(0, messageYOffset),
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
                                  if (progress > 0.33)
                                    Builder(
                                      builder: (context) {
                                        final double localT =
                                            ((progress - 0.39) / 0.67).clamp(
                                              0.0,
                                              1.0,
                                            );
                                        final double easedT = Curves.easeInOut
                                            .transform(localT);
                                        final double idOpacity = easedT;
                                        final double idYOffsetStart =
                                            messageYOffset;
                                        final double idYOffsetEnd =
                                            messageYOffset - 5;
                                        final double idYOffset = lerpDouble(
                                          idYOffsetStart,
                                          idYOffsetEnd,
                                          easedT,
                                        )!;

                                        return Transform.translate(
                                          offset: Offset(0, idYOffset),
                                          child: Opacity(
                                            opacity: idOpacity,
                                            child: Text(
                                              clientId,
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF424242),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Transform.translate(
                                offset: Offset(0, -5 * progress),
                                child: Row(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // FEATURE LIST
                Transform.translate(
                  offset: Offset(
                    0,
                    95 * (1 - progress) +
                        40 -
                        40 * progress -
                        25 +
                        30 * progress,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 85,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pageCount,
                          itemBuilder: (context, pageIndex) {
                            final start = pageIndex * 4;
                            final end = (start + 4 < icons.length)
                                ? start + 4
                                : icons.length;
                            final items = icons.sublist(start, end);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(items.length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 17,
                                  ),
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
                            activeDotColor: const Color(0xFF1AAF74),
                            dotColor: Colors.grey.shade400,
                            dotHeight: 2,
                            dotWidth: 6,
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
