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
    // progress: 0 khi expanded, 1 khi fully collapsed
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Font sizes
    final double nameFontSize = 32 - (12 * progress);
    final double messageFontSize = 16 * (1 - progress);

    // Avatar: size 0 → 44 khi collapse
    final double avatarSize = 44 * progress;

    // ID: 0 → 14
    final double idFontSize = 14 * progress;

    // ID offset xuống dưới tên
    final double idYOffset = 1 * progress;

    // Dịch toàn bộ header lên cao khi collapse (-13px trước)
    final double overallYOffset = -13 * progress;

    // Offset thêm để Tên + ID lên cao thêm 2px
    final double textsYOffset = -2 * progress;

    // Dịch avatar lên cao cùng header để không bị tụt
    final double avatarYOffset = progress;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(0, overallYOffset),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Avatar
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

                /// Texts
                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, textsYOffset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message
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

                        /// Name + arrow
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

                        // ID: scale + dịch chuyển xuống dưới
                        Transform.translate(
                          offset: Offset(0, idYOffset),
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
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Menu icons
          SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: icons.length,
              itemBuilder: (context, index) => icons[index],
              separatorBuilder: (context, index) => const SizedBox(width: 40),
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
