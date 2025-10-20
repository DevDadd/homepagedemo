import 'dart:async';

import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_cubit.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_state.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/buybuttonclipper.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/dottedlinepainter.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/keyboard.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/percentkeyboard.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/sellbuttonclipper.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

class Commandorder extends StatefulWidget {
  const Commandorder({super.key});

  @override
  State<Commandorder> createState() => _CommandorderState();
}

class _CommandorderState extends State<Commandorder>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabController1;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _avaController = TextEditingController();
  final double sucmua = 100000000;
  final int limit = 0;
  final double thamchieu = 94.30;
  final double giatran = 100.90;
  final double giamin = 87.70;
  final double giahientai = 94.20;
  final FocusNode _priceFocus = FocusNode();
  bool isPriceFocused = false;
  bool isVolumeFocused = false;
  final FocusNode _volumeFocus = FocusNode();
  bool _isOverLimit = false;
  final FocusNode _totalFocus = FocusNode();
  bool isTotalFocused = false;
  bool isOverSucMua = false;
  bool isTabBarVisible = true;
  final TextEditingController _controller = TextEditingController();
  final NumberFormat numberFormat = NumberFormat.decimalPattern('vi');

  final List<String> hi = ["FPT", "VIC", "HPG", "VCB", "VNI", "HNX"];

  void _openCustomKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
    setState(() => isTabBarVisible = false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) {
        return CustomKeyboard(
          onTextInput: (value) {
            setState(() {
              _controller.text += value;
            });
          },
          onBackspace: () {
            setState(() {
              if (_controller.text.isNotEmpty) {
                _controller.text = _controller.text.substring(
                  0,
                  _controller.text.length - 1,
                );
              }
            });
          },
        );
      },
    ).whenComplete(() {
      setState(() => isTabBarVisible = true);
    });
  }

  void checkSucMua() {
    final totalText = _totalController.text.replaceAll('.', '');
    final total = int.tryParse(totalText) ?? 0;
    setState(() {
      isOverSucMua = total > sucmua;
    });
  }

  void checkLimit() {
    final price = double.tryParse(_priceController.text);
    if (price != null) {
      setState(() {
        _isOverLimit = price > giatran || price < giamin;
      });
    } else {
      _isOverLimit = false;
    }
  }

  void calculate_volume_with_percentages(int percentages) {
    // Lấy giá hiện tại — KHÔNG remove '.' vì đây là dấu thập phân (vd "100.90")
    final priceText = _priceController.text.trim();
    final currentPrice = double.tryParse(priceText);

    // Nếu chưa nhập giá hoặc parse fail thì dùng giá sàn
    final validPrice = (currentPrice != null && currentPrice > 0)
        ? currentPrice
        : giamin;

    // Tổng sức mua theo phần trăm
    final total = sucmua * (percentages / 100);

    // Tính khối lượng (volume) = total / price
    final volume = total / validPrice;

    // Vì volume bạn muốn là int, làm tròn (hoặc floor/ceil tùy ý)
    final intVolume = volume.round();

    // Format volume có dấu chấm ngăn hàng nghìn
    final formatted = numberFormat.format(intVolume);

    // Cập nhật controller (và đặt caret cuối)
    _avaController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    // Cập nhật total tương ứng (format có dấu chấm)
    _totalValue();
  }

  void increamentController(TextEditingController controller) {
    double current = double.tryParse(controller.text) ?? 0.0;
    double new_value = current + 0.1;
    controller.text = new_value.toStringAsFixed(1);
  }

  void increamentAvalbleController(TextEditingController controller) {
    // Bỏ dấu chấm trước khi parse
    final text = controller.text.replaceAll('.', '');
    int current = int.tryParse(text) ?? 0;

    // Tăng giá trị
    int newValue = current + 1;

    // Format lại có dấu chấm ngăn cách
    final formatted = numberFormat.format(newValue);

    // Cập nhật lại controller mà không làm nhảy con trỏ lung tung
    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void decreamentAvalbleController(TextEditingController controller) {
    final text = controller.text.replaceAll('.', '');
    int current = int.tryParse(text) ?? 0;

    int newValue = current > 0 ? current - 1 : 0;

    final formatted = numberFormat.format(newValue);

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void decreasementController(TextEditingController controller) {
    double current = double.tryParse(controller.text) ?? 0.0;
    double new_value = current - 0.1;
    if (new_value < 0) {
      new_value = 0.0;
    } else {
      controller.text = new_value.toStringAsFixed(1);
    }
  }

  void _totalValue() {
    final priceText = _priceController.text.replaceAll('.', '');
    final volumeText = _avaController.text.replaceAll('.', '');

    final price = double.tryParse(priceText);
    final volume = int.tryParse(volumeText);

    if (price == null || volume == null) return;

    final total = (price * volume).round();
    final formatted = numberFormat.format(total);

    if (_totalController.text != formatted) {
      _totalController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void findVolumeWhenKnowTotal() {
    final totalText = _totalController.text.replaceAll('.', '');
    final priceText = _priceController.text.replaceAll('.', '');

    final total = double.tryParse(totalText);
    final price = double.tryParse(priceText);

    if (total == null || price == null || price == 0) return;

    final volume = total / price;
    final intVolume = volume.round();
    final formatted = numberFormat.format(intVolume);

    if (_avaController.text != formatted) {
      _avaController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  bool isValid(
    TextEditingController priceController,
    TextEditingController volumeController,
    TextEditingController totalController,
    double giatran,
    double giamin,
    double sucmua,
  ) {
    final price = double.tryParse(priceController.text);
    final volume = double.tryParse(volumeController.text);
    final total = double.tryParse(totalController.text);

    if (price == null || volume == null || total == null) {
      return false;
    }

    return (price >= giamin && price <= giatran) && (total <= sucmua);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController1 = TabController(length: 4, vsync: this);

    // 🧮 Tự tính total khi nhập price/volume
    _priceController.addListener(_totalValue);
    _priceController.addListener(checkLimit);

    // 🧮 Format volume khi người dùng nhập
    _avaController.addListener(() {
      if (_volumeFocus.hasFocus) {
        final text = _avaController.text.replaceAll('.', '');
        if (text.isEmpty) return;
        final number = int.tryParse(text);
        if (number == null) return;

        final newText = numberFormat.format(number);

        final selectionIndexFromEnd =
            _avaController.text.length - _avaController.selection.end;
        if (_avaController.text != newText) {
          _avaController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: newText.length - selectionIndexFromEnd,
            ),
          );
        }

        _totalValue();
      }
    });
    _totalController.addListener(checkSucMua);

    _totalController.addListener(() {
      if (_totalFocus.hasFocus) {
        final text = _totalController.text.replaceAll('.', '');
        if (text.isEmpty) return;
        final number = int.tryParse(text);
        if (number == null) return;

        final newText = numberFormat.format(number);

        final selectionIndexFromEnd =
            _totalController.text.length - _totalController.selection.end;
        if (_totalController.text != newText) {
          _totalController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: newText.length - selectionIndexFromEnd,
            ),
          );
        }

        // ✅ Gọi tính toán volume sau khi format xong
        findVolumeWhenKnowTotal();
      }
    });

    // 🎯 Theo dõi focus cho 3 ô nhập
    _priceFocus.addListener(() {
      setState(() {
        if (_priceFocus.hasFocus) {
          print("a");
        } else {
          print("b");
        }
        isPriceFocused = _priceFocus.hasFocus;
      });
    });

    _volumeFocus.addListener(() {
      setState(() {
        isVolumeFocused = _volumeFocus.hasFocus;
      });
    });

    _totalFocus.addListener(() {
      setState(() {
        isTotalFocused = _totalFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController1.dispose();
    _priceController.dispose();
    _totalController.dispose();
    _avaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111315),
        appBar: AppBar(
          toolbarHeight: 44,
          backgroundColor: const Color(0xFF111315),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(-60, 0),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        dividerColor: Colors.transparent,
                        labelPadding: const EdgeInsets.only(right: 10),
                        indicator: UnderlineTabIndicator(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 3,
                            color: Colors.white,
                          ),
                          insets: const EdgeInsets.symmetric(horizontal: 3),
                        ),
                        labelStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                        unselectedLabelStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        tabs: const [
                          Tab(text: "Cơ Sở"),
                          Tab(text: "Phái sinh"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                SvgPicture.asset("assets/icons/clock.svg"),
                const SizedBox(width: 3.12),
                Text(
                  "Thoả thuận",
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF1AAF74),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            SvgPicture.asset("assets/icons/idk.svg"),
            const SizedBox(width: 12),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey.shade800),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TabBarView(
            controller: _tabController,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: const BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.83),
                                  child: SvgPicture.asset(
                                    "assets/icons/magnifying.svg",
                                    width: 16,
                                    height: 16,
                                    color: const Color(0xFF6F767E),
                                  ),
                                ),
                                const SizedBox(width: 4.83),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Text(
                                      "FPT",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, 13),
                                      child: Container(
                                        width: 28,
                                        height: 1.5,
                                        color: const Color(0xFF6F767E),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  giahientai.toString(),
                                  style: GoogleFonts.manrope(
                                    color: const Color(0xFFF34859),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "-0.10",
                                  style: GoogleFonts.manrope(
                                    color: const Color(0xFFF34859),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "(0.11%)",
                                  style: GoogleFonts.manrope(
                                    color: const Color(0xFFF34859),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                    "assets/icons/button1.svg",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                const SizedBox(width: 12),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      height: 20,
                                      child: Marquee(
                                        text: "Công ty cổ phần FPT",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: const Color(0xFF6F767E),
                                        ),
                                        scrollAxis: Axis.horizontal,
                                        blankSpace: 10.0,
                                        velocity: 40.0,
                                        startPadding: 0.0,
                                        accelerationDuration: const Duration(
                                          seconds: 1,
                                        ),
                                        accelerationCurve: Curves.linear,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: CustomPaint(
                                        size: const Size(double.infinity, 1),
                                        painter: DottedLinePainter(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: const Color(
                                      0xFF6F767E,
                                    ).withOpacity(0.3),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "HOSE",
                                      style: GoogleFonts.manrope(
                                        color: const Color(0xFF6F767E),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _priceController.text = giatran
                                        .toStringAsFixed(2);
                                  },
                                  child: Text(
                                    giatran.toStringAsFixed(2),
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFFA43EE7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    _priceController.text = thamchieu
                                        .toStringAsFixed(2);
                                  },
                                  child: Text(
                                    thamchieu.toStringAsFixed(2),
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: const Color(0xFFFF9F41),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    _priceController.text = giamin
                                        .toStringAsFixed(2);
                                  },
                                  child: Text(
                                    giamin.toStringAsFixed(2),
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF3FC2EB),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                    "assets/icons/button2.svg",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 21),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            AnimatedSize(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: Opacity(
                                opacity: isTabBarVisible
                                    ? 1.0
                                    : 0.0, // fade in/out
                                child: IgnorePointer(
                                  ignoring:
                                      !isTabBarVisible, // không nhận tương tác khi ẩn
                                  child: TabBar(
                                    controller: _tabController1,
                                    isScrollable: true,
                                    tabAlignment: TabAlignment.start,
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white60,
                                    indicatorColor: Colors.white,
                                    dividerColor: Colors.transparent,
                                    labelStyle: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFB8B3B3),
                                      fontSize: 14,
                                    ),
                                    unselectedLabelStyle: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6F767E),
                                      fontSize: 12,
                                    ),
                                    indicator: UnderlineTabIndicator(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        width: 3,
                                        color: Color(0xFF1AAF74),
                                      ),
                                      insets: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                    ),
                                    tabs: const [
                                      Tab(text: "Giá"),
                                      Tab(text: "Biểu đồ"),
                                      Tab(text: "Khớp lệnh"),
                                      Tab(text: "Thanh khoản"),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            AutoScaleTabBarView(
                              controller: _tabController1,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 19,
                                    right: 12,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "KL",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF6F767E),
                                                ),
                                              ),
                                              SizedBox(width: 103.5),
                                              Text(
                                                "Giá mua",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF6F767E),
                                                ),
                                              ),
                                              SizedBox(width: 24),
                                              Text(
                                                "Giá bán",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF6F767E),
                                                ),
                                              ),
                                              SizedBox(width: 107.5),
                                              Text(
                                                "KL",
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
                                                  color: Color(0xFF6F767E),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "20,000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                                SizedBox(width: 85.5),
                                                Stack(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 18),
                                                        Container(
                                                          width: 33,
                                                          height: 21,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.only(
                                                                  topLeft:
                                                                      Radius.circular(
                                                                        4,
                                                                      ),
                                                                  bottomLeft:
                                                                      Radius.circular(
                                                                        4,
                                                                      ),
                                                                ),
                                                            color: Color(
                                                              0xFF1AAF74,
                                                            ).withOpacity(0.3),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        giahientai
                                                            .toStringAsFixed(2),
                                                        style:
                                                            GoogleFonts.manrope(
                                                              color: Color(
                                                                0xFFF34859,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 33,
                                                            height: 21,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                    topRight:
                                                                        Radius.circular(
                                                                          4,
                                                                        ),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                          4,
                                                                        ),
                                                                  ),
                                                              color:
                                                                  Color(
                                                                    0xFFF34859,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 14,
                                                          ),
                                                      child: Text(
                                                        thamchieu
                                                            .toStringAsFixed(2),
                                                        style:
                                                            GoogleFonts.manrope(
                                                              color: Color(
                                                                0xFFFF9F41,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  "10.000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "30,000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                                SizedBox(width: 51.w),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 21.h,
                                                      width: 79.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        color: Color(
                                                          0xFF1AAF74,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 34,
                                                          ),
                                                      child: Text(
                                                        "94.10",
                                                        style:
                                                            GoogleFonts.manrope(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFFF34859,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 21.h,
                                                      width: 79.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        color: Color(
                                                          0xFFF34859,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 14,
                                                          ),
                                                      child: Text(
                                                        "94.40",
                                                        style:
                                                            GoogleFonts.manrope(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFFF34859,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  "15,000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "50,000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                                SizedBox(width: 27),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 21,
                                                      width: 109,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        color: Color(
                                                          0xFF1AAF74,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 56,
                                                          ),
                                                      child: Text(
                                                        "94.00",
                                                        style:
                                                            GoogleFonts.manrope(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFFF34859,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 21,
                                                      width: 101,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        color: Color(
                                                          0xFFF34859,
                                                        ).withOpacity(0.3),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 14,
                                                          ),
                                                      child: Text(
                                                        "94.50",
                                                        style:
                                                            GoogleFonts.manrope(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              color: Color(
                                                                0xFFF34859,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Text(
                                                  "20,000",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFF6F767E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                      top: 19,
                                    ),
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Lịch sử",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Khác",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      BlocBuilder<OrdercommandCubit, OrdercommandState>(
                        builder: (context, state) {
                          return Container(
                            height: 200,
                            width: 375,
                            decoration: BoxDecoration(
                              color: Color(0xFF2F3437),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: -16,
                                  blurRadius: 24,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 12,
                                    right: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            context
                                                .read<OrdercommandCubit>()
                                                .clickBuyButton();
                                          },
                                          child: ClipPath(
                                            clipper: MuaButtonClipper(),
                                            child: Container(
                                              width: 84.75,
                                              height: 36,
                                              decoration: BoxDecoration(
                                                color: state.isClickedSell
                                                    ? Color(0xFF3A4247)
                                                    : Color(
                                                        0xFF1AAF74,
                                                      ).withOpacity(0.3),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Mua",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight:
                                                        state.isClickedSell
                                                        ? FontWeight.w500
                                                        : FontWeight.w700,
                                                    fontSize: 14,
                                                    color: state.isClickedSell
                                                        ? Color(0xFFC4C4C4)
                                                        : Color(0xFF1AAF74),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<OrdercommandCubit>()
                                              .clickSellButton();
                                        },
                                        child: ClipPath(
                                          clipper: SellButtonFlippedClipper(),
                                          child: Container(
                                            width: 84.75,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: state.isClickedSell
                                                  ? Color(
                                                      0xFFF34859,
                                                    ).withOpacity(0.3)
                                                  : Color(0xFF3A4247),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Bán",
                                                style: GoogleFonts.manrope(
                                                  fontWeight:
                                                      state.isClickedSell
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  fontSize: 14,
                                                  color: state.isClickedSell
                                                      ? Color(0xFFF34859)
                                                      : Color(0xFFC4C4C4),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/orderwaiting.svg",
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Lệnh chờ",
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFC7C7C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/sodu.svg",
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "Số dư CK",
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFC7C7C7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Lệnh thường",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Color(0xFFC7C7C7),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        SvgPicture.asset(
                                          "assets/icons/arrowdown.svg",
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Tiền mặt",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Color(0xFFC7C7C7),
                                          ),
                                        ),
                                        Spacer(),
                                        Stack(
                                          children: [
                                            state.isClickedSell
                                                ? Text(
                                                    "Lãi Lỗ:",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF6F767E),
                                                    ),
                                                  )
                                                : Text(
                                                    "Sức mua:",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF6F767E),
                                                    ),
                                                  ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: CustomPaint(
                                                size: const Size(
                                                  double.infinity,
                                                  0.5,
                                                ),
                                                painter: DottedLinePainter(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          state.isClickedSell
                                              ? limit.toString()
                                              : sucmua.toString(),
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        SvgPicture.asset(
                                          "assets/icons/add.svg",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Ô giá
                                        Container(
                                          width: 169.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: const Color(0xFF3A4247),
                                            border: Border.all(
                                              color: _isOverLimit
                                                  ? Colors.red
                                                  : (isPriceFocused
                                                        ? Colors.green
                                                        : Colors.transparent),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      decreasementController(
                                                        _priceController,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/addbut.svg",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    onTap: () {
                                                      setState(
                                                        () => isTabBarVisible =
                                                            false,
                                                      );
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        useRootNavigator: true,
                                                        barrierColor:
                                                            Colors.transparent,
                                                        builder: (_) => GestureDetector(
                                                          behavior:
                                                              HitTestBehavior
                                                                  .opaque,
                                                          onTap: () {
                                                            FocusScope.of(
                                                              context,
                                                            ).unfocus();
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: CustomKeyboard(
                                                            onTextInput: (value) {
                                                              setState(() {
                                                                final current =
                                                                    _priceController
                                                                        .text;
                                                                if ([
                                                                  "LO",
                                                                  "MP",
                                                                  "ATO",
                                                                  "ATC",
                                                                ].contains(
                                                                  value,
                                                                )) {
                                                                  _priceController
                                                                          .text =
                                                                      value;
                                                                }
                                                                // Nếu hiện tại là LO/MP/ATO thì KHÔNG cho nhập thêm số
                                                                else if (![
                                                                  "LO",
                                                                  "MP",
                                                                  "ATO",
                                                                  "ATC",
                                                                  "L",
                                                                  "O",
                                                                  "M",
                                                                  "P",
                                                                  "A",
                                                                  "T",
                                                                  "0",
                                                                  "C",
                                                                ].contains(
                                                                  current,
                                                                )) {
                                                                  _priceController
                                                                          .text +=
                                                                      value;
                                                                }

                                                                // Đặt con trỏ về cuối
                                                                _priceController
                                                                    .selection = TextSelection.fromPosition(
                                                                  TextPosition(
                                                                    offset: _priceController
                                                                        .text
                                                                        .length,
                                                                  ),
                                                                );
                                                              });
                                                            },
                                                            onBackspace: () {
                                                              setState(() {
                                                                if (_priceController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  _priceController
                                                                      .text = _priceController
                                                                      .text
                                                                      .substring(
                                                                        0,
                                                                        _priceController.text.length -
                                                                            1,
                                                                      );
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ).whenComplete(() {
                                                        setState(
                                                          () =>
                                                              isTabBarVisible =
                                                                  true,
                                                        ); 
                                                        _priceFocus
                                                            .unfocus(); 
                                                      });

                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback((
                                                            _,
                                                          ) {
                                                            _priceFocus
                                                                .requestFocus();
                                                          });
                                                    },
                                                    readOnly: true,
                                                    cursorColor: Colors.green,
                                                    focusNode: _priceFocus,
                                                    style: GoogleFonts.manrope(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    controller:
                                                        _priceController,
                                                    decoration: InputDecoration(
                                                      hintText: "Giá",
                                                      hintStyle:
                                                          GoogleFonts.manrope(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                          ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                            top: 11,
                                                            bottom: 12,
                                                          ),
                                                    ),
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      increamentController(
                                                        _priceController,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/plus.svg",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // Ô khối lượng (volume) + cảnh báo
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: 169.5,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(0xFF3A4247),
                                                border: Border.all(
                                                  color: isOverSucMua
                                                      ? Colors.red
                                                      : (isVolumeFocused
                                                            ? Colors.green
                                                            : Colors
                                                                  .transparent),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          decreamentAvalbleController(
                                                            _avaController,
                                                          ),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/addbut.svg",
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TextField(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isScrollControlled:
                                                                true,
                                                            barrierColor: Colors
                                                                .transparent,
                                                            builder: (_) => Percentkeyboard(
                                                              // 🔹 Khi người dùng nhấn nút bất kỳ
                                                              onTextInput: (value) {
                                                                // Nếu là phần trăm → gọi hàm tính volume theo phần trăm
                                                                if ([
                                                                  "25%",
                                                                  "50%",
                                                                  "75%",
                                                                  "100%",
                                                                ].contains(
                                                                  value,
                                                                )) {
                                                                  final percent =
                                                                      int.tryParse(
                                                                        value.replaceAll(
                                                                          '%',
                                                                          '',
                                                                        ),
                                                                      ) ??
                                                                      0;
                                                                  calculate_volume_with_percentages(
                                                                    percent,
                                                                  );
                                                                  return;
                                                                }

                                                                // Nếu là các chế độ LO / MP / ATO / ATC
                                                                if ([
                                                                  "LO",
                                                                  "MP",
                                                                  "ATO",
                                                                  "ATC",
                                                                ].contains(
                                                                  value,
                                                                )) {
                                                                  _avaController
                                                                          .text =
                                                                      value;
                                                                  return;
                                                                }

                                                                // Nếu đang ở chế độ LO / MP / ATO / ATC thì không nhập thêm số
                                                                if ([
                                                                  "LO",
                                                                  "MP",
                                                                  "ATO",
                                                                  "ATC",
                                                                ].contains(
                                                                  _avaController
                                                                      .text,
                                                                ))
                                                                  return;

                                                                // Thêm ký tự vào text hiện tại
                                                                _avaController
                                                                        .text +=
                                                                    value;
                                                              },

                                                              // 🔹 Khi người dùng nhấn backspace
                                                              onBackspace: () {
                                                                if (_avaController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  _avaController
                                                                      .text = _avaController
                                                                      .text
                                                                      .substring(
                                                                        0,
                                                                        _avaController.text.length -
                                                                            1,
                                                                      );
                                                                }
                                                              },

                                                              // 🔹 Callback riêng khi chọn phần trăm
                                                              onPercentSelected:
                                                                  (percent) {
                                                                    calculate_volume_with_percentages(
                                                                      percent,
                                                                    );
                                                                  },
                                                            ),
                                                          ).then((value) {
                                                            _volumeFocus
                                                                .unfocus();
                                                          });
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback((
                                                                _,
                                                              ) {
                                                                _volumeFocus
                                                                    .requestFocus();
                                                              });
                                                        },
                                                        readOnly: true,
                                                        cursorColor:
                                                            Colors.green,
                                                        focusNode: _volumeFocus,
                                                        style:
                                                            GoogleFonts.manrope(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                        ],
                                                        controller:
                                                            _avaController,
                                                        decoration: InputDecoration(
                                                          hintText: "Tối đa: 0",
                                                          hintStyle:
                                                              GoogleFonts.manrope(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 14,
                                                              ),
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              const EdgeInsets.only(
                                                                top: 9.5,
                                                                bottom: 12,
                                                              ),
                                                        ),
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          increamentAvalbleController(
                                                            _avaController,
                                                          ),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/plus.svg",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Dòng cảnh báo hiện đè ra dưới container
                                            if (isOverSucMua)
                                              Positioned(
                                                bottom: -17,
                                                left: -5,
                                                right: 0,
                                                child: Center(
                                                  child: Text(
                                                    "Vượt quá khối lượng tối đa",
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: _isOverLimit ? 0 : 18),
                                if (_isOverLimit)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      bottom: 8,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Giá không nằm trong biên độ",
                                        style: GoogleFonts.manrope(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 169.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isTotalFocused
                                                  ? Colors.green
                                                  : Colors.transparent,
                                            ),
                                            color: Color(0xFF3A4247),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        barrierColor:
                                                            Colors.transparent,
                                                        builder: (_) => CustomKeyboard(
                                                          onTextInput: (value) {
                                                            if ([
                                                              "LO",
                                                              "MP",
                                                              "ATO",
                                                              "ATC",
                                                            ].contains(value)) {
                                                              _totalController
                                                                      .text =
                                                                  value;
                                                            } else {
                                                              if ([
                                                                "LO",
                                                                "MP",
                                                                "ATO",
                                                                "ATC",
                                                              ].contains(
                                                                _totalController
                                                                    .text,
                                                              ))
                                                                return;

                                                              _totalController
                                                                      .text +=
                                                                  value;
                                                            }
                                                          },
                                                          onBackspace: () {
                                                            if (_totalController
                                                                .text
                                                                .isNotEmpty) {
                                                              _totalController
                                                                  .text = _totalController
                                                                  .text
                                                                  .substring(
                                                                    0,
                                                                    _totalController
                                                                            .text
                                                                            .length -
                                                                        1,
                                                                  );
                                                            }
                                                          },
                                                        ),
                                                      ).then((value) {
                                                        _totalFocus.unfocus();
                                                      });
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback((
                                                            _,
                                                          ) {
                                                            _totalFocus
                                                                .requestFocus();
                                                          });
                                                    },
                                                    cursorColor: Colors.green,
                                                    focusNode: _totalFocus,
                                                    style: GoogleFonts.manrope(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    controller:
                                                        _totalController,
                                                    decoration: InputDecoration(
                                                      hintText: "Tổng giá trị",
                                                      hintStyle:
                                                          GoogleFonts.manrope(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                          ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                            top: 9.5,
                                                            bottom: 13.5,
                                                          ),
                                                    ),
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            if (isValid(
                                              _priceController,
                                              _avaController,
                                              _totalController,
                                              giatran,
                                              giamin,
                                              sucmua,
                                            )) {
                                              print(1);
                                            } else {
                                              print(0);
                                            }
                                          },
                                          child: Container(
                                            width: 129.5,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: state.isClickedSell
                                                  ? Color(0xFFF34859)
                                                  : Color(0xFF1AAF74),
                                            ),
                                            child: Center(
                                              child: state.isClickedSell
                                                  ? Text(
                                                      "Đặt bán",
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          ),
                                                    )
                                                  : Text(
                                                      "Đặt lệnh",
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        SvgPicture.asset(
                                          "assets/icons/pen.svg",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.3,
                      minChildSize: 0.3,
                      maxChildSize: 0.92,
                      builder: (context, controller) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF111315),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DefaultTabController(
                          length: 3, // số tab
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(text: "Chờ khớp"),
                                  Tab(text: "Đã khớp"),
                                  Tab(text: "Lệnh điều kiện"),
                                ],
                                isScrollable: true,
                                labelColor: Color(0xFF1AAF74),
                                labelStyle: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                ),
                                unselectedLabelStyle: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                ),
                                tabAlignment: TabAlignment.start,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                unselectedLabelColor: Color(0xFF6F767E),
                                dividerColor: Colors.transparent,
                                indicator: UnderlineTabIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: Color(0xFF1AAF74),
                                  ),
                                  insets: EdgeInsetsGeometry.symmetric(
                                    horizontal: 3,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    ListView.builder(
                                      controller: controller,
                                      itemCount: hi.length,
                                      itemBuilder: (context, index) {
                                        final label = hi[index];
                                        return ListTile(
                                          title: Text(
                                            label,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Center(
                                      child: Text(
                                        "Nội dung Tab 2",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "Nội dung Tab 3",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Center(
                child: Text(
                  "Nội dung Phái sinh",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
