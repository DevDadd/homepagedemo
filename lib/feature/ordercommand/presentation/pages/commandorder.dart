import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/dottedlinepainter.dart';
import 'package:homepageintern/feature/ordercommand/presentation/widget/order_form_content.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:measure_size/measure_size.dart';

class Commandorder extends StatefulWidget {
  const Commandorder({super.key});

  @override
  State<Commandorder> createState() => _CommandorderState();
}

class _CommandorderState extends State<Commandorder>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabController1;
  late TabController _tabController2;
  String? selectedMode;
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
  String errorMessage = "";
  bool isTabBarVisible = true;
  bool isTooltipVisible = false;
  bool isVolumeKeyboardOpen = false;
  final JustTheController _tooltipController = JustTheController();
  final NumberFormat numberFormat = NumberFormat("#,##0", "en_US");
  int? priceMaxCanBuy;
  double remainHeight = 600;
  double? widgetSize1;
  double? widgetSize2;
  double? widgetSize3;
  late ValueNotifier<double> remainHeightNotifier = ValueNotifier(200);
  final List<String> hi = ["FPT", "VIC", "HPG", "VCB", "VNI", "HNX"];
  final ValueNotifier<double> _position = ValueNotifier(275);
  final double orderWidgetHeight = 500;
  final ValueNotifier<bool> isAllowScroll = ValueNotifier(true);
  final ValueNotifier<bool> isShowBuySell = ValueNotifier(true);
  final double minPosition = -270;
  final double maxPosition = 800;
  double bottomLimitPosition = 0;
  final GlobalKey orderWidgetKey = GlobalKey();
  void checkSucMua() {
    final totalText = _totalController.text.replaceAll(',', '');
    final total = int.tryParse(totalText) ?? 0;

    final volumeText = _avaController.text.replaceAll(',', '');
    final volume = double.tryParse(volumeText);

    int maxCanBuy = 0;

    if (_isOverLimit) {
      setState(() {
        isOverSucMua = (volume != null && volume > 0);
      });
      return;
    }

    if (_priceController.text.isNotEmpty) {
      maxCanBuy = priceMaxCanBuy ?? 0;
    } else {
      final double totalMoney = sucmua.toDouble();
      final double maxVolume = totalMoney / (giamin * 1000);
      maxCanBuy = maxVolume.floor();
    }

    final isVolumeOverMax = (volume != null && volume > maxCanBuy.toDouble());

    setState(() {
      isOverSucMua = total > sucmua || isVolumeOverMax;

      if (isVolumeOverMax && total <= sucmua) {
        errorMessage = "Vượt quá khối lượng tối đa";
      } else if (total > sucmua) {
        errorMessage = "Vượt quá khối lượng tối đa";
      } else {
        errorMessage = "";
      }
    });
  }

  void calculateRemainHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = 5.0;

    double size1 = widgetSize1 ?? 0;
    double size2 = widgetSize2 ?? 0;
    double size3 = widgetSize3 ?? 0;

    remainHeightNotifier.value =
        screenHeight - (appBarHeight + size1 + size2 + size3 + 200);
    if (remainHeightNotifier.value < 0) {
      remainHeightNotifier.value = 0;
    }
  }

  void checkLimit() {
    final priceText = _priceController.text.replaceAll(',', '');
    final price = double.tryParse(priceText);
    if (price != null) {
      setState(() {
        _isOverLimit =
            (price * 1000) > (giatran * 1000) ||
            (price * 1000) < (giamin * 1000);
      });
    } else {
      _isOverLimit = false;
    }
  }

  void updateGiaMax() {
    if (_isOverLimit) {
      priceMaxCanBuy = 0;
      return;
    }

    final priceText = _priceController.text.trim();
    double? price;
    if (priceText == "MP" || priceText == "ATO" || priceText == "ATC") {
      price = giatran;
    } else {
      final cleanPriceText = priceText.replaceAll(',', '');
      price = double.tryParse(cleanPriceText);
    }

    final validPrice = (price != null && price > 0) ? price : giamin;

    if (validPrice <= 0) {
      priceMaxCanBuy = 0;
      return;
    }

    final double totalMoney = sucmua.toDouble();
    final double volume = totalMoney / (validPrice * 1000);

    priceMaxCanBuy = volume.floor();
  }

  void calculate_volume_with_percentages(int percentages) {
    if (_isOverLimit || priceMaxCanBuy == 0) {
      _avaController.text = '';
      _totalValue();
      return;
    }

    final priceText = _priceController.text.replaceAll(',', '');
    final currentPrice = double.tryParse(priceText);

    final validPrice = (currentPrice != null && currentPrice > 0)
        ? (currentPrice * 1000)
        : (giamin * 1000);

    final total = sucmua * (percentages / 100);

    final volume = total / validPrice;

    int intVolume = volume.floor();
    if (priceMaxCanBuy != null && priceMaxCanBuy! > 0) {
      if (intVolume > priceMaxCanBuy!) intVolume = priceMaxCanBuy!;
    }

    final formatted = numberFormat.format(intVolume);
    _avaController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    _totalValue();
  }

  void decreamentController(TextEditingController controller) {
    if (controller == _priceController && controller.text.isEmpty) {
      controller.text = giatran.toStringAsFixed(2);
      return;
    }

    double current = double.tryParse(controller.text) ?? 0.0;
    double new_value = current - 0.1;
    if (new_value < 0) {
      new_value = 0.0;
    } else {
      controller.text = new_value.toStringAsFixed(1);
    }
  }

  void increamentController(TextEditingController controller) {
    if (controller == _priceController && controller.text.isEmpty) {
      controller.text = giamin.toStringAsFixed(2);
      return;
    }

    double current = double.tryParse(controller.text) ?? 0.0;
    double new_value = current + 0.1;
    controller.text = new_value.toStringAsFixed(1);
  }

  void increamentAvalbleController(TextEditingController controller) {
    final text = controller.text.replaceAll(',', '');
    int current = int.tryParse(text) ?? 0;

    int newValue = current + 1;

    final formatted = numberFormat.format(newValue);

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void decreamentAvalbleController(TextEditingController controller) {
    final text = controller.text.replaceAll(',', '');
    int current = int.tryParse(text) ?? 0;

    int newValue = current > 0 ? current - 1 : 0;

    if (newValue > 0) {
      final formatted = numberFormat.format(newValue);
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } else {
      controller.text = '';
    }
  }

  void decreasementController(TextEditingController controller) {
    if (controller == _priceController && controller.text.isEmpty) {
      controller.text = giatran.toStringAsFixed(2);
      return;
    }

    double current = double.tryParse(controller.text) ?? 0.0;
    double new_value = current - 0.1;
    if (new_value < 0) {
      new_value = 0.0;
    } else {
      controller.text = new_value.toStringAsFixed(1);
    }
  }

  void _totalValue() {
    String priceText = _priceController.text.replaceAll(',', '');
    String volumeText = _avaController.text.replaceAll(',', '');

    double? price;
    double? volume;

    if (_priceController.text == "MP" ||
        _priceController.text == "ATO" ||
        _priceController.text == "ATC") {
      price = giatran * 1000;
    } else {
      price = double.tryParse(priceText);
      if (price != null) {
        price = price * 1000;
      }
    }

    volume = double.tryParse(volumeText);

    print('Debug _totalValue:');
    print('priceText: $priceText, volumeText: $volumeText');
    print('price: $price, volume: $volume');

    if (price == null || volume == null) {
      print('Return early: price=$price, volume=$volume');
      return;
    }

    final total = (price * volume).floor();

    print('total: $total');

    final formatted = numberFormat.format(total);

    print('formatted: $formatted');

    if (_totalController.text != formatted) {
      _totalController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      print('Updated total to: $formatted');
    }
  }

  void findVolumeWhenKnowTotal() {
    String totalText = _totalController.text.replaceAll(',', '');
    String priceText = _priceController.text.replaceAll(',', '');

    double? price;
    double? total;

    if (_priceController.text == "MP" ||
        _priceController.text == "ATO" ||
        _priceController.text == "ATC") {
      price = giatran * 1000;
    } else {
      price = double.tryParse(priceText);
      if (price != null) {
        price = price * 1000;
      }
    }

    total = double.tryParse(totalText);

    print('Debug findVolumeWhenKnowTotal:');
    print('totalText: $totalText, priceText: $priceText');
    print('total: $total, price: $price');

    if (total == null || price == null || price == 0) {
      print('Return early: total=$total, price=$price');
      return;
    }

    final volume = total / price;
    int intVolume = volume.round();
    if (priceMaxCanBuy != null && priceMaxCanBuy! > 0) {
      if (intVolume > priceMaxCanBuy!) intVolume = priceMaxCanBuy!;
    }

    print('volume: $volume, intVolume: $intVolume');

    final volumeText = intVolume.toString();

    print('volumeText: $volumeText');

    if (_avaController.text != volumeText) {
      _avaController.value = TextEditingValue(
        text: volumeText,
        selection: TextSelection.collapsed(offset: volumeText.length),
      );
      print('Updated volume to: $volumeText');
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

  void calculateBottomLimitPosition() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _position.value = 510;
    bottomLimitPosition = 510;
  }

  @override
  void initState() {
    super.initState();
    updateGiaMax();
    _tabController2 = TabController(length: 3, vsync: this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController1 = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          orderWidgetKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        calculateBottomLimitPosition();
      }
    });
    _tabController1.addListener(() {
      if (_tabController1.indexIsChanging == false) {
        setState(() {});
      }
    });

    _priceController.addListener(() {
      print('Price changed: ${_priceController.text}');

      if (isTotalFocused) {
        return;
      }

      if (isVolumeFocused && _totalController.text.isNotEmpty) {
        print(
          'Price changed with volume focused, calling findVolumeWhenKnowTotal',
        );
        findVolumeWhenKnowTotal();
      } else if (_priceController.text.isNotEmpty &&
          _avaController.text.isNotEmpty) {
        print('Price changed, calculating total from price and volume');
        _totalValue();
      }
    });
    _priceController.addListener(checkLimit);
    _priceController.addListener(() {
      updateGiaMax();
      checkSucMua();
      setState(() {});
    });

    _avaController.addListener(() {
      setState(() {});

      print('Volume changed: ${_avaController.text}');

      if (_avaController.text.isEmpty && !isTotalFocused) {
        _totalController.text = '';
        checkSucMua();
        return;
      }

      checkSucMua();

      if (_priceController.text.isNotEmpty &&
          _avaController.text.isNotEmpty &&
          !isTotalFocused) {
        _totalValue();
      }
    });
    _totalController.addListener(checkSucMua);

    _totalController.addListener(() {
      if (_totalFocus.hasFocus) {
        final text = _totalController.text.replaceAll(',', '');
        if (text.isEmpty) return;
        final number = int.tryParse(text);
        if (number == null) return;

        final newText = numberFormat.format(number);

        if (_totalController.text != newText) {
          try {
            final selectionIndexFromEnd =
                _totalController.text.length - _totalController.selection.end;

            final newOffset = newText.length - selectionIndexFromEnd;
            final clampedOffset = newOffset.clamp(0, newText.length);

            _totalController.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: clampedOffset),
            );
          } catch (e) {
            _totalController.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          }
        }
      }
    });

    _priceFocus.addListener(() {
      setState(() {
        isPriceFocused = _priceFocus.hasFocus;
      });
    });

    _volumeFocus.addListener(() {
      print('Debug _volumeFocus listener: hasFocus=${_volumeFocus.hasFocus}');
      setState(() {
        isVolumeFocused = _volumeFocus.hasFocus;
      });
    });

    _totalFocus.addListener(() {
      setState(() {
        isTotalFocused = _totalFocus.hasFocus;
      });

      if (!_totalFocus.hasFocus && _totalController.text.isNotEmpty) {
        print('Total focus lost, calculating volume');
        findVolumeWhenKnowTotal();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabController1.dispose();
    _tabController2.dispose();
    _priceController.dispose();
    _totalController.dispose();
    _avaController.dispose();
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('remainHeight: $remainHeight');
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
        resizeToAvoidBottomInset: false,
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
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      MeasureSize(
                        onChange: (size) {
                          if (widgetSize1 != size.height) {
                            setState(() {
                              widgetSize1 = size.height;
                            });
                            print("widgetSize1 $widgetSize1");
                            calculateRemainHeight(context);
                          }
                        },
                        child: Container(
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
                                  GestureDetector(
                                    onTap: () {
                                      _priceController.text = giahientai
                                          .toStringAsFixed(2);
                                    },
                                    child: Text(
                                      giahientai.toStringAsFixed(2),
                                      style: GoogleFonts.manrope(
                                        color: const Color(0xFFF34859),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
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
                      ),
                      isTabBarVisible
                          ? SizedBox(height: 21)
                          : SizedBox(height: 0),
                      MeasureSize(
                        onChange: (size) {
                          widgetSize2 = size.height;
                          final tabBarHeight = isTabBarVisible ? 8.0 : 0.0;
                          final calculatedSize = widgetSize2! + tabBarHeight;
                          _position.value = calculatedSize + 102;
                          bottomLimitPosition = _position.value;
                        },
                        child: OrderFormContent(
                          tabController1: _tabController1,
                          priceController: _priceController,
                          totalController: _totalController,
                          avaController: _avaController,
                          priceFocus: _priceFocus,
                          volumeFocus: _volumeFocus,
                          totalFocus: _totalFocus,
                          isTabBarVisible: isTabBarVisible,
                          isPriceFocused: isPriceFocused,
                          isVolumeFocused: isVolumeFocused,
                          isTotalFocused: isTotalFocused,
                          isOverLimit: _isOverLimit,
                          isOverSucMua: isOverSucMua,
                          isTooltipVisible: isTooltipVisible,
                          errorMessage: errorMessage,
                          selectedMode: selectedMode,
                          giahientai: giahientai,
                          giatran: giatran,
                          thamchieu: thamchieu,
                          giamin: giamin,
                          sucmua: sucmua,
                          limit: limit,
                          priceMaxCanBuy: priceMaxCanBuy,
                          numberFormat: numberFormat,
                          tooltipController: _tooltipController,
                          orderWidgetKey: orderWidgetKey,
                          position: _position,
                          onBottomLimitPositionChanged: (value) {
                            bottomLimitPosition = value;
                          },
                          onSetState: () {
                            setState(() {});
                          },
                          onIsTabBarVisibleChanged: (value) {
                            setState(() {
                              isTabBarVisible = value;
                            });
                          },
                          onIsTooltipVisibleChanged: (value) {
                            setState(() {
                              isTooltipVisible = value;
                            });
                          },
                          onIsVolumeFocusedChanged: (value) {
                            setState(() {
                              isVolumeFocused = value;
                            });
                          },
                          onIncreamentController: increamentController,
                          onDecreasementController: decreasementController,
                          onIncreamentAvalbleController:
                              increamentAvalbleController,
                          onDecreamentAvalbleController:
                              decreamentAvalbleController,
                          onCalculateVolumeWithPercentages:
                              calculate_volume_with_percentages,
                          onIsValid: isValid,
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _position,
                    builder: (context, pos, _) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 100),
                        top: pos,
                        left: 0,
                        right: 0,
                        child: GestureDetector(
                          onVerticalDragUpdate: (detail) {
                            var delta = _position.value + detail.delta.dy;

                            const minPosition = 50.0;
                            if (delta < minPosition) delta = minPosition;

                            if (delta > bottomLimitPosition) {
                              delta = bottomLimitPosition;
                            }
                            _position.value = delta;
                          },

                          child: Container(
                            height: MediaQuery.of(context).size.height - 210,
                            decoration: BoxDecoration(
                              color: Color(0xFF111315),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController2,
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
                                    insets: EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  tabs: [
                                    Tab(text: "Chờ khớp"),
                                    Tab(text: "Đã khớp"),
                                    Tab(text: "Lệnh điều khiển"),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController2,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            "Nội dung Chờ khớp",
                                            style: GoogleFonts.manrope(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            "Nội dung Đã khớp",
                                            style: GoogleFonts.manrope(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: Text(
                                            "Nội dung Lệnh điều khiển",
                                            style: GoogleFonts.manrope(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
