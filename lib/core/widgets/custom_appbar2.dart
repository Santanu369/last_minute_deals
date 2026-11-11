import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
import 'package:lmd_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';

// Adjust these imports based on your project's AuthCubit path
// import 'package:lmd_app/blocs/auth/auth_cubit.dart';
// import 'package0:lmd_app/blocs/auth/auth_state.dart';

class CustomAppbar2 extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppbar2({super.key, this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/MainApplconn.png', height: 50.h,fit: BoxFit.contain),
            // Image.asset('assets/icons/MainAppLogo.png', height: 50.h,fit : BoxFit.contain),

            // const SizedBox(width: 8.w),

            // Push right elements to the end
            const Spacer(),

            // Dynamic User Profile Avatar using BlocBuilder
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final user = state.user;

                return Row(
                  children: [
                    // const Spacer(),
                    //Notification Icon
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                      ),
                      onPressed: () => NotificationsPage.open(context),
                    ),

                    SizedBox(height: 4.h),
                    GestureDetector(
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
                          radius: 20, // 20 radius = 40px width/height diameter
                          size: 20.r,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
