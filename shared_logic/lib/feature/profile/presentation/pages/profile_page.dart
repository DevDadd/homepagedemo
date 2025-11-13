import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_logic/core/router/go_router.dart';
import 'package:shared_logic/feature/profile/cubit/user_cubit.dart';
import 'package:shared_logic/feature/profile/cubit/user_state.dart';
import 'package:shared_logic/feature/profile/data/model/user.dart';
import 'package:shared_logic/feature/profile/presentation/widget/profile_header_delegate.dart';
import 'package:shared_logic/feature/profile/presentation/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ScrollController _scrollController;
  final double collapsedOffset = 230.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    context.read<UserCubit>().addUser(
      User(
        name: "Vladimir Putin",
        sex: "Nam",
        dob: "04-14-1992",
        idCard: "992391381",
        date: "02-02-2000",
        placeID: "Moscow",
        contactAdress: "Số 1 Phố Hàng Trống",
        city: "Hanoi",
        phone: "099931321",
        email: "putin@gmail.com",
      ),
    );
    context.read<UserCubit>().getUser();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSnap() {
    if (!_scrollController.hasClients) return;

    final current = _scrollController.position.pixels;

    final double targetCollapsed = Platform.isAndroid ? 250.0 : collapsedOffset;
    final double targetExpanded = 0.0;

    if (current >= targetCollapsed / 2) {
      _scrollController.animateTo(
        targetCollapsed,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
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

        return Scaffold(
          backgroundColor: const Color(0xFF111315),
          body: Listener(
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
                    avatarPath: "packages/shared_logic/assets/avatar.jpg.webp",
                    collapsedInfoShift: 16,
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF1A1D1F),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ProfileWidget(
                                  title: "Tên chủ TK",
                                  value: user.name,
                                ),
                                ProfileWidget(
                                  title: "Giới tính",
                                  value: user.sex,
                                ),
                                ProfileWidget(
                                  title: "Ngày sinh",
                                  value: user.dob,
                                ),
                                ProfileWidget(
                                  title: "Số CMND/CCCD/HC",
                                  value: user.idCard,
                                ),
                                ProfileWidget(
                                  title: "Ngày cấp",
                                  value: user.date,
                                ),
                                ProfileWidget(
                                  title: "Nơi cấp",
                                  value: user.placeID,
                                ),
                                ProfileWidget(
                                  title: "Địa chỉ liên hệ",
                                  value: user.contactAdress,
                                ),
                                ProfileWidget(
                                  title: "Tỉnh/Thành phố",
                                  value: user.city,
                                ),
                                ProfileWidget(
                                  title: "Điện thoại di động",
                                  value: user.phone,
                                ),
                                ProfileWidget(
                                  title: "Email",
                                  value: user.email,
                                ),
                                const SizedBox(height: 12),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "packages/shared_logic/assets/icons/pen.png",
                                        color: const Color(0xFF1AAF74),
                                      ),
                                      const SizedBox(width: 11.2),
                                      GestureDetector(
                                        onTap: () {
                                          context.push(
                                            AppRouteConstant.editProfilePage,
                                            extra: user,
                                          );
                                        },
                                        child: Text(
                                          "Thay đổi thông tin",
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1AAF74),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        (1500 -
                                collapsedOffset -
                                (Platform.isAndroid ? 150 : 200))
                            .clamp(0.0, double.infinity),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
