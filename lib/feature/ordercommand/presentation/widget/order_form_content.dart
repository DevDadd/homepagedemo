import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_cubit.dart';
import 'package:homepageintern/feature/ordercommand/presentation/cubit/ordercommand_state.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/buybuttonclipper.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/dottedlinepainter.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/keyboard.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/percentkeyboard.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/sellbuttonclipper.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/totalkeyboard.dart';
import 'package:intl/intl.dart';

class OrderFormContent extends StatefulWidget {
  final TabController tabController1;
  final TextEditingController priceController;
  final TextEditingController totalController;
  final TextEditingController avaController;
  final FocusNode priceFocus;
  final FocusNode volumeFocus;
  final FocusNode totalFocus;
  final bool isTabBarVisible;
  final bool isPriceFocused;
  final bool isVolumeFocused;
  final bool isTotalFocused;
  final bool isOverLimit;
  final bool isOverSucMua;
  final bool isTooltipVisible;
  final String errorMessage;
  final String? selectedMode;
  final double giahientai;
  final double giatran;
  final double thamchieu;
  final double giamin;
  final double sucmua;
  final int limit;
  final int? priceMaxCanBuy;
  final NumberFormat numberFormat;
  final JustTheController tooltipController;
  final GlobalKey orderWidgetKey;
  final ValueNotifier<double> position;
  final Function(double) onBottomLimitPositionChanged;
  final VoidCallback onSetState;
  final Function(bool) onIsTabBarVisibleChanged;
  final Function(bool) onIsTooltipVisibleChanged;
  final Function(bool) onIsVolumeFocusedChanged;
  final Function(TextEditingController) onIncreamentController;
  final Function(TextEditingController) onDecreasementController;
  final Function(TextEditingController) onIncreamentAvalbleController;
  final Function(TextEditingController) onDecreamentAvalbleController;
  final Function(int) onCalculateVolumeWithPercentages;
  final bool Function(
    TextEditingController,
    TextEditingController,
    TextEditingController,
    double,
    double,
    double,
  )
  onIsValid;
  final VoidCallback? onAutoScaleTabBarViewLoaded;

  const OrderFormContent({
    super.key,
    required this.tabController1,
    required this.priceController,
    required this.totalController,
    required this.avaController,
    required this.priceFocus,
    required this.volumeFocus,
    required this.totalFocus,
    required this.isTabBarVisible,
    required this.isPriceFocused,
    required this.isVolumeFocused,
    required this.isTotalFocused,
    required this.isOverLimit,
    required this.isOverSucMua,
    required this.isTooltipVisible,
    required this.errorMessage,
    required this.selectedMode,
    required this.giahientai,
    required this.giatran,
    required this.thamchieu,
    required this.giamin,
    required this.sucmua,
    required this.limit,
    required this.priceMaxCanBuy,
    required this.numberFormat,
    required this.tooltipController,
    required this.orderWidgetKey,
    required this.position,
    required this.onBottomLimitPositionChanged,
    required this.onSetState,
    required this.onIsTabBarVisibleChanged,
    required this.onIsTooltipVisibleChanged,
    required this.onIsVolumeFocusedChanged,
    required this.onIncreamentController,
    required this.onDecreasementController,
    required this.onIncreamentAvalbleController,
    required this.onDecreamentAvalbleController,
    required this.onCalculateVolumeWithPercentages,
    required this.onIsValid,
    this.onAutoScaleTabBarViewLoaded,
  });

  @override
  State<OrderFormContent> createState() => _OrderFormContentState();
}

