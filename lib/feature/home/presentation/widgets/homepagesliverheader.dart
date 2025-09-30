import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/home/presentation/widgets/listview.dart';

class Homepagesliverheader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final String name;
  final String clientId;
  final String message;
  final String avatarURL;
  final List<FeatureItem> icons;

  Homepagesliverheader({
    required this.minHeight,
    required this.maxHeight,
    required this.name,
    required this.clientId,
    required this.message,
    required this.icons,
    required this.avatarURL,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Tính progress từ 0 -> 1
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Scale size theo progress
    final double nameFontSize = 32 - (12 * progress); // 32 -> 20
    final double messageFontSize = 16 * (1 - progress); // 16 -> 0
    final double avatarSize = 44 * progress; // 0 -> 44

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row avatar + text
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Avatar
              Container(
                height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(avatarURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// Texts
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// message
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

                  /// name + arrow
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
                      SvgPicture.asset("assets/icons/arrow.svg"),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Menu icons: giữ vị trí cố định, không Expanded
          SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: icons.length,
              itemBuilder: (context, index) => icons[index],
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 40), // khoảng cách vừa phải
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant Homepagesliverheader oldDelegate) {
    return name != oldDelegate.name ||
        clientId != oldDelegate.clientId ||
        message != oldDelegate.message ||
        minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        icons != oldDelegate.icons;
  }
}
