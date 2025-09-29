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
  final List<Listview> icons;

  Homepagesliverheader({
    required this.minHeight,
    required this.maxHeight,
    required this.name,
    required this.clientId,
    required this.message,
    required this.icons,
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
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                name,
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF424242),
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset("assets/icons/arrow.svg"),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 85,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: icons.length,
              itemBuilder: (context, index) => icons[index],
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 41.75),
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
        maxHeight != oldDelegate.maxHeight;
  }
}
