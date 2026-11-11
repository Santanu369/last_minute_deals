import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
// import 'package:flutter_lmd_5/config/assets/app_images.dart';
// import 'package:flutter_lmd_5/config/assets/basic_text_style.dart';
// import 'package:lmd_app/config/assets/app_images.dart';
import 'package:lmd_app/core/theme/basic_text_style.dart';
import 'package:lmd_app/features/auth/data/models/user_model.dart';
import 'package:lmd_app/features/profile/presentation/pages/profile_screen.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppbar({
    super.key,
    this.title,
    this.user,
    this.color,
    this.isActions = true,
    this.isLeading = true,
    this.centerTitle = false,
  });

  final String? title;
  final UserModel? user;
  final Color? color;
  final bool? isActions;
  final bool? isLeading;
  final bool? centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffF8F9FC),
      centerTitle: centerTitle,
      leading: isLeading == true
          ? InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: color ?? const Color(0xff4D49D9),
              ),
            )
          : null,
      // titleSpacing: 0,
      title: BasicTextStyle(
        title: title ?? 'Last Minutes Deal'.toUpperCase(),
        weight: FontWeight.w800,
        size: 20.0.r,
        spacing: -1,
        height: 1.4,
        color: color ?? Color(0xff4D49D9),
      ),
      actions: [
        isActions == true
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },

                icon: UserAvatar(
                  imageUrl: user?.profileImage,
                  name: user?.firstName ?? '',
                  radius: 16,
                ),
              )
            : Container(),
      ],
    );
  }
}
