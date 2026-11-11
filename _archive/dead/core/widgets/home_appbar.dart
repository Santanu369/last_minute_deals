import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
import 'package:lmd_app/features/profile/presentation/pages/profile_screen.dart';

class HomeAppbar extends StatefulWidget {
  const HomeAppbar({super.key});

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  String currentLocation = '';
  late final HomeCubit _homeCubit;
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> loadNearbyListings1() async {
    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (!mounted) return;

    final place = placemarks.first;

    setState(() {
      currentLocation = '${place.locality}, ${place.country}';
    });

    if (!mounted) return;

    _homeCubit.loadSearchedListings(
      lat: 18.5204,
      lng: 73.8567,
    ); //Temp location values of pune.

    // context.read<HomeCubit>().loadSearchedListings(
    //   lat: position.latitude,
    //   lng: position.longitude,
    // );
  }

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();
    // loadNearbyListings();
    loadNearbyListings1();
    // _homeCubit.loadListings();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit cubit) => cubit.state.user);
    return AppBar(
      automaticallyImplyLeading: false,

      title: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Last Minutes Deal',
            style: TextStyle(
              color: Color(0xff4D49D9),
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: .start,
            children: [
              Icon(Icons.location_pin, size: 10.r, color: Color(0xffA5A5A5)),
              // Text(
              //   "Mumbai, India",
              //   style: TextStyle(fontSize: 10.sp, color: Color(0xffA5A5A5)),
              // ),
              Text(
                currentLocation.isEmpty ? 'Loading...' : currentLocation,
                style: TextStyle(fontSize: 10.sp, color: Color(0xffA5A5A5)),
              ),
            ],
          ),
        ],
      ),

      actions: [
        IconButton(
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
        ),
      ],
    );
  }
}
