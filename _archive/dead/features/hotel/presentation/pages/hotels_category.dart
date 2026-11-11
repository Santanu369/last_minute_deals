
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_state.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_state.dart';
import 'package:lmd_app/core/widgets/basic_appbar.dart';
import 'package:lmd_app/features/booking/presentation/pages/booking_page.dart';
import 'package:lmd_app/features/home/presentation/pages/stay_home.dart';
import 'package:lmd_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_nearby_deals.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_section_title.dart';
import 'package:lmd_app/features/cart/data/services/cart_services.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

Widget buildListingImage({
  required String imageUrl,
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
}) {
  final normalizedUrl = imageUrl.trim();

  if (normalizedUrl.isEmpty) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.image_not_supported)),
    );
  }

  return CachedNetworkImage(
    imageUrl: normalizedUrl,
    height: height,
    width: width,
    fit: fit,
    memCacheWidth: 320,
    placeholder: (context, url) => Container(
      height: height,
      width: width,
      color: Colors.grey.shade100,
      child: const Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.broken_image)),
    ),
  );
}

class HotelsCategoryPage extends StatefulWidget {
  const HotelsCategoryPage({super.key});

  @override
  State<HotelsCategoryPage> createState() => _HotelsCategoryPageState();
}

class _HotelsCategoryPageState extends State<HotelsCategoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  final LayerLink _searchLink = LayerLink();

  String searchQuery = '';
  bool _isDestinatonDialog = false;
  double editGuestHeight = 822;

  int rooms = 1;
  int adults = 2;
  int children = 0;

  int selectedAge = 1;
  bool travellingWithPets = false;
  int maxChildren = 0;

  @override
  void initState() {
    super.initState();
    final hotelCubit = context.read<HotelCubit>();
    if (hotelCubit.state.allListings.isEmpty) {
      hotelCubit.loadHotels();
    }
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit cubit) => cubit.state.user);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_isDestinatonDialog) {
              setState(() {
                _isDestinatonDialog = false;
              });
            }
          },
          child: Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  if (children <= 5) {
                    maxChildren = children;
                  }

                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverAppBar(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.transparent,
                        pinned: true,
                        floating: true,
                        snap: false,
                        flexibleSpace: BasicAppbar(user: user, isLeading: false),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: BlocBuilder<HotelSearchCubit, HotelSearchState>(
                        builder: (context, searchState) {
                          return const HomeHeroSection();
                        },
                      ),
                    ),
                  ];
                },
                body: _buildTabPage(context, _hotelTab()),
              ),
              Visibility(
                visible: _isDestinatonDialog,
                child: CompositedTransformFollower(
                  link: _searchLink,
                  targetAnchor: Alignment.bottomLeft,
                  followerAnchor: Alignment.topLeft,
                  offset: const Offset(0, 0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 48).clamp(0.0, 600.0),
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: BlocBuilder<HotelSearchCubit, HotelSearchState>(
                        builder: (context, state) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.results.length,
                            itemBuilder: (_, index) {
                              final hotel = state.results[index];

                              return ListTile(
                                leading: hotel.thumbnail.isNotEmpty
                                    ? Image.network(
                                        hotel.thumbnail,
                                        width: 50.w,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.hotel),
                                title: Text(hotel.name),
                                subtitle: Text(hotel.city),
                                onTap: () {
                                  searchController.text = hotel.name;
                                  setState(() {
                                    _isDestinatonDialog = false;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          );
                        },
                      ),
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

  Widget _buildTabPage(BuildContext parentContext, Widget child) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: child,
                ),
              ]),
            ),
          ],
        );
      },
    );
  }

  Widget _hotelTab() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          HotelSectionTitle(
            title: 'Live Deals Near You',
            subtitle: 'Book now, check in today',
            onViewAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const StayHome();
                  },
                ),
              );
            },
          ),
          BlocBuilder<HotelCubit, HotelState>(
            builder: (context, state) {
              return HotelNearbyDeals(
                listings: state.visibleListings,
                onHotelTap: (hotel) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (_) => DetailsCubit(HotelService()),
                          ),
                          BlocProvider(create: (_) => CartCubit(CartService())),
                        ],
                        child: BookingPage(productId: hotel.id, listing: hotel),
                      ),
                    ),
                  );
                },
                title: '',
              );
            },
          ),
          _buildTrustBar(),
        ],
      ),
    );
  }

  Widget _buildTrustBar() {
    return Container(
      width: double.infinity,
      color: const Color(0xffF8FAFC),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 96.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTrustCard(
                  icon: Icons.verified_user_outlined,
                  iconColor: const Color(0xff388FFF),
                  bgColor: const Color(0xffEFF6FF),
                  title: 'Verified Properties',
                  subtitle: 'Handpicked stays',
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildTrustCard(
                  icon: Icons.offline_bolt_outlined,
                  iconColor: const Color(0xffEA580C),
                  bgColor: const Color(0xffFFF7ED),
                  title: 'Instant Confirmation',
                  subtitle: 'Book in seconds',
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildTrustCard(
                  icon: Icons.headset_mic_outlined,
                  iconColor: const Color(0xffFF3A7E),
                  bgColor: const Color(0xffFAF5FF),
                  title: '24/7 Support',
                  subtitle: "We're here for you",
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildTrustCard(
                  icon: Icons.local_offer_outlined,
                  iconColor: const Color(0xffFF3A7E),
                  bgColor: const Color(0xffFDF2F8),
                  title: 'Best Deals',
                  subtitle: 'Save up to 70%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 111.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20.r),
            ),
            SizedBox(height: 6.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: Color(0xff1D1D1D),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 9.sp,
                color: Color(0xff535353),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
