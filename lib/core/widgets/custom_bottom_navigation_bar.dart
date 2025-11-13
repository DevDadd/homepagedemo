import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showNav;
  final Color? backgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showNav = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = backgroundColor ?? Colors.white;

    Widget bottomNavBar = BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: defaultBackgroundColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1AAF74),
      unselectedItemColor: const Color(0xFF6F767E),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700),
      unselectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500),
      items: [
        _buildBottomNavItem(0, "Trang chủ", "assets/icons/house.svg"),
        _buildBottomNavItem(1, "Danh mục", "assets/icons/chart.svg"),
        _buildBottomNavItem(2, "Đặt lệnh", "assets/icons/hammer.svg"),
        _buildBottomNavItem(3, "Số dư GD", "assets/icons/wallet.svg"),
        _buildBottomNavItem(4, "Chức năng", "assets/icons/function.svg"),
      ],
    );

    // Wrap với AnimatedSlide để có animation ẩn/hiện
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: showNav ? Offset.zero : const Offset(0, 1),
      child: bottomNavBar,
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
    int index,
    String label,
    String iconPath,
  ) {
    final isSelected = currentIndex == index;
    final iconColor = isSelected
        ? const Color(0xFF1AAF74)
        : const Color(0xFF6F767E);
    final unselectedColor = const Color(0xFF6F767E);

    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(iconPath, color: unselectedColor),
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath, color: iconColor),
          const SizedBox(height: 6),
          SvgPicture.asset("assets/icons/line.svg"),
        ],
      ),
    );
  }
}
