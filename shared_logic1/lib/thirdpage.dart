import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic1/fourthpage.dart';
import 'package:shared_logic1/widgets/listwidget.dart';

class Thirdpage extends StatefulWidget {
  final int selectedIndex;
  Thirdpage({super.key, required this.selectedIndex});

  @override
  State<Thirdpage> createState() => _ThirdpageState();
}

class _ThirdpageState extends State<Thirdpage> {
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

  // Danh sách items được highlight tự động dựa trên selectedIndex
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

  // Tổng số items đã được chọn (bao gồm cả auto highlight và user selection)
  int get selectedCount {
    // Lấy số items được highlight tự động
    final autoCount = autoHighlightedTitles.length;
    // Lấy số items user đã click (trừ đi những items đã có trong auto highlight)
    final userSelectedTitles = selectedTitles
        .where((title) => !autoHighlightedTitles.contains(title))
        .toSet();
    final userCount = userSelectedTitles.length;
    return autoCount + userCount;
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
                          final autoCount = autoHighlightedTitles.length;
                          final userCount = selectedTitles
                              .where((t) => !autoHighlightedTitles.contains(t))
                              .length;

                          if (selectedCount >= 1 && selectedCount <= 7) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Fourthpage(),
                              ),
                            );
                          } else {
                            print(
                              'Cannot navigate: selectedCount = $selectedCount (must be 1-7)',
                            );
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
