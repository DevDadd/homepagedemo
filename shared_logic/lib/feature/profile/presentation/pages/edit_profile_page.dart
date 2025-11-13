import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_logic/feature/profile/cubit/user_cubit.dart';
import 'package:shared_logic/feature/profile/cubit/user_state.dart';
import 'package:shared_logic/feature/profile/data/model/user.dart';
import 'package:shared_logic/feature/profile/presentation/widget/edit_widget.dart';
import 'package:shared_logic/feature/profile/presentation/widget/profile_header_delegate.dart';
import 'package:shared_logic/feature/profile/presentation/widget/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  final String idCard;
  final String date;
  final String place;
  final String address;
  final String city;
  final String phone;
  final String gmail;

  const EditProfilePage({
    super.key,
    required this.idCard,
    required this.date,
    required this.place,
    required this.address,
    required this.city,
    required this.phone,
    required this.gmail,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController idCardController;
  late TextEditingController dateController;
  late TextEditingController placeController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController phoneController;
  late TextEditingController gmailController;

  late ScrollController _scrollController;

  final double collapsedOffset = 210.0;

  @override
  void initState() {
    super.initState();
    idCardController = TextEditingController(text: widget.idCard);
    dateController = TextEditingController(text: widget.date);
    placeController = TextEditingController(text: widget.place);
    addressController = TextEditingController(text: widget.address);
    cityController = TextEditingController(text: widget.city);
    phoneController = TextEditingController(text: widget.phone);
    gmailController = TextEditingController(text: widget.gmail);

    idCardController.addListener(_onFieldChanged);
    dateController.addListener(_onFieldChanged);
    placeController.addListener(_onFieldChanged);

    _scrollController = ScrollController();
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    idCardController.dispose();
    dateController.dispose();
    placeController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();
    gmailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showCupertinoDatePicker(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    if (dateController.text.isNotEmpty) {
      try {
        final parts = dateController.text.split('-');
        if (parts.length == 3) {
          selectedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateModal) => SizedBox(
          height: 350,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        "packages/shared_logic/assets/icons/delete.svg",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(brightness: Brightness.dark),
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (date) =>
                        setStateModal(() => selectedDate = date),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      dateController.text =
                          "${selectedDate.day.toString().padLeft(2, '0')}-"
                          "${selectedDate.month.toString().padLeft(2, '0')}-"
                          "${selectedDate.year}";
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF1AAF74),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSnap() {
    if (!_scrollController.hasClients) return;

    final current = _scrollController.position.pixels;
    final double targetCollapsed = collapsedOffset + 30;
    final double targetExpanded = -1;

    if (current > targetCollapsed / 2 && current < targetCollapsed) {
      _scrollController.animateTo(
        targetCollapsed,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else if (current <= targetCollapsed / 2) {
      _scrollController.animateTo(
        targetExpanded,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) return const SizedBox();

        final hasChanged =
            idCardController.text != widget.idCard ||
            dateController.text != widget.date ||
            placeController.text != widget.place;

        return Scaffold(
          backgroundColor: const Color(0xFF111315),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Listener(
              onPointerUp: (_) => _handleSnap(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ProfileHeaderDelegate(
                      maxHeight: 450,
                      minHeight: collapsedOffset,
                      name: user.name,
                      avatarPath:
                          "packages/shared_logic/assets/avatar.jpg.webp",
                      collapsedInfoShift: 18,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF1A1D1F),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                ProfileWidget(
                                  title: "Tên chủ TK",
                                  value: user.name,
                                ),
                                ProfileWidget(
                                  title: "Giới Tính",
                                  value: user.sex ?? "",
                                ),
                                ProfileWidget(
                                  title: "Ngày Sinh",
                                  value: user.dob ?? "",
                                ),
                                CustomBox(
                                  controller: idCardController,
                                  label: "Số CMND/CCCD/HC",
                                  suffix: SvgPicture.asset(
                                    "packages/shared_logic/assets/icons/delete.svg",
                                  ),
                                  onSuffixTap: () => idCardController.clear(),
                                ),
                                const SizedBox(height: 12),
                                CustomBox(
                                  controller: dateController,
                                  label: "Ngày cấp",
                                  suffix: GestureDetector(
                                    onTap: () =>
                                        _showCupertinoDatePicker(context),
                                    child: SvgPicture.asset(
                                      "packages/shared_logic/assets/icons/calender.svg",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomBox(
                                  controller: placeController,
                                  label: "Nơi cấp",
                                  suffix: SvgPicture.asset(
                                    "packages/shared_logic/assets/icons/delete.svg",
                                  ),
                                  onSuffixTap: () => placeController.clear(),
                                ),
                                if (hasChanged)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Bạn cần cung cấp ảnh để xác thực thông tin CMND/CCCD vừa thay đổi.",
                                            style: GoogleFonts.manrope(
                                              color: const Color(0xFFFF9F41),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 36,
                                              width: 77,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: const Color(
                                                  0xFF1AAF74,
                                                ).withAlpha(10),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              "packages/shared_logic/assets/icons/camera.svg",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFF1A1D1F),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomBox(
                                  controller: addressController,
                                  label: "Địa chỉ liên hệ",
                                  suffix: SvgPicture.asset(
                                    "packages/shared_logic/assets/icons/delete.svg",
                                  ),
                                  onSuffixTap: () => addressController.clear(),
                                  minLines: 1,
                                ),
                                const SizedBox(height: 12),
                                CustomBox(
                                  controller: cityController,
                                  label: "Tỉnh/Thành phố",
                                  suffix: SvgPicture.asset(
                                    "packages/shared_logic/assets/icons/delete.svg",
                                  ),
                                  onSuffixTap: () => cityController.clear(),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Điện thoại di động",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF272B30),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "+84",
                                        style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: 16,
                                        color: Colors.grey.shade600,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: "Nhập số điện thoại",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => phoneController.clear(),
                                        child: SvgPicture.asset(
                                          "packages/shared_logic/assets/icons/delete.svg",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomBox(
                                  controller: gmailController,
                                  label: "Email",
                                  suffix: SvgPicture.asset(
                                    "packages/shared_logic/assets/icons/delete.svg",
                                  ),
                                  onSuffixTap: () => gmailController.clear(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 34),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(170, 48),
                                  backgroundColor: const Color(0xFF111315),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Huỷ",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if ([
                                    idCardController,
                                    dateController,
                                    placeController,
                                    addressController,
                                    cityController,
                                    phoneController,
                                    gmailController,
                                  ].any((c) => c.text.isEmpty)) {
                                    final overlay = Overlay.of(context);
                                    final overlayEntry = OverlayEntry(
                                      builder: (context) => Positioned(
                                        top: 70,
                                        left: 20,
                                        right: 20,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.error_outline,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Vui Lòng Điền Hết Ô Trống",
                                                  style: GoogleFonts.manrope(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                    overlay.insert(overlayEntry);
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () => overlayEntry.remove(),
                                    );
                                  } else {
                                    context.read<UserCubit>().updateUser(
                                      User(
                                        name: user.name ?? "",
                                        sex: user.sex ?? "",
                                        dob: user.dob ?? "",
                                        idCard: idCardController.text,
                                        date: dateController.text,
                                        placeID: placeController.text,
                                        contactAdress: addressController.text,
                                        city: cityController.text,
                                        phone: phoneController.text,
                                        email: gmailController.text,
                                      ),
                                    );
                                    context.pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(170, 48),
                                  backgroundColor: const Color(0xFF1AAF74),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Lưu thông tin",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
