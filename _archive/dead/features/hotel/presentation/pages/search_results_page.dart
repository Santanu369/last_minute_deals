import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_cubit.dart';

import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_state.dart';
import 'package:lmd_app/core/widgets/custom_appbar.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/booking/presentation/pages/booking_page.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/grid_view_card.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_search_card_2.dart';
import 'package:lmd_app/features/cart/data/services/cart_services.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

enum SearchType { hotel }

class SearchResultsPage extends StatefulWidget {
  final SearchType type;
  final String? initialQuery;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final int initialRooms;
  final int initialAdults;
  final int initialChildren;
  final bool initialTravellingWithPets;

  const SearchResultsPage({
    super.key,
    required this.type,
    this.initialQuery,
    this.initialStartDate,
    this.initialEndDate,
    this.initialRooms = 1,
    this.initialAdults = 2,
    this.initialChildren = 0,
    this.initialTravellingWithPets = false,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode _searchFocus = FocusNode();

  final LayerLink _searchLink = LayerLink();

  bool _isEditGuestVisible = false;
  bool _searchButton = true;

  int count = 0;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  int rooms = 1;
  int adults = 2;
  int children = 0;
  double editGuestHeight = 822;

  bool travellingWithPets = false;

  int selectedAge = 1;
  double get headerHeight {
    if (_isEditGuestVisible) {
      return editGuestHeight + (50 * maxChildren) + (maxChildren == 0 ? 0 : 20);
    }

    return 760; // adjust after testing
  }

  String get _dateRangeLabel {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      return 'Select check-in and check-out';
    }

    final startLabel = _formatDate(_selectedStartDate!);
    final endLabel = _formatDate(_selectedEndDate!);
    return '$startLabel - $endLabel';
  }

  String _formatDate(DateTime date) {
    final month = <int, String>{
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    }[date.month];

    return '$month ${date.day}';
  }

  @override
  void initState() {
    super.initState();
    searchController.text = widget.initialQuery ?? '';
    _selectedStartDate = widget.initialStartDate ?? DateTime.now();
    _selectedEndDate =
        widget.initialEndDate ?? DateTime.now().add(const Duration(days: 1));
    rooms = widget.initialRooms;
    adults = widget.initialAdults;
    children = widget.initialChildren;
    travellingWithPets = widget.initialTravellingWithPets;
  }

  Future<void> _showPicker() async {
    DateTime? tempStartDate = _selectedStartDate;
    DateTime? tempEndDate = _selectedEndDate;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: EdgeInsets.all(16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select dates',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 420.h,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    selectionMode: DateRangePickerSelectionMode.range,
                    minDate: DateTime.now(),
                    showActionButtons: true,
                    confirmText: 'Apply',
                    cancelText: 'Cancel',
                    startRangeSelectionColor: AppColors.primary,
                    endRangeSelectionColor: AppColors.primary,
                    todayHighlightColor: AppColors.primary,
                    rangeSelectionColor: AppColors.primary.withValues(alpha: 0.18),
                    // maxDate: DateTime.now().add(Duration(days: 2)),
                    initialSelectedRange:
                        tempStartDate == null && tempEndDate == null
                        ? PickerDateRange(
                            DateTime.now().add(Duration(days: 1)),
                            DateTime.now().add(Duration(days: 2)),
                          )
                        : PickerDateRange(tempStartDate, tempEndDate),
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is PickerDateRange) {
                            final range = args.value as PickerDateRange;
                            setState(() {
                              tempStartDate = range.startDate;
                              tempEndDate = range.endDate;
                            });
                          }
                        },
                    onSubmit: (Object? value) {
                      if (value is PickerDateRange) {
                        setState(() {
                          _selectedStartDate = value.startDate;
                          _selectedEndDate = value.endDate;
                        });
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    onCancel: () => Navigator.of(dialogContext).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // _tabController.dispose();
    searchController.dispose();
    // _destinatonFocus.dispose();
    // _editGuestFocus.dispose();
    super.dispose();
  }

  int tab = 0;
  int maxChildren = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(scaffoldKey: scaffoldKey),
      // bottomNavigationBar: ,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HotelSearchCubit, HotelSearchState>(
          builder: (context, state) {
            return _buildHotel(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildHotel(BuildContext context, HotelSearchState state) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
              child: HotelSearchCard2(
                isEdit: false,
                searchLink: _searchLink,
                searchFocus: _searchFocus,
                searchController: searchController,

                dateRangeLabel: _dateRangeLabel,

                isEditGuestVisible: _isEditGuestVisible,
                isLoading: state.isLoading,

                guestWidget: _editGuests(),
                guestCountLabel:
                    "${adults + children} ${(adults + children) == 1 ? 'Guest' : 'Guests'}, $rooms ${rooms == 1 ? 'Room' : 'Rooms'}",
                useAltStyle: true,

                onSearchChanged: (value) {
                  // We'll add debounce + suggestions later
                },

                onSuggestionTap: () {
                  FocusScope.of(context).unfocus();
                },

                onDateTap: _showPicker,

                onGuestTap: () {
                  setState(() {
                    _isEditGuestVisible = !_isEditGuestVisible;
                    _searchButton = !_searchButton;
                  });
                },

                onSearch: () async {
                  if (searchController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a destination'),
                      ),
                    );
                    return;
                  }

                  if (_selectedStartDate == null || _selectedEndDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your travel dates'),
                      ),
                    );
                    return;
                  }

                  final request = SearchHotelsRequest(
                    checkIn: _selectedStartDate!,
                    checkOut: _selectedEndDate!,
                    rooms: rooms,
                    adults: adults,
                    children: List.filled(children, 5), // temporary
                    query: searchController.text.trim(),
                  );

                  final cubit = context.read<HotelSearchCubit>();

                  await cubit.searchHotels(request);

                  if (!mounted) return;

                  if (!cubit.state.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          cubit.state.errorMessage ?? 'Search failed',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ];
      },

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (state.results.isEmpty)
              const Center(
                child: Text('No results found'),
              )
            else
            // HotelSectionTitle(
            //   title: "${state.results.length} Stays Found",
            //   subtitle: searchController.text.trim(),
            // ),

            SizedBox(height: 20.h),

            BlocBuilder<HotelSearchCubit, HotelSearchState>(
              builder: (context, state) {
                return Column(
                  children: [
                    GridViewCard(
                      listings: state.results,
                      loadmore: state.results.length > 4 ? 1 : 0,
                      onHotelTap: (hotel) {
                        _openHotelDetails(hotel);
                      },
                    ),                    
                    SizedBox(height: 80.h + MediaQuery.paddingOf(context).bottom),
                  ],
                );
              },
            ),

            // const SizedBox(height: 30.h),
            buildLoadMoreButton(),

            SizedBox(height: 80.h + MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }

  void _openHotelDetails(RetailListingModel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DetailsCubit(HotelService())),

            BlocProvider(create: (_) => CartCubit(CartService())),
          ],
          child: BookingPage(productId: hotel.id, listing: hotel),
        ),
      ),
    );
  }

  Widget buildLoadMoreButton() {
    return BlocBuilder<HotelSearchCubit, HotelSearchState>(
      builder: (context, state) {
        final totalCount = state.results.length;
        final currentLimit = 6 * (count + 1);
        final showLess = currentLimit >= totalCount && totalCount > 6;

        if (totalCount <= 6) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  if (showLess) {
                    count = 0;
                  } else {
                    count++;
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color:AppColors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showLess ? 'Show Less Deals' : 'Load More Deals',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    showLess
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCounter({
    required String title,
    String? subtitle,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11.sp),
                  ),
              ],
            ),
          ),

          Container(
            width: 99.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onMinus,
                  child: Icon(Icons.remove, size: 20.r),
                ),
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onPlus,
                  child: Icon(Icons.add, color: Colors.indigo, size: 20.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editGuests() {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCounter(
            title: 'Room',
            value: rooms,
            onMinus: () {
              if (rooms > 1) {
                setState(() => rooms--);
              }
            },
            onPlus: () {
              if (rooms < 20) {
                setState(() => rooms++);
              }
            },
          ),

          buildCounter(
            title: 'Adults',
            value: adults,
            onMinus: () {
              if (adults > 1) {
                setState(() => adults--);
              }
            },
            onPlus: () {
              if (adults < 40) {
                setState(() => adults++);
              }
            },
          ),

          buildCounter(
            title: 'Children',
            subtitle: '0-17 Years Old',
            value: children,
            onMinus: () {
              if (children > 0) {
                setState(() => children--);
              }
            },
            onPlus: () {
              if (children < 40) {
                setState(() => children++);
              }
            },
          ),

          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Checkbox(
                  activeColor: AppColors.primary,
                  value: travellingWithPets,
                  onChanged: (value) {
                    setState(() {
                      travellingWithPets = value!;
                    });
                  },
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    'Are You Travelling With Pets?',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ),
                SizedBox(width: 5.w),
                const Icon(Icons.pets, color: Colors.grey),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          Center(
            child: SizedBox(
              width: 160.w,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditGuestVisible = false;
                    _searchButton = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}