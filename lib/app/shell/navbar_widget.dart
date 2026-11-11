import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  static const _icons = [
    Icons.home_outlined,
    Icons.calendar_today_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];
  static const _selectedIcons = [
    Icons.home,
    Icons.calendar_today,
    Icons.favorite,
    Icons.person,
  ];
  static const _labels = ['Home', 'Bookings', 'Saved', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: DS.maxWidth),
        child: Container(
          height: 72.h + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: const BoxDecoration(
            color: DS.card,
            border: Border(top: BorderSide(color: DS.borderLight, width: 1)),
          ),
          child: BlocBuilder<NavbarCubit, int>(
            builder: (context, currentIndex) => Row(
              children: List.generate(_labels.length, (i) {
                final active = currentIndex == i;
                final color = active ? DS.primaryBlue : DS.textTertiary;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      context.read<NavbarCubit>().selectTab(i);
                      // Sub-pages pushed over the root: pop so the tab switch is visible.
                      final route = ModalRoute.of(context);
                      if (route != null && !route.isFirst) {
                        Navigator.of(context).popUntil((r) => r.isFirst);
                      }
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          active ? _selectedIcons[i] : _icons[i],
                          color: color,
                          size: 24.r,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _labels[i],
                          style: TextStyle(
                            fontFamily: DS.fontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}