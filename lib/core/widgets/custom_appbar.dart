import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
import 'package:lmd_app/features/language/presentation/language_picker_page.dart';
import 'package:lmd_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppbar({super.key, this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
  void showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const LanguagePicker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/icons/MainApplconn.png',
              height: 50.h,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            // Language Selector
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.language, color: Colors.black, size: 24.sp),
                tooltip: 'language'.tr(),
                onPressed: () {
                  showLanguagePicker(context);
                },
              ),
            ),

            // Notification
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 25.sp,
              ),
              tooltip: 'notifications'.tr(),
              onPressed: () => NotificationsPage.open(context),
            ),

            SizedBox(width: 8.w),

            // Profile
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final user = state.user;

                return GestureDetector(
                  // Profile is a tab: switch to it so the bottom bar stays.
                  onTap: () {
                    context.read<NavbarCubit>().selectTab(3);
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: UserAvatar(
                      imageUrl: user?.profileImage,
                      name: user?.firstName ?? '',
                      radius: 20,
                      size: 20.r,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