class _OrderFormContentState extends State<OrderFormContent> {
  bool _isAutoScaleTabBarViewLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _isAutoScaleTabBarViewLoaded = true;
        });
        widget.onAutoScaleTabBarViewLoaded?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdercommandCubit, OrdercommandState>(
      builder: (context, state) {
        return Container(
          key: widget.orderWidgetKey,
          width: double.infinity,
          decoration: BoxDecoration(),
          child: Column(
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ClipRRect(
                  child: SizedBox(
                    height: widget.isTabBarVisible ? 50 : 0,
                    child: IgnorePointer(
                      ignoring: !widget.isTabBarVisible,
                      child: TabBar(
                        controller: widget.tabController1,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding: EdgeInsets.symmetric(horizontal: 20),
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
                          insets: EdgeInsets.symmetric(horizontal: 5),
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
              ),

              _isAutoScaleTabBarViewLoaded
                  ? AutoScaleTabBarView(
                      controller: widget.tabController1,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      widget.giahientai
                                                          .toStringAsFixed(2);
                                                },
                                                child: Text(
                                                  widget.giahientai
                                                      .toStringAsFixed(2),
                                                  style: GoogleFonts.manrope(
                                                    color: Color(0xFFF34859),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
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
                                                      color: Color(
                                                        0xFFF34859,
                                                      ).withOpacity(0.3),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      widget.thamchieu
                                                          .toStringAsFixed(2);
                                                },
                                                child: Text(
                                                  widget.thamchieu
                                                      .toStringAsFixed(2),
                                                  style: GoogleFonts.manrope(
                                                    color: Color(0xFFFF9F41),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
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
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  bottomLeft: Radius.circular(
                                                    4,
                                                  ),
                                                ),
                                                color: Color(
                                                  0xFF1AAF74,
                                                ).withOpacity(0.3),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 34,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      "94.10";
                                                },
                                                child: Text(
                                                  "94.10",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
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
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(4),
                                                  bottomRight: Radius.circular(
                                                    4,
                                                  ),
                                                ),
                                                color: Color(
                                                  0xFFF34859,
                                                ).withOpacity(0.3),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      "94.40";
                                                },
                                                child: Text(
                                                  "94.40",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
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
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(4),
                                                  bottomLeft: Radius.circular(
                                                    4,
                                                  ),
                                                ),
                                                color: Color(
                                                  0xFF1AAF74,
                                                ).withOpacity(0.3),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 56,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      "94.00";
                                                },
                                                child: Text(
                                                  "94.00",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
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
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(4),
                                                  bottomRight: Radius.circular(
                                                    4,
                                                  ),
                                                ),
                                                color: Color(
                                                  0xFFF34859,
                                                ).withOpacity(0.3),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 14,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  widget.priceController.text =
                                                      "94.50";
                                                },
                                                child: Text(
                                                  "94.50",
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color(0xFFF34859),
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
                              decoration: BoxDecoration(color: Colors.white),
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
                    )
                  : Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1AAF74),
                        ),
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
                                            fontWeight: state.isClickedSell
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
                                          ? Color(0xFFF34859).withOpacity(0.3)
                                          : Color(0xFF3A4247),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Bán",
                                        style: GoogleFonts.manrope(
                                          fontWeight: state.isClickedSell
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
                                  SvgPicture.asset("assets/icons/sodu.svg"),
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
                            padding: const EdgeInsets.only(left: 12, right: 12),
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
                                SvgPicture.asset("assets/icons/arrowdown.svg"),
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
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6F767E),
                                            ),
                                          )
                                        : Text(
                                            "Sức mua:",
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6F767E),
                                            ),
                                          ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: CustomPaint(
                                        size: const Size(double.infinity, 0.5),
                                        painter: DottedLinePainter(),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  state.isClickedSell
                                      ? widget.limit.toString()
                                      : widget.numberFormat
                                            .format(widget.sucmua)
                                            .toString(),
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 4),
                                SvgPicture.asset("assets/icons/add.svg"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 169.5,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF3A4247),
                                    border: Border.all(
                                      color: widget.isOverLimit
                                          ? Colors.red
                                          : (widget.isPriceFocused
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
                                        Builder(
                                          builder: (context) {
                                            final currentPrice =
                                                double.tryParse(
                                                  widget.priceController.text,
                                                ) ??
                                                0.0;
                                            final bool isAtFloor =
                                                currentPrice <= widget.giamin;

                                            return GestureDetector(
                                              onTap: isAtFloor
                                                  ? null
                                                  : () => widget
                                                        .onDecreasementController(
                                                          widget
                                                              .priceController,
                                                        ),
                                              child: Opacity(
                                                opacity: isAtFloor ? 0.4 : 1.0,
                                                child: SvgPicture.asset(
                                                  "assets/icons/addbut.svg",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: TextField(
                                            onTap: () {
                                              widget.onIsTabBarVisibleChanged(
                                                false,
                                              );
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                useRootNavigator: true,
                                                barrierColor:
                                                    Colors.transparent,
                                                enableDrag: false,
                                                builder: (_) => GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .deferToChild,
                                                  child: CustomKeyboard(
                                                    giaTran: widget.giatran,
                                                    selectedMode:
                                                        widget.selectedMode,
                                                    initialValue: widget
                                                        .priceController
                                                        .text
                                                        .replaceAll(',', ''),
                                                    onModeChanged: (mode) {
                                                      // widget.selectedMode is managed by parent
                                                    },
                                                    onTextInput: (value) {
                                                      // Update handled by controller
                                                      widget.onSetState();
                                                      if (value.contains('.')) {
                                                        final numValue =
                                                            double.tryParse(
                                                              value,
                                                            );
                                                        if (numValue != null) {
                                                          final parts = value
                                                              .split('.');
                                                          final integerPart =
                                                              parts[0]
                                                                  .replaceAll(
                                                                    ',',
                                                                    '',
                                                                  );
                                                          final decimalPart =
                                                              parts.length > 1
                                                              ? parts[1]
                                                              : '';
                                                          final formattedInteger =
                                                              widget
                                                                  .numberFormat
                                                                  .format(
                                                                    int.tryParse(
                                                                          integerPart,
                                                                        ) ??
                                                                        0,
                                                                  );
                                                          widget
                                                                  .priceController
                                                                  .text =
                                                              '$formattedInteger.$decimalPart';
                                                        } else {
                                                          widget
                                                                  .priceController
                                                                  .text =
                                                              value;
                                                        }
                                                      } else {
                                                        final numValue =
                                                            double.tryParse(
                                                              value,
                                                            );
                                                        if (numValue != null &&
                                                            numValue > 0) {
                                                          widget
                                                              .priceController
                                                              .text = widget
                                                              .numberFormat
                                                              .format(
                                                                numValue
                                                                    .toInt(),
                                                              );
                                                        } else {
                                                          widget
                                                                  .priceController
                                                                  .text =
                                                              value;
                                                        }
                                                      }
                                                      widget
                                                              .priceController
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                            TextPosition(
                                                              offset: widget
                                                                  .priceController
                                                                  .text
                                                                  .length,
                                                            ),
                                                          );
                                                    },

                                                    onBackspace: () {},
                                                    onConfirmed: (confirmedValue) {
                                                      widget.onSetState();
                                                      if (confirmedValue
                                                          .contains('.')) {
                                                        final numValue =
                                                            double.tryParse(
                                                              confirmedValue,
                                                            );
                                                        if (numValue != null &&
                                                            numValue > 0) {
                                                          final parts =
                                                              confirmedValue
                                                                  .split('.');
                                                          final integerPart =
                                                              parts[0]
                                                                  .replaceAll(
                                                                    ',',
                                                                    '',
                                                                  );
                                                          final decimalPart =
                                                              parts.length > 1
                                                              ? parts[1]
                                                              : '';

                                                          final isDecimalZero =
                                                              decimalPart
                                                                  .isEmpty ||
                                                              decimalPart
                                                                  .replaceAll(
                                                                    '0',
                                                                    '',
                                                                  )
                                                                  .isEmpty;

                                                          if (isDecimalZero) {
                                                            final intValue =
                                                                int.tryParse(
                                                                  integerPart,
                                                                ) ??
                                                                0;
                                                            widget
                                                                .priceController
                                                                .text = widget
                                                                .numberFormat
                                                                .format(
                                                                  intValue,
                                                                );
                                                          } else {
                                                            final formattedInteger = widget
                                                                .numberFormat
                                                                .format(
                                                                  int.tryParse(
                                                                        integerPart,
                                                                      ) ??
                                                                      0,
                                                                );
                                                            widget
                                                                    .priceController
                                                                    .text =
                                                                '$formattedInteger.$decimalPart';
                                                          }
                                                        } else {
                                                          widget
                                                                  .priceController
                                                                  .text =
                                                              confirmedValue;
                                                        }
                                                      } else {
                                                        final numValue =
                                                            double.tryParse(
                                                              confirmedValue,
                                                            );
                                                        if (numValue != null &&
                                                            numValue > 0) {
                                                          widget
                                                              .priceController
                                                              .text = widget
                                                              .numberFormat
                                                              .format(
                                                                numValue
                                                                    .toInt(),
                                                              );
                                                        } else {
                                                          widget
                                                                  .priceController
                                                                  .text =
                                                              confirmedValue;
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ).whenComplete(() async {
                                                widget.onIsTabBarVisibleChanged(
                                                  true,
                                                );
                                                await Future.delayed(
                                                  Duration(milliseconds: 400),
                                                  () {
                                                    widget.position.value = 630;
                                                    widget
                                                        .onBottomLimitPositionChanged(
                                                          510,
                                                        );
                                                    print(
                                                      'bottomLimitPosition: 510',
                                                    );
                                                  },
                                                );
                                                widget.priceFocus.unfocus();
                                              });

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    widget.priceFocus
                                                        .requestFocus();
                                                  });
                                            },
                                            readOnly: true,
                                            showCursor: true,
                                            cursorColor: Colors.green,
                                            focusNode: widget.priceFocus,
                                            style: GoogleFonts.manrope(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            controller: widget.priceController,
                                            decoration: InputDecoration(
                                              hintText: "Giá",
                                              hintStyle: GoogleFonts.manrope(
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
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final currentPrice =
                                                double.tryParse(
                                                  widget.priceController.text,
                                                ) ??
                                                0.0;
                                            final bool isAtCeiling =
                                                currentPrice >= widget.giatran;

                                            return GestureDetector(
                                              onTap: isAtCeiling
                                                  ? null
                                                  : () => widget
                                                        .onIncreamentController(
                                                          widget
                                                              .priceController,
                                                        ),
                                              child: Opacity(
                                                opacity: isAtCeiling
                                                    ? 0.4
                                                    : 1.0,
                                                child: SvgPicture.asset(
                                                  "assets/icons/plus.svg",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Column(
                                      children: [
                                        JustTheTooltip(
                                          backgroundColor: Colors.transparent,
                                          controller: widget.tooltipController,
                                          isModal: true,
                                          barrierDismissible: false,
                                          triggerMode: TooltipTriggerMode.tap,
                                          tailBaseWidth: 0,
                                          tailLength: 0,
                                          preferredDirection: AxisDirection.up,
                                          content: Transform.translate(
                                            offset: Offset(0, -4),
                                            child: Container(
                                              height: 35,
                                              width: 160,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xFF33383F),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "KL max:                   ${widget.numberFormat.format(widget.priceMaxCanBuy ?? 0)}",
                                                  style: GoogleFonts.manrope(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: SizedBox.shrink(),
                                        ),
                                        Container(
                                          width: 169.5,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: const Color(0xFF3A4247),
                                            border: Border.all(
                                              color: widget.isOverSucMua
                                                  ? Colors.red
                                                  : (widget.isVolumeFocused
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
                                                  onTap: () => widget
                                                      .onDecreamentAvalbleController(
                                                        widget.avaController,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/addbut.svg",
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextField(
                                                    onTap: () {
                                                      widget
                                                          .onIsTabBarVisibleChanged(
                                                            false,
                                                          );

                                                      widget.tooltipController
                                                          .showTooltip();

                                                      widget
                                                          .onIsTooltipVisibleChanged(
                                                            true,
                                                          );
                                                      widget
                                                          .onIsVolumeFocusedChanged(
                                                            true,
                                                          );

                                                      showModalBottomSheet(
                                                        context: context,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        barrierColor:
                                                            Colors.transparent,
                                                        builder: (_) => PercentKeyboard(
                                                          priceMaxCanBuy: widget
                                                              .priceMaxCanBuy,
                                                          onTextInput: (value) {
                                                            if ([
                                                              "LO",
                                                              "MP",
                                                              "ATO",
                                                              "ATC",
                                                            ].contains(value)) {
                                                              widget
                                                                      .avaController
                                                                      .text =
                                                                  value;
                                                              return;
                                                            }
                                                            if (![
                                                              "LO",
                                                              "MP",
                                                              "ATO",
                                                              "ATC",
                                                            ].contains(
                                                              widget
                                                                  .avaController
                                                                  .text,
                                                            )) {
                                                              if (value
                                                                  .contains(
                                                                    '.',
                                                                  )) {
                                                                final doubleValue =
                                                                    double.tryParse(
                                                                      value,
                                                                    );
                                                                if (doubleValue !=
                                                                        null &&
                                                                    doubleValue >
                                                                        0) {
                                                                  widget
                                                                          .avaController
                                                                          .text =
                                                                      value;
                                                                }
                                                              } else {
                                                                final intValue =
                                                                    int.tryParse(
                                                                      value,
                                                                    );
                                                                if (intValue !=
                                                                        null &&
                                                                    intValue >
                                                                        0) {
                                                                  widget
                                                                      .avaController
                                                                      .text = widget
                                                                      .numberFormat
                                                                      .format(
                                                                        intValue,
                                                                      );
                                                                }
                                                              }
                                                            }
                                                          },
                                                          onBackspace: () {
                                                            if (widget
                                                                .avaController
                                                                .text
                                                                .isNotEmpty) {
                                                              final currentValue =
                                                                  widget
                                                                      .avaController
                                                                      .text;
                                                              final newValue =
                                                                  currentValue
                                                                      .substring(
                                                                        0,
                                                                        currentValue.length -
                                                                            1,
                                                                      );

                                                              if (newValue
                                                                  .isEmpty) {
                                                                widget
                                                                        .avaController
                                                                        .text =
                                                                    '';
                                                                return;
                                                              }

                                                              if (newValue
                                                                  .contains(
                                                                    '.',
                                                                  )) {
                                                                final doubleValue =
                                                                    double.tryParse(
                                                                      newValue,
                                                                    );
                                                                if (doubleValue !=
                                                                        null &&
                                                                    doubleValue >
                                                                        0) {
                                                                  widget
                                                                          .avaController
                                                                          .text =
                                                                      newValue;
                                                                } else {
                                                                  widget
                                                                          .avaController
                                                                          .text =
                                                                      '';
                                                                }
                                                              } else {
                                                                final cleanValue =
                                                                    newValue
                                                                        .replaceAll(
                                                                          ',',
                                                                          '',
                                                                        );
                                                                final intValue =
                                                                    int.tryParse(
                                                                      cleanValue,
                                                                    );
                                                                if (intValue !=
                                                                        null &&
                                                                    intValue >
                                                                        0) {
                                                                  widget
                                                                      .avaController
                                                                      .text = widget
                                                                      .numberFormat
                                                                      .format(
                                                                        intValue,
                                                                      );
                                                                } else {
                                                                  widget
                                                                          .avaController
                                                                          .text =
                                                                      '';
                                                                }
                                                              }
                                                            }
                                                          },
                                                          onPercentSelected:
                                                              (percent) {
                                                                widget
                                                                    .onCalculateVolumeWithPercentages(
                                                                      percent,
                                                                    );
                                                              },
                                                          initialValue: widget
                                                              .avaController
                                                              .text,
                                                        ),
                                                      ).whenComplete(() async {
                                                        widget
                                                            .onIsTabBarVisibleChanged(
                                                              true,
                                                            );
                                                        await Future.delayed(
                                                          Duration(
                                                            milliseconds: 400,
                                                          ),
                                                          () {
                                                            widget
                                                                    .position
                                                                    .value =
                                                                630;
                                                            widget
                                                                .onBottomLimitPositionChanged(
                                                                  510,
                                                                );
                                                            print(
                                                              'bottomLimitPosition: 510',
                                                            );
                                                          },
                                                        );

                                                        widget.tooltipController
                                                            .hideTooltip();

                                                        widget
                                                            .onIsTooltipVisibleChanged(
                                                              false,
                                                            );
                                                        widget
                                                            .onIsVolumeFocusedChanged(
                                                              false,
                                                            );

                                                        widget.volumeFocus
                                                            .unfocus();
                                                      });

                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback((
                                                            _,
                                                          ) {
                                                            widget.volumeFocus
                                                                .requestFocus();
                                                          });
                                                    },
                                                    readOnly: true,
                                                    showCursor: true,
                                                    cursorColor: Colors.green,
                                                    focusNode:
                                                        widget.volumeFocus,
                                                    controller:
                                                        widget.avaController,
                                                    style: GoogleFonts.manrope(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          widget
                                                                  .avaController
                                                                  .text
                                                                  .isEmpty &&
                                                              !widget
                                                                  .isTooltipVisible
                                                          ? "Tối đa: ${widget.numberFormat.format(widget.priceMaxCanBuy ?? 0)}"
                                                          : "",
                                                      hintStyle:
                                                          GoogleFonts.manrope(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                          ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                            bottom: 12,
                                                          ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: () => widget
                                                      .onIncreamentAvalbleController(
                                                        widget.avaController,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/plus.svg",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (widget.isOverSucMua)
                                      Positioned(
                                        bottom: -17,
                                        left: -5,
                                        right: 0,
                                        child: Center(
                                          child: Text(
                                            widget.errorMessage,
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
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

                        SizedBox(height: widget.isOverLimit ? 0 : 18),
                        if (widget.isOverLimit)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 8),
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
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: widget.isTotalFocused
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
                                              widget.onIsTabBarVisibleChanged(
                                                false,
                                              );
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder: (_) => TotalKeyboard(
                                                  onTextInput: (value) {
                                                    if ([
                                                      "LO",
                                                      "MP",
                                                      "ATO",
                                                      "ATC",
                                                    ].contains(value)) {
                                                      widget
                                                              .totalController
                                                              .text =
                                                          value;
                                                      return;
                                                    }
                                                    final cleanValue = widget
                                                        .totalController
                                                        .text
                                                        .replaceAll(',', '');
                                                    final newValue =
                                                        cleanValue + value;

                                                    if (newValue.length > 11) {
                                                      return;
                                                    }
                                                    final numValue =
                                                        int.tryParse(newValue);

                                                    if (numValue != null) {
                                                      widget
                                                          .totalController
                                                          .text = widget
                                                          .numberFormat
                                                          .format(numValue);
                                                    } else {
                                                      widget
                                                              .totalController
                                                              .text =
                                                          newValue;
                                                    }
                                                  },
                                                  onBackspace: () {
                                                    final cleanValue = widget
                                                        .totalController
                                                        .text
                                                        .replaceAll(',', '');
                                                    if (cleanValue.isNotEmpty) {
                                                      final newValue =
                                                          cleanValue.substring(
                                                            0,
                                                            cleanValue.length -
                                                                1,
                                                          );
                                                      if (newValue.isNotEmpty) {
                                                        final numValue =
                                                            int.tryParse(
                                                              newValue,
                                                            );
                                                        if (numValue != null &&
                                                            numValue > 0) {
                                                          widget
                                                              .totalController
                                                              .text = widget
                                                              .numberFormat
                                                              .format(numValue);
                                                        } else {
                                                          widget
                                                                  .totalController
                                                                  .text =
                                                              newValue;
                                                        }
                                                      } else {
                                                        widget
                                                                .totalController
                                                                .text =
                                                            '';
                                                      }
                                                    }
                                                  },
                                                ),
                                              ).whenComplete(() async {
                                                widget.onIsTabBarVisibleChanged(
                                                  true,
                                                );
                                                await Future.delayed(
                                                  Duration(milliseconds: 400),
                                                  () {
                                                    widget.position.value = 630;
                                                    widget
                                                        .onBottomLimitPositionChanged(
                                                          510,
                                                        );
                                                    print(
                                                      'bottomLimitPosition: 510',
                                                    );
                                                  },
                                                );

                                                widget.totalFocus.unfocus();
                                              });

                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    widget.totalFocus
                                                        .requestFocus();
                                                  });
                                            },
                                            readOnly: true,
                                            showCursor: true,
                                            cursorColor: Colors.green,
                                            focusNode: widget.totalFocus,
                                            style: GoogleFonts.manrope(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            controller: widget.totalController,
                                            decoration: InputDecoration(
                                              hintText: "Tổng giá trị",
                                              hintStyle: GoogleFonts.manrope(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                top: 9.5,
                                                bottom: 13.5,
                                              ),
                                            ),
                                            textAlignVertical:
                                                TextAlignVertical.center,
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
                                    if (widget.onIsValid(
                                      widget.priceController,
                                      widget.avaController,
                                      widget.totalController,
                                      widget.giatran,
                                      widget.giamin,
                                      widget.sucmua,
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
                                      borderRadius: BorderRadius.circular(12),
                                      color: state.isClickedSell
                                          ? Color(0xFFF34859)
                                          : Color(0xFF1AAF74),
                                    ),
                                    child: Center(
                                      child: state.isClickedSell
                                          ? Text(
                                              "Đặt bán",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text(
                                              "Đặt mua",
                                              style: GoogleFonts.manrope(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                SvgPicture.asset("assets/icons/pen.svg"),
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
        );
      },
    );
  }
}
