import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic1/fourthpage.dart';
import 'package:shared_logic1/widgets/listwidget.dart';

class Thirdpage extends StatefulWidget {
  final int selectedIndex;
  final VoidCallback? onNavigateToHome;

  Thirdpage({super.key, required this.selectedIndex, this.onNavigateToHome});

  @override
  State<Thirdpage> createState() => _ThirdpageState();
}

class _ThirdpageState extends State<Thirdpage>
    with SingleTickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void showOverlay() {
    _overlayTimer?.cancel();

    overlayEntry?.remove();
    overlayEntry = null;

    _animationController.reset();

    final overlay = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Positioned(
            top: size.height * 0.1 + _slideAnimation.value,
            left: 20,
            right: 20,
            child: Container(
              width: 343.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Không thể chọn hơn 7 widgets",
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    overlay.insert(overlayEntry!);
    _animationController.forward();

    _overlayTimer = Timer(Duration(seconds: 2), () {
      _animationController.reverse().then((_) {
        overlayEntry?.remove();
        overlayEntry = null;
      });
    });
  }

  List<String> titles = [
    "Tài sản",
    "Chỉ số thị trường",
    "Nhóm cổ phiếu",
    "Danh sách sở hữu",
    "Tin tức",
    "Bản đồ nhiệt",
    "Hiệu quả đầu tư",
    "Khuyến nghị đầu tư",
  ];
  Set<String> selectedTitles = {};

  List<String> get autoHighlightedTitles {
    if (widget.selectedIndex == 0) {
      return ["Tài sản", "Chỉ số thị trường", "Nhóm cổ phiếu"];
    } else if (widget.selectedIndex == 1) {
      return [
        "Tài sản",
        "Chỉ số thị trường",
        "Nhóm cổ phiếu",
        "Danh sách sở hữu",
        "Tin tức",
      ];
    } else if (widget.selectedIndex == 2) {
      return [
        "Tài sản",
        "Chỉ số thị trường",
        "Nhóm cổ phiếu",
        "Danh sách sở hữu",
        "Tin tức",
        "Bản đồ nhiệt",
        "Hiệu quả đầu tư",
      ];
    }
    return [];
  }

  int get selectedCount {
    final autoCount = autoHighlightedTitles.length;
    final userSelectedTitles = selectedTitles
        .where((title) => !autoHighlightedTitles.contains(title))
        .toSet();
    final userCount = userSelectedTitles.length;
    return autoCount + userCount;
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _animationController.stop();
    _animationController.dispose();
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111315),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "Đề xuất dành cho bạn",
                style: GoogleFonts.manrope(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Text(
                "Dựa trên lựa chọn của bạn & nghiên cứu của chúng tôi",
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6F767E),
                ),
              ),
            ),
            SizedBox(height: 38.h),
            Expanded(
              child: ReorderableListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                shrinkWrap: true,
                children: List.generate(
                  titles.length,
                  (index) => Listwidget(
                    key: ValueKey(titles[index]),
                    title: titles[index],
                    selectedIndex: widget.selectedIndex,
                    itemIndex: index,
                    isSelected: selectedTitles.contains(titles[index]),
                    onTap: () {
                      setState(() {
                        final title = titles[index];
                        // Nếu item đã được highlight tự động, không cho phép toggle
                        if (autoHighlightedTitles.contains(title)) {
                          return;
                        }

                        if (selectedTitles.contains(title)) {
                          selectedTitles.remove(title);
                        } else {
                          // Cho phép chọn tất cả items (không giới hạn)
                          selectedTitles.add(title);
                        }
                      });
                    },
                  ),
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = titles.removeAt(oldIndex);
                    titles.insert(newIndex, item);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 37.5,
                left: 36,
                right: 27.25,
              ),
              child: Row(
                children: [
                  Text(
                    "Bỏ qua",
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6F767E),
                    ),
                  ),
                  SizedBox(width: 173),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (selectedCount >= 1 && selectedCount <= 7) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Fourthpage(
                                  onNavigateToHome: widget.onNavigateToHome,
                                ),
                              ),
                            );
                          } else {
                            showOverlay();
                          }
                        },
                        child: Text(
                          "Tiếp theo",
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1AAF74),
                          ),
                        ),
                      ),
                      SizedBox(width: 11.25),
                      SvgPicture.asset("assets/icons/greenarr.svg"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
