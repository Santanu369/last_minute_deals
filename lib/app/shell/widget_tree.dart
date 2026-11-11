import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';
import 'package:lmd_app/app/shell/navbar_widget.dart';
import 'package:lmd_app/features/booking/presentation/pages/bookings_history_page.dart';
import 'package:lmd_app/features/home/presentation/pages/stay_home.dart';
import 'package:lmd_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:lmd_app/features/wishlist/presentation/pages/wishlist_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key, this.searchResult});

  final bool? searchResult;

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  // Tabs are built on first visit only, so startup fires only Home's requests.
  final Set<int> _visited = {0};
  // Bookings (1) and Saved (2) are re-created on each visit to refetch fresh data.
  final Map<int, int> _visits = {};
  int _last = 0;

  static const _tabs = <Widget Function()>[
    StayHome.new,
    BookingsHistoryPage.new,
    WishlistPage.new,
    ProfileScreen.new,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const NavbarWidget(),
      body: BlocBuilder<NavbarCubit, int>(
        builder: (context, index) {
          if (index != _last) {
            _last = index;
            _visited.add(index);
            if (index == 1 || index == 2) {
              _visits[index] = (_visits[index] ?? 0) + 1;
            }
          }
          return IndexedStack(
            index: index,
            children: [
              for (var i = 0; i < _tabs.length; i++)
                _visited.contains(i)
                    ? KeyedSubtree(
                  key: ValueKey('tab$i-${_visits[i] ?? 0}'),
                  child: _tabs[i](),
                )
                    : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}