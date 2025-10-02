import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';
import 'package:lottie/lottie.dart';
import 'package:homepageintern/core/extensions/color_extension.dart';

class Homepagesliverheader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final String name;
  final String clientId;
  final String message;
  final String avatarURL;
  final List<FeatureItem> icons;
  final double backgroundScale;

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

    final double nameFontSize = 32 - (12 * progress);
    final double messageFontSize = 16 * (1 - progress);
    final double avatarSize = 44 * progress;
    final double idFontSize = lerp(0, 14, progress);
    final double idYOffset = lerp(-20, 25, progress);
    final double overallYOffset = -15 * progress + 110 * (1 - progress);
    final double textsYOffset = -10 * progress;
    final double avatarYOffset = 3 * progress;

    return Stack(
      children: [
        /// Background
        Positioned.fill(
          child: ClipRect(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: backgroundScale),
              duration: Duration(
                milliseconds: backgroundScale > 1.0 ? 200 : 400,
              ),
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
        ),

        /// Top right icons
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTopIcon("assets/icons/magnifying.svg"),
              const SizedBox(width: 16),
              _buildTopIcon("assets/icons/bell.svg"),
            ],
          ),
        ),

        /// Content (avatar + texts + feature list)
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            bottom: 16,
          ),
          child: Transform.translate(
            offset: Offset(
              0,
              (backgroundScale - 1) * 400, // chữ + list kéo xuống
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, overallYOffset),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              if (messageFontSize > 0)
                                Text(
                                  message,
                                  style: GoogleFonts.manrope(
                                    fontSize: messageFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF424242),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
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
                                  Positioned(
                                    top: idYOffset,
                                    child: Text(
                                      clientId,
                                      style: GoogleFonts.manrope(
                                        fontSize: idFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF424242),
                                      ),
                                    ),
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

                Transform.translate(
                  offset: Offset(
                    0,
                    80 * (1 - progress) + 40 - 40 * progress - 10,
                  ),
                  child: SizedBox(
                    height: 85,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: icons.length,
                      itemBuilder: (context, index) => icons[index],
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Bottom fade gradient (kéo xuống theo backgroundScale)
        Align(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(0, (backgroundScale - 1) * 300),
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
        backgroundScale != oldDelegate.backgroundScale;
  }

  Widget _buildTopIcon(String asset) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF828282).withOpacity(0.3),
          ),
        ),
        SvgPicture.asset(asset),
      ],
    );
  }
}
