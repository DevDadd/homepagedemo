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
  bool isVolumeKeyboardOpen = false; // Thêm biến để track keyboard volume
  final JustTheController _tooltipController =
      JustTheController(); // Sử dụng JustTheController
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

    // Lấy volume hiện tại (bỏ dấu phẩy)
    final volumeText = _avaController.text.replaceAll(',', '');
    final volume = double.tryParse(volumeText);

    // Tính maxCanBuy dựa trên price hiện tại hoặc giá tối thiểu
    int maxCanBuy = 0;

    // Nếu price vượt quá giới hạn, không cho phép nhập volume
    if (_isOverLimit) {
      setState(() {
        isOverSucMua = (volume != null && volume > 0);
      });
      return;
    }

    if (_priceController.text.isNotEmpty) {
      // Nếu có price, dùng maxCanBuy từ price
      maxCanBuy = priceMaxCanBuy ?? 0;
    } else {
      // Nếu chưa có price, dùng giá tối thiểu để tính maxCanBuy
      final double totalMoney = sucmua.toDouble();
      final double maxVolume = totalMoney / (giamin * 1000);
      maxCanBuy = maxVolume.floor();
    }

    // Kiểm tra volume vượt quá maxCanBuy HOẶC total vượt quá sucmua
    final isVolumeOverMax = (volume != null && volume > maxCanBuy.toDouble());

    setState(() {
      isOverSucMua = total > sucmua || isVolumeOverMax;

      // Set error message phù hợp
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
    final appBarHeight = 5.0; // toolbarHeight từ AppBar

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
    // Bỏ dấu phẩy phân cách hàng nghìn trước khi parse
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
    // Nếu price vượt quá giới hạn, set priceMaxCanBuy về 0
    if (_isOverLimit) {
      priceMaxCanBuy = 0;
      return;
    }

    final priceText = _priceController.text.trim();
    double? price;
    if (priceText == "MP" || priceText == "ATO" || priceText == "ATC") {
      price = giatran;
    } else {
      // Bỏ dấu phẩy phân cách hàng nghìn trước khi parse
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
    // Nếu price vượt quá giới hạn, set volume về rỗng
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
    // Nếu price rỗng, set giá trần
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
    // Nếu price rỗng, set giá sàn
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
      // Nếu <= 0 thì set về rỗng
      controller.text = '';
    }
  }

  void decreasementController(TextEditingController controller) {
    // Nếu price rỗng, set giá trần
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
    // Lấy text từ controller, loại bỏ dấu phẩy phân cách hàng nghìn
    String priceText = _priceController.text.replaceAll(',', '');
    String volumeText = _avaController.text.replaceAll(
      ',',
      '',
    ); // Volume cũng có dấu phẩy

    double? price;
    double? volume;

    // Nếu người dùng chọn mode đặc biệt thì dùng giá trần
    if (_priceController.text == "MP" ||
        _priceController.text == "ATO" ||
        _priceController.text == "ATC") {
      price = giatran * 1000; // giatran là double, nhân với 1000
    } else {
      // Parse chuỗi sang số
      price = double.tryParse(priceText);
      if (price != null) {
        price = price * 1000; // Nhân với 1000 để tính đúng
      }
    }

    volume = double.tryParse(volumeText);

    // Debug: in ra console để kiểm tra
    print('Debug _totalValue:');
    print('priceText: $priceText, volumeText: $volumeText');
    print('price: $price, volume: $volume');

    if (price == null || volume == null) {
      print('Return early: price=$price, volume=$volume');
      return;
    }

    // Tính tổng giá trị
    final total = (price * volume).floor();

    print('total: $total');

    // Format lại theo định dạng số
    final formatted = numberFormat.format(total);

    print('formatted: $formatted');

    // Chỉ cập nhật nếu khác giá trị hiện tại
    if (_totalController.text != formatted) {
      _totalController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      print('Updated total to: $formatted');
    }
  }

  void findVolumeWhenKnowTotal() {
    // Xóa dấu phẩy phân cách hàng nghìn
    String totalText = _totalController.text.replaceAll(',', '');
    String priceText = _priceController.text.replaceAll(',', '');

    double? price;
    double? total;

    // Nếu là mode đặc biệt thì dùng giá trần
    if (_priceController.text == "MP" ||
        _priceController.text == "ATO" ||
        _priceController.text == "ATC") {
      price = giatran * 1000; // giatran là double, nhân với 1000
    } else {
      price = double.tryParse(priceText);
      if (price != null) {
        price = price * 1000; // Nhân với 1000 để tính đúng
      }
    }

    total = double.tryParse(totalText);

    // Debug: in ra console để kiểm tra
    print('Debug findVolumeWhenKnowTotal:');
    print('totalText: $totalText, priceText: $priceText');
    print('total: $total, price: $price');

    // Tránh chia cho 0 hoặc lỗi parse
    if (total == null || price == null || price == 0) {
      print('Return early: total=$total, price=$price');
      return;
    }

    // Tính khối lượng
    final volume = total / price;
    int intVolume = volume.round();
    if (priceMaxCanBuy != null && priceMaxCanBuy! > 0) {
      if (intVolume > priceMaxCanBuy!) intVolume = priceMaxCanBuy!;
    }

    print('volume: $volume, intVolume: $intVolume');

    // Không format volume, chỉ giữ nguyên số
    final volumeText = intVolume.toString();

    print('volumeText: $volumeText');

    // Chỉ cập nhật nếu khác hiện tại
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
    _position.value = 500;
    bottomLimitPosition = 500;
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
        final size = renderBox.size;
        calculateBottomLimitPosition();
      }
    });
    _tabController1.addListener(() {
      if (_tabController1.indexIsChanging == false) {
        setState(() {});
      }
    });

    // 🧮 Chỉ tính total khi cả price và volume đều có giá trị
    _priceController.addListener(() {
      print('Price changed: ${_priceController.text}');

      // Không tính gì khi đang focus vào total field (người dùng đang nhập total thủ công)
      if (isTotalFocused) {
        return;
      }

      // Nếu đang focus vào volume field VÀ có total, tính lại volume từ price và total
      if (isVolumeFocused && _totalController.text.isNotEmpty) {
        print(
          'Price changed with volume focused, calling findVolumeWhenKnowTotal',
        );
        findVolumeWhenKnowTotal();
      }
      // Nếu có cả price và volume (bất kể focus vào đâu), tính total
      else if (_priceController.text.isNotEmpty &&
          _avaController.text.isNotEmpty) {
        print('Price changed, calculating total from price and volume');
        _totalValue();
      }
    });
    _priceController.addListener(checkLimit);
    _priceController.addListener(() {
      updateGiaMax();
      checkSucMua(); // Kiểm tra lại volume khi price thay đổi
      setState(() {});
    });

    // 🧮 Volume không được format, chỉ tính total khi cả price và volume đều có giá trị
    _avaController.addListener(() {
      // Update UI khi text thay đổi
      setState(() {});

      print('Volume changed: ${_avaController.text}');

      // Nếu volume rỗng thì set total về rỗng
      if (_avaController.text.isEmpty && !isTotalFocused) {
        _totalController.text = '';
        checkSucMua();
        return;
      }

      // Kiểm tra volume có vượt quá maxCanBuy
      checkSucMua();

      // Chỉ tính total khi cả price và volume đều có giá trị
      // Nhưng không tính nếu đang focus vào total field
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

            // Đảm bảo offset hợp lệ
            final newOffset = newText.length - selectionIndexFromEnd;
            final clampedOffset = newOffset.clamp(0, newText.length);

            _totalController.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: clampedOffset),
            );
          } catch (e) {
            // Nếu có lỗi, chỉ set text không set selection
            _totalController.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          }
        }

        // Không tính volume khi đang focus vào total
        // Volume sẽ được tính khi không focus vào total nữa
      }
    });

    // 🎯 Theo dõi focus cho 3 ô nhập
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
    _tooltipController.dispose(); // Dispose JustTheController
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
                          //setState(() {
                          widgetSize2 = size.height;
                          _position.value = widgetSize2! + 100;
                          bottomLimitPosition = _position.value;
                          //});
                        },
                        child: Container(
                          key: orderWidgetKey,
                          width: double.infinity,
                          decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: ClipRRect(
                                  child: SizedBox(
                                    height: isTabBarVisible ? 50 : 0,
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
                                        unselectedLabelStyle:
                                            GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF6F767E),
                                              fontSize: 12,
                                            ),
                                        indicator: UnderlineTabIndicator(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                              color:
                                                                  Color(
                                                                    0xFF1AAF74,
                                                                  ).withOpacity(
                                                                    0.3,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                .text = giahientai
                                                                .toStringAsFixed(
                                                                  2,
                                                                );
                                                          },
                                                          child: Text(
                                                            giahientai
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
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
                                                                borderRadius: BorderRadius.only(
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
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 14,
                                                            ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                .text = thamchieu
                                                                .toStringAsFixed(
                                                                  2,
                                                                );
                                                          },
                                                          child: Text(
                                                            thamchieu
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
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
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "10.000",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                    .text =
                                                                "94.10";
                                                          },
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
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                    .text =
                                                                "94.40";
                                                          },
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
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "15,000",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                    .text =
                                                                "94.00";
                                                          },
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
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            _priceController
                                                                    .text =
                                                                "94.50";
                                                          },
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
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "20,000",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                        .read<
                                                          OrdercommandCubit
                                                        >()
                                                        .clickBuyButton();
                                                  },
                                                  child: ClipPath(
                                                    clipper: MuaButtonClipper(),
                                                    child: Container(
                                                      width: 84.75,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            state.isClickedSell
                                                            ? Color(0xFF3A4247)
                                                            : Color(
                                                                0xFF1AAF74,
                                                              ).withOpacity(
                                                                0.3,
                                                              ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Mua",
                                                          style: GoogleFonts.manrope(
                                                            fontWeight:
                                                                state
                                                                    .isClickedSell
                                                                ? FontWeight
                                                                      .w500
                                                                : FontWeight
                                                                      .w700,
                                                            fontSize: 14,
                                                            color:
                                                                state
                                                                    .isClickedSell
                                                                ? Color(
                                                                    0xFFC4C4C4,
                                                                  )
                                                                : Color(
                                                                    0xFF1AAF74,
                                                                  ),
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
                                                  clipper:
                                                      SellButtonFlippedClipper(),
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
                                                              state
                                                                  .isClickedSell
                                                              ? FontWeight.w700
                                                              : FontWeight.w500,
                                                          fontSize: 14,
                                                          color:
                                                              state
                                                                  .isClickedSell
                                                              ? Color(
                                                                  0xFFF34859,
                                                                )
                                                              : Color(
                                                                  0xFFC4C4C4,
                                                                ),
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                            style:
                                                                GoogleFonts.manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xFF6F767E,
                                                                  ),
                                                                ),
                                                          )
                                                        : Text(
                                                            "Sức mua:",
                                                            style:
                                                                GoogleFonts.manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                    0xFF6F767E,
                                                                  ),
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
                                                        painter:
                                                            DottedLinePainter(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  state.isClickedSell
                                                      ? limit.toString()
                                                      : numberFormat
                                                            .format(sucmua)
                                                            .toString(),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    color: const Color(
                                                      0xFF3A4247,
                                                    ),
                                                    border: Border.all(
                                                      color: _isOverLimit
                                                          ? Colors.red
                                                          : (isPriceFocused
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
                                                        Builder(
                                                          builder: (context) {
                                                            final currentPrice =
                                                                double.tryParse(
                                                                  _priceController
                                                                      .text,
                                                                ) ??
                                                                0.0;
                                                            final bool
                                                            isAtFloor =
                                                                currentPrice <=
                                                                giamin;

                                                            return GestureDetector(
                                                              onTap: isAtFloor
                                                                  ? null
                                                                  : () => decreasementController(
                                                                      _priceController,
                                                                    ),
                                                              child: Opacity(
                                                                opacity:
                                                                    isAtFloor
                                                                    ? 0.4
                                                                    : 1.0,
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
                                                              setState(
                                                                () =>
                                                                    isTabBarVisible =
                                                                        false,
                                                              );
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                isScrollControlled:
                                                                    true,
                                                                useRootNavigator:
                                                                    true,
                                                                barrierColor: Colors
                                                                    .transparent,
                                                                enableDrag:
                                                                    false,
                                                                builder: (_) => GestureDetector(
                                                                  behavior:
                                                                      HitTestBehavior
                                                                          .deferToChild,
                                                                  child: CustomKeyboard(
                                                                    giaTran:
                                                                        giatran,
                                                                    selectedMode:
                                                                        selectedMode,
                                                                    initialValue: _priceController
                                                                        .text
                                                                        .replaceAll(
                                                                          ',',
                                                                          '',
                                                                        ), // Bỏ dấu phẩy để truyền vào keyboard
                                                                    onModeChanged: (mode) {
                                                                      setState(() {
                                                                        selectedMode =
                                                                            mode;
                                                                      });
                                                                    },
                                                                    onTextInput: (value) {
                                                                      setState(() {
                                                                        // Nếu có dấu chấm (số thập phân), format với dấu phẩy và giữ 2 chữ số
                                                                        if (value
                                                                            .contains(
                                                                              '.',
                                                                            )) {
                                                                          final numValue = double.tryParse(
                                                                            value,
                                                                          );
                                                                          if (numValue !=
                                                                              null) {
                                                                            final parts = value.split(
                                                                              '.',
                                                                            );
                                                                            final integerPart = parts[0].replaceAll(
                                                                              ',',
                                                                              '',
                                                                            );
                                                                            final decimalPart =
                                                                                parts.length >
                                                                                    1
                                                                                ? parts[1]
                                                                                : '';
                                                                            final formattedInteger = numberFormat.format(
                                                                              int.tryParse(
                                                                                    integerPart,
                                                                                  ) ??
                                                                                  0,
                                                                            );
                                                                            _priceController.text =
                                                                                '$formattedInteger.$decimalPart';
                                                                          } else {
                                                                            _priceController.text =
                                                                                value;
                                                                          }
                                                                        } else {
                                                                          // Format giá trị không có số thập phân
                                                                          final numValue = double.tryParse(
                                                                            value,
                                                                          );
                                                                          if (numValue !=
                                                                                  null &&
                                                                              numValue >
                                                                                  0) {
                                                                            _priceController.text = numberFormat.format(
                                                                              numValue.toInt(),
                                                                            );
                                                                          } else {
                                                                            _priceController.text =
                                                                                value;
                                                                          }
                                                                        }
                                                                        _priceController
                                                                            .selection = TextSelection.fromPosition(
                                                                          TextPosition(
                                                                            offset:
                                                                                _priceController.text.length,
                                                                          ),
                                                                        );
                                                                      });
                                                                    },

                                                                    onBackspace: () {
                                                                      // Keyboard sẽ xử lý backspace trong nội bộ
                                                                      // Chỉ cần update controller dựa trên giá trị từ keyboard
                                                                    },
                                                                    onConfirmed:
                                                                        (
                                                                          confirmedValue,
                                                                        ) {
                                                                          setState(() {
                                                                            // Nếu có dấu chấm (số thập phân), format với dấu phẩy và giữ 2 chữ số
                                                                            if (confirmedValue.contains(
                                                                              '.',
                                                                            )) {
                                                                              final numValue = double.tryParse(
                                                                                confirmedValue,
                                                                              );
                                                                              if (numValue !=
                                                                                      null &&
                                                                                  numValue >
                                                                                      0) {
                                                                                final parts = confirmedValue.split(
                                                                                  '.',
                                                                                );
                                                                                final integerPart = parts[0].replaceAll(
                                                                                  ',',
                                                                                  '',
                                                                                );
                                                                                final decimalPart =
                                                                                    parts.length >
                                                                                        1
                                                                                    ? parts[1]
                                                                                    : '';

                                                                                // Nếu decimalPart rỗng hoặc toàn số 0, bỏ dấu chấm
                                                                                final isDecimalZero =
                                                                                    decimalPart.isEmpty ||
                                                                                    decimalPart
                                                                                        .replaceAll(
                                                                                          '0',
                                                                                          '',
                                                                                        )
                                                                                        .isEmpty;

                                                                                if (isDecimalZero) {
                                                                                  // Bỏ dấu chấm, format như số nguyên
                                                                                  final intValue =
                                                                                      int.tryParse(
                                                                                        integerPart,
                                                                                      ) ??
                                                                                      0;
                                                                                  _priceController.text = numberFormat.format(
                                                                                    intValue,
                                                                                  );
                                                                                } else {
                                                                                  final formattedInteger = numberFormat.format(
                                                                                    int.tryParse(
                                                                                          integerPart,
                                                                                        ) ??
                                                                                        0,
                                                                                  );
                                                                                  _priceController.text = '$formattedInteger.$decimalPart';
                                                                                }
                                                                              } else {
                                                                                _priceController.text = confirmedValue;
                                                                              }
                                                                            } else {
                                                                              // Format giá trị không có số thập phân
                                                                              final numValue = double.tryParse(
                                                                                confirmedValue,
                                                                              );
                                                                              if (numValue !=
                                                                                      null &&
                                                                                  numValue >
                                                                                      0) {
                                                                                _priceController.text = numberFormat.format(
                                                                                  numValue.toInt(),
                                                                                );
                                                                              } else {
                                                                                _priceController.text = confirmedValue;
                                                                              }
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

                                                              WidgetsBinding
                                                                  .instance
                                                                  .addPostFrameCallback((
                                                                    _,
                                                                  ) {
                                                                    _priceFocus
                                                                        .requestFocus();
                                                                  });
                                                            },
                                                            readOnly: true,
                                                            showCursor: true,
                                                            cursorColor:
                                                                Colors.green,
                                                            focusNode:
                                                                _priceFocus,
                                                            style:
                                                                GoogleFonts.manrope(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                            controller:
                                                                _priceController,
                                                            decoration: InputDecoration(
                                                              hintText: "Giá",
                                                              hintStyle:
                                                                  GoogleFonts.manrope(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  const EdgeInsets.only(
                                                                    top: 11,
                                                                    bottom: 12,
                                                                  ),
                                                            ),
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Builder(
                                                          builder: (context) {
                                                            final currentPrice =
                                                                double.tryParse(
                                                                  _priceController
                                                                      .text,
                                                                ) ??
                                                                0.0;
                                                            final bool
                                                            isAtCeiling =
                                                                currentPrice >=
                                                                giatran;

                                                            return GestureDetector(
                                                              onTap: isAtCeiling
                                                                  ? null
                                                                  : () => increamentController(
                                                                      _priceController,
                                                                    ),
                                                              child: Opacity(
                                                                opacity:
                                                                    isAtCeiling
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

                                                // Ô khối lượng (volume) + cảnh báo
                                                // Khai báo global key ở trên cùng của State
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        JustTheTooltip(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          controller:
                                                              _tooltipController,
                                                          isModal: true,
                                                          barrierDismissible:
                                                              false,
                                                          triggerMode:
                                                              TooltipTriggerMode
                                                                  .tap,
                                                          tailBaseWidth: 0,
                                                          tailLength: 0,
                                                          preferredDirection:
                                                              AxisDirection.up,
                                                          content: Transform.translate(
                                                            offset: Offset(
                                                              0,
                                                              -4,
                                                            ),
                                                            child: Container(
                                                              height: 35,
                                                              width: 160,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    color: Color(
                                                                      0xFF33383F,
                                                                    ),
                                                                  ),
                                                              child: Center(
                                                                child: Text(
                                                                  "KL max:                   ${numberFormat.format(priceMaxCanBuy ?? 0)}",
                                                                  style: GoogleFonts.manrope(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          child:
                                                              SizedBox.shrink(),
                                                        ),
                                                        Container(
                                                          width: 169.5,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            color: const Color(
                                                              0xFF3A4247,
                                                            ),
                                                            border: Border.all(
                                                              color:
                                                                  isOverSucMua
                                                                  ? Colors.red
                                                                  : (isVolumeFocused
                                                                        ? Colors
                                                                              .green
                                                                        : Colors
                                                                              .transparent),
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
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
                                                                      setState(() {
                                                                        isTabBarVisible =
                                                                            false;
                                                                      });

                                                                      // Hiển thị tooltip
                                                                      _tooltipController
                                                                          .showTooltip();

                                                                      setState(() {
                                                                        isTooltipVisible =
                                                                            true;
                                                                        isVolumeFocused =
                                                                            true;
                                                                      });

                                                                      showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        isScrollControlled:
                                                                            true,
                                                                        barrierColor:
                                                                            Colors.transparent,
                                                                        builder: (_) => PercentKeyboard(
                                                                          priceMaxCanBuy:
                                                                              priceMaxCanBuy,
                                                                          onTextInput:
                                                                              (
                                                                                value,
                                                                              ) {
                                                                                if ([
                                                                                  "LO",
                                                                                  "MP",
                                                                                  "ATO",
                                                                                  "ATC",
                                                                                ].contains(
                                                                                  value,
                                                                                )) {
                                                                                  _avaController.text = value;
                                                                                  return;
                                                                                }
                                                                                if (![
                                                                                  "LO",
                                                                                  "MP",
                                                                                  "ATO",
                                                                                  "ATC",
                                                                                ].contains(
                                                                                  _avaController.text,
                                                                                )) {
                                                                                  // Nhận toàn bộ giá trị từ keyboard và xử lý
                                                                                  // Kiểm tra xem có dấu chấm không
                                                                                  if (value.contains(
                                                                                    '.',
                                                                                  )) {
                                                                                    // Nếu có dấu chấm, parse thành double và giữ nguyên dấu chấm
                                                                                    final doubleValue = double.tryParse(
                                                                                      value,
                                                                                    );
                                                                                    if (doubleValue !=
                                                                                            null &&
                                                                                        doubleValue >
                                                                                            0) {
                                                                                      _avaController.text = value;
                                                                                    }
                                                                                  } else {
                                                                                    // Nếu không có dấu chấm, parse thành int và format với dấu phẩy
                                                                                    final intValue = int.tryParse(
                                                                                      value,
                                                                                    );
                                                                                    if (intValue !=
                                                                                            null &&
                                                                                        intValue >
                                                                                            0) {
                                                                                      _avaController.text = numberFormat.format(
                                                                                        intValue,
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                  // Nếu <= 0 thì không set gì cả, giữ nguyên giá trị hiện tại
                                                                                }
                                                                              },
                                                                          onBackspace: () {
                                                                            if (_avaController.text.isNotEmpty) {
                                                                              // Xóa 1 ký tự
                                                                              final currentValue = _avaController.text;
                                                                              final newValue = currentValue.substring(
                                                                                0,
                                                                                currentValue.length -
                                                                                    1,
                                                                              );

                                                                              if (newValue.isEmpty) {
                                                                                _avaController.text = '';
                                                                                return;
                                                                              }

                                                                              // Kiểm tra xem có dấu chấm không
                                                                              if (newValue.contains(
                                                                                '.',
                                                                              )) {
                                                                                // Nếu có dấu chấm, giữ nguyên
                                                                                final doubleValue = double.tryParse(
                                                                                  newValue,
                                                                                );
                                                                                if (doubleValue !=
                                                                                        null &&
                                                                                    doubleValue >
                                                                                        0) {
                                                                                  _avaController.text = newValue;
                                                                                } else {
                                                                                  _avaController.text = '';
                                                                                }
                                                                              } else {
                                                                                // Nếu không có dấu chấm, parse thành int và format
                                                                                final cleanValue = newValue.replaceAll(
                                                                                  ',',
                                                                                  '',
                                                                                );
                                                                                final intValue = int.tryParse(
                                                                                  cleanValue,
                                                                                );
                                                                                if (intValue !=
                                                                                        null &&
                                                                                    intValue >
                                                                                        0) {
                                                                                  _avaController.text = numberFormat.format(
                                                                                    intValue,
                                                                                  );
                                                                                } else {
                                                                                  _avaController.text = '';
                                                                                }
                                                                              }
                                                                            }
                                                                          },
                                                                          onPercentSelected:
                                                                              (
                                                                                percent,
                                                                              ) {
                                                                                calculate_volume_with_percentages(
                                                                                  percent,
                                                                                );
                                                                              },
                                                                          initialValue:
                                                                              _avaController.text,
                                                                        ),
                                                                      ).whenComplete(() {
                                                                        setState(() {
                                                                          isTabBarVisible =
                                                                              true;
                                                                        });

                                                                        _tooltipController
                                                                            .hideTooltip();

                                                                        setState(() {
                                                                          isTooltipVisible =
                                                                              false;
                                                                          isVolumeFocused =
                                                                              false;
                                                                        });

                                                                        _volumeFocus
                                                                            .unfocus();
                                                                      });

                                                                      WidgetsBinding
                                                                          .instance
                                                                          .addPostFrameCallback((
                                                                            _,
                                                                          ) {
                                                                            _volumeFocus.requestFocus();
                                                                          });
                                                                    },
                                                                    readOnly:
                                                                        true,
                                                                    showCursor:
                                                                        true,
                                                                    cursorColor:
                                                                        Colors
                                                                            .green,
                                                                    focusNode:
                                                                        _volumeFocus,
                                                                    controller:
                                                                        _avaController,
                                                                    style: GoogleFonts.manrope(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      hintText:
                                                                          _avaController.text.isEmpty &&
                                                                              !isTooltipVisible
                                                                          ? "Tối đa: ${numberFormat.format(priceMaxCanBuy ?? 0)}"
                                                                          : "",
                                                                      hintStyle: GoogleFonts.manrope(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      border: InputBorder
                                                                          .none,
                                                                      contentPadding:
                                                                          EdgeInsets.only(
                                                                            bottom:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
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
                                                      ],
                                                    ),

                                                    if (isOverSucMua)
                                                      Positioned(
                                                        bottom: -17,
                                                        left: -5,
                                                        right: 0,
                                                        child: Center(
                                                          child: Text(
                                                            errorMessage,
                                                            style:
                                                                GoogleFonts.manrope(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .red,
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
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 169.5,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                              setState(() {
                                                                isTabBarVisible =
                                                                    false;
                                                              });
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                isScrollControlled:
                                                                    true,
                                                                barrierColor: Colors
                                                                    .transparent,
                                                                builder: (_) => TotalKeyboard(
                                                                  onTextInput: (value) {
                                                                    if ([
                                                                      "LO",
                                                                      "MP",
                                                                      "ATO",
                                                                      "ATC",
                                                                    ].contains(
                                                                      value,
                                                                    )) {
                                                                      _totalController
                                                                              .text =
                                                                          value;
                                                                      return;
                                                                    }

                                                                    // Lấy giá trị hiện tại không có dấu phẩy
                                                                    final cleanValue =
                                                                        _totalController
                                                                            .text
                                                                            .replaceAll(
                                                                              ',',
                                                                              '',
                                                                            );
                                                                    final newValue =
                                                                        cleanValue +
                                                                        value;

                                                                    // Giới hạn tối đa 11 chữ số
                                                                    if (newValue
                                                                            .length >
                                                                        11) {
                                                                      return;
                                                                    }
                                                                    final numValue =
                                                                        int.tryParse(
                                                                          newValue,
                                                                        );

                                                                    if (numValue !=
                                                                        null) {
                                                                      _totalController
                                                                          .text = numberFormat
                                                                          .format(
                                                                            numValue,
                                                                          );
                                                                    } else {
                                                                      _totalController
                                                                              .text =
                                                                          newValue;
                                                                    }
                                                                  },
                                                                  onBackspace: () {
                                                                    // Bỏ dấu phẩy, xóa 1 ký tự, format lại
                                                                    final cleanValue =
                                                                        _totalController
                                                                            .text
                                                                            .replaceAll(
                                                                              ',',
                                                                              '',
                                                                            );
                                                                    if (cleanValue
                                                                        .isNotEmpty) {
                                                                      final newValue =
                                                                          cleanValue.substring(
                                                                            0,
                                                                            cleanValue.length -
                                                                                1,
                                                                          );
                                                                      if (newValue
                                                                          .isNotEmpty) {
                                                                        final numValue =
                                                                            int.tryParse(
                                                                              newValue,
                                                                            );
                                                                        if (numValue !=
                                                                                null &&
                                                                            numValue >
                                                                                0) {
                                                                          _totalController
                                                                              .text = numberFormat.format(
                                                                            numValue,
                                                                          );
                                                                        } else {
                                                                          _totalController.text =
                                                                              newValue;
                                                                        }
                                                                      } else {
                                                                        _totalController.text =
                                                                            '';
                                                                      }
                                                                    }
                                                                  },
                                                                ),
                                                              ).whenComplete(() {
                                                                setState(
                                                                  () =>
                                                                      isTabBarVisible =
                                                                          true,
                                                                );
                                                                _totalFocus
                                                                    .unfocus();
                                                              });

                                                              WidgetsBinding
                                                                  .instance
                                                                  .addPostFrameCallback((
                                                                    _,
                                                                  ) {
                                                                    _totalFocus
                                                                        .requestFocus();
                                                                  });
                                                            },
                                                            readOnly: true,
                                                            showCursor: true,
                                                            cursorColor:
                                                                Colors.green,
                                                            focusNode:
                                                                _totalFocus,
                                                            style:
                                                                GoogleFonts.manrope(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                            controller:
                                                                _totalController,
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  "Tổng giá trị",
                                                              hintStyle:
                                                                  GoogleFonts.manrope(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                    top: 9.5,
                                                                    bottom:
                                                                        13.5,
                                                                  ),
                                                            ),
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            textAlign: TextAlign
                                                                .center,
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
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Đặt mua",
                                                              style: GoogleFonts.manrope(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
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

                            // 👇 Giới hạn trên (kéo lên tối đa)
                            const minPosition =
                                50.0; // ví dụ: không kéo lên quá 100px từ đỉnh
                            if (delta < minPosition) delta = minPosition;

                            // 👇 Giới hạn dưới (kéo xuống tối đa)
                            if (delta > bottomLimitPosition)
                              delta = bottomLimitPosition;

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
                                      // Tab 1: Chờ khớp
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
                                      // Tab 2: Đã khớp
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
                                      // Tab 3: Lệnh điều khiển
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
