import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lmd_app/core/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/features/category/presentation/pages/hotel_filter_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// NAVBAR & CUBIT IMPORTS
import 'package:lmd_app/app/shell/navbar_widget.dart'; // Standard path for NavbarWidget

import 'package:lmd_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_state.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_state.dart';

import 'package:lmd_app/core/theme/design_tokens.dart';

import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';

import 'package:lmd_app/features/booking/presentation/pages/booking_page.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/grid_view_card.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_search_card_2.dart';

import 'package:lmd_app/features/cart/data/services/cart_services.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

class CategoryListingScreen extends StatefulWidget {
  final String categoryName;
  final String? initialQuery;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final int? initialRooms;
  final int? initialAdults;
  final int? initialChildren;
  final HotelSearchCubit? searchCubit;
  final bool? initialTravellingWithPets;

  /// No destination was typed: on open, resolve the user's city (this is where
  /// the location permission is asked) and run the search with it.
  final bool locateOnOpen;

  const CategoryListingScreen({
    super.key,
    this.locateOnOpen = false,
    required this.categoryName,
    this.initialQuery,
    this.initialStartDate,
    this.initialEndDate,
    this.initialRooms,
    this.initialAdults,
    this.initialChildren,
    this.searchCubit,
    this.initialTravellingWithPets,
  });

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  // ============================================================
  // FILTERS
  // ============================================================

  Map<String, dynamic> _selectedFilters = {};
  String get _filterButtonText {
    final count = _getAppliedFilterCount();

    if (count == 0) {
      return 'Filters';
    }

    return 'Filters ($count)';
  }
  int _getAppliedFilterCount() {
    int count = 0;

    if (_selectedFilters['favoritesOnly'] == true) count++;

    if ((_selectedFilters['hotelName'] ?? '').toString().trim().isNotEmpty) {
      count++;
    }

    count += (_selectedFilters['meals'] as List?)?.length ?? 0;
    count += (_selectedFilters['starRatings'] as List?)?.length ?? 0;
    count += (_selectedFilters['propertyTypes'] as List?)?.length ?? 0;
    count += (_selectedFilters['amenities'] as List?)?.length ?? 0;
    count += (_selectedFilters['facilities'] as List?)?.length ?? 0;
    count += (_selectedFilters['roomFeatures'] as List?)?.length ?? 0;
    count += (_selectedFilters['accommodationFeatures'] as List?)?.length ?? 0;
    count += (_selectedFilters['guestRatings'] as List?)?.length ?? 0;
    count += (_selectedFilters['roomCounts'] as List?)?.length ?? 0;
    count += (_selectedFilters['bedTypes'] as List?)?.length ?? 0;
    count += (_selectedFilters['brands'] as List?)?.length ?? 0;

    if (_selectedFilters['freeCancellation'] == true) count++;
    if (_selectedFilters['payNow'] == true) count++;
    if (_selectedFilters['payOnSpot'] == true) count++;
    if (_selectedFilters['payAtHotel'] == true) count++;
    if (_selectedFilters['breakfastIncluded'] == true) count++;
    if (_selectedFilters['parkingAvailable'] == true) count++;
    if (_selectedFilters['wifiAvailable'] == true) count++;
    if (_selectedFilters['nearMetro'] == true) count++;
    if (_selectedFilters['sustainabilityCertification'] == true) count++;

    final maxDistance =
        (_selectedFilters['maxDistance'] as num?)?.toDouble() ?? 30;
    if (maxDistance != 30) count++;

    final minPrice =
        (_selectedFilters['minPrice'] as num?)?.toDouble() ?? 0;
    final maxPrice =
        (_selectedFilters['maxPrice'] as num?)?.toDouble() ?? 500000;
    if (minPrice != 0 || maxPrice != 500000) count++;

    if ((_selectedFilters['nearestMetro'] ?? '').toString().trim().isNotEmpty) {
      count++;
    }

    return count;
  }

  // ============================================================
  // SORT
  // ============================================================
  HotelSortOption _selectedSort = HotelSortOption.recommended;

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final LayerLink _searchLink = LayerLink();

  // ============================================================
  // CATEGORY
  // ============================================================

  late String _selectedCategory;

  // ============================================================
  // SEARCH STATE
  // ============================================================

  bool _hasSearched = false;
  late final HotelSearchCubit _hotelSearchCubit;
  bool _isEditGuestVisible = false;

  // ============================================================
  // DATE
  // ============================================================

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // ============================================================
  // GUESTS
  // ============================================================

  int rooms = 1;
  int adults = 2;
  int children = 0;
  bool travellingWithPets = false;
  int selectedAge = 1;

  // ============================================================
  // LOAD MORE
  // ============================================================

  int _visibleCount = 6;
  static const int _itemsPerPage = 6;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.categoryName;
    _selectedStartDate = widget.initialStartDate ?? DateTime.now();
    _selectedEndDate =
        widget.initialEndDate ?? DateTime.now().add(const Duration(days: 1));

    rooms = widget.initialRooms ?? 1;
    adults = widget.initialAdults ?? 2;
    children = widget.initialChildren ?? 0;
    travellingWithPets = widget.initialTravellingWithPets ?? false;

    _searchController.text = widget.initialQuery ?? '';

    _hotelSearchCubit =
        widget.searchCubit ?? HotelSearchCubit(HotelService());

    // Loading counts too: the home page hands over a search still in flight.
    final handed = widget.searchCubit?.state;
    if (handed != null && (handed.isSuccess || handed.isLoading)) {
      _hasSearched = true;
    }

    if (widget.locateOnOpen) {
      _hasSearched = true;
      _locating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _locateAndSearch());
    }
  }

  bool _locating = false;

  Future<void> _locateAndSearch() async {
    final city = await LocationService.instance.searchQuery();
    if (!mounted) return;
    _searchController.text = city;
    setState(() => _locating = false);
    await _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();

    if (widget.searchCubit == null) {
      _hotelSearchCubit.close();
    }

    super.dispose();
  }

  // ============================================================
  // DATE LABELS
  // ============================================================

  String get _dateRangeLabel {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      return 'Select check-in and check-out';
    }

    return '${_formatDate(_selectedStartDate!)} - '
        '${_formatDate(_selectedEndDate!)}';
  }

  String get _checkInDateLabel {
    if (_selectedStartDate == null) return '29 Sep';
    return '${_selectedStartDate!.day} ${_formatMonth(_selectedStartDate!)}';
  }

  String get _checkOutDateLabel {
    if (_selectedEndDate == null) return '30 Sep';
    return '${_selectedEndDate!.day} ${_formatMonth(_selectedEndDate!)}';
  }

  String get _shortDateRangeLabel {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      return 'Sep 29-30';
    }
    final s = _selectedStartDate!;
    final e = _selectedEndDate!;
    if (s.month == e.month && s.year == e.year) {
      return '${_formatMonth(s)} ${s.day}-${e.day}';
    } else {
      return '${_formatMonth(s)} ${s.day} - ${_formatMonth(e)} ${e.day}';
    }
  }

  String _formatMonth(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  String _formatDate(DateTime date) {
    return '${_formatMonth(date)} ${date.day}';
  }

  int _computeResultCount(HotelSearchState searchState) {
    List<RetailListingModel> rawListings;
    if (_hasSearched) {
      rawListings = searchState.results;
    } else {
      rawListings = context.read<HotelCubit>().state.visibleListings;
    }
    return _sortListings(_applyFilters(_filterByCategory(rawListings))).length;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _hotelSearchCubit,
      child: Scaffold(
        backgroundColor: DS.background,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchSection(),
                      _buildResults(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: const NavbarWidget(),
      ),
    );
  }

  // ============================================================
  // SEARCH SECTION
  // ============================================================

  Widget _buildSearchSection() {
    return BlocBuilder<HotelSearchCubit, HotelSearchState>(
      builder: (context, searchState) {
        final resultCount = _computeResultCount(searchState);

        return HotelSearchCard2(
          isEdit: false,
          searchLink: _searchLink,
          searchFocus: _searchFocus,
          searchController: _searchController,
          dateRangeLabel: _dateRangeLabel,
          checkInDateLabel: _checkInDateLabel,
          checkOutDateLabel: _checkOutDateLabel,
          shortDateRangeLabel: _shortDateRangeLabel,
          isEditGuestVisible: _isEditGuestVisible,
          isLoading: searchState.isLoading,
          guestWidget: _editGuests(),
          guestCountLabel: '${adults + children} '
              '${(adults + children) == 1 ? 'Guest' : 'Guests'}, '
              '$rooms '
              '${rooms == 1 ? 'Room' : 'Rooms'}',
          guestOnlyLabel: '${adults + children} '
              '${(adults + children) == 1 ? 'Guest' : 'Guests'}',
          useAltStyle: true,
          selectedCategory: _selectedCategory,
          onCategoryChanged: (category) {
            setState(() {
              _selectedCategory = category;
              _visibleCount = _itemsPerPage;
            });
          },
          resultCount: resultCount,
          filterButtonText: _filterButtonText,
          onFilterTap: _openFilterPage,
          selectedSort: _selectedSort,
          onSortChanged: (sort) {
            setState(() {
              _selectedSort = sort;
              _visibleCount = _itemsPerPage;
            });
          },
          onSearchChanged: (value) {},
          onSuggestionTap: () {
            FocusScope.of(context).unfocus();
          },
          onDateTap: _showPicker,
          onGuestTap: () {
            setState(() {
              _isEditGuestVisible = !_isEditGuestVisible;
            });
          },
          onSearch: () async {
            await _performSearch();
          },
        );
      },
    );
  }

  // ============================================================
  // SEARCH API
  // ============================================================

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    // Empty input = free search: the request falls back to the default location.

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
      children: List.filled(children, 5),
      query: query.isEmpty ? null : query,
    );

    await _hotelSearchCubit.searchHotels(request);

    if (!mounted) return;

    final state = _hotelSearchCubit.state;

    if (state.isSuccess) {
      setState(() {
        _hasSearched = true;
        _visibleCount = _itemsPerPage;
        _isEditGuestVisible = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Search failed',
          ),
        ),
      );
    }
  }

  // ============================================================
  // RESULTS search
  // ============================================================

  List<RetailListingModel> _applyFilters(
      List<RetailListingModel> listings,
      ) {
    List<RetailListingModel> filtered =
    List<RetailListingModel>.from(listings);

    final hotelName =
    (_selectedFilters['hotelName'] ?? '').toString().trim().toLowerCase();

    if (hotelName.isNotEmpty) {
      filtered = filtered.where((hotel) {
        return hotel.name.toString().toLowerCase().contains(hotelName);
      }).toList();
    }

    final selectedStars = (_selectedFilters['starRatings'] as List?)
        ?.map((e) => int.tryParse(e.toString()))
        .whereType<int>()
        .toSet() ??
        {};

    if (selectedStars.isNotEmpty) {
      filtered = filtered.where((hotel) {
        return selectedStars.contains(hotel.rating.toDouble().toInt());
      }).toList();
    }

    final selectedGuestRatings =
        (_selectedFilters['guestRatings'] as List?)?.cast<String>() ?? [];

    if (selectedGuestRatings.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final rating = hotel.rating.toDouble();
        return selectedGuestRatings.any((label) {
          final match = RegExp(r'(\d+)').firstMatch(label);
          final minimum =
          match == null ? null : double.tryParse(match.group(1)!);
          return minimum != null && rating >= minimum;
        });
      }).toList();
    }

    final minPrice =
        (_selectedFilters['minPrice'] as num?)?.toDouble() ?? 0;
    final maxPrice =
        (_selectedFilters['maxPrice'] as num?)?.toDouble() ?? 500000;

    filtered = filtered.where((hotel) {
      final price = _priceOf(hotel);
      return price >= minPrice && price <= maxPrice;
    }).toList();

    final propertyTypes = (_selectedFilters['propertyTypes'] as List?)
        ?.map((e) => _normalise(e.toString()))
        .toSet() ??
        {};

    if (propertyTypes.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final category = _normalise(hotel.category);
        final kind = _normalise(hotel.kind);
        final subcategory = _normalise(hotel.subcategory);

        return propertyTypes.any((type) =>
        _typeMatches(type, category) ||
            _typeMatches(type, kind) ||
            _typeMatches(type, subcategory));
      }).toList();
    }

    // These filter groups are matched against the listing's serialized data.
    // This keeps the existing RetailListingModel/API untouched.
    for (final key in [
      'meals',
      'facilities',
      'roomFeatures',
      'accommodationFeatures',
      'brands',
      'bedTypes',
    ]) {
      filtered = _filterByTextOptions(
        filtered,
        _selectedFilters[key],
            (hotel) => _hotelSearchText(hotel),
      );
    }

    final selectedRoomCounts = (_selectedFilters['roomCounts'] as List?)
        ?.map((e) => int.tryParse(e.toString()))
        .whereType<int>()
        .toSet() ??
        {};

    if (selectedRoomCounts.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final rooms = _firstIntField(hotel, [
          'numberOfRooms',
          'roomCount',
          'rooms',
          'availableRooms',
        ]);
        return rooms == null || selectedRoomCounts.contains(rooms);
      }).toList();
    }

    final maxDistance =
        (_selectedFilters['maxDistance'] as num?)?.toDouble() ?? 30;

    if (maxDistance != 30) {
      filtered = filtered.where((hotel) {
        final distance = _firstDoubleField(hotel, [
          'distance',
          'distanceKm',
          'distanceFromCenter',
          'distanceFromCityCenter',
        ]);
        return distance == null || distance <= maxDistance;
      }).toList();
    }

    final nearMetro = _selectedFilters['nearMetro'] == true;
    final metroQuery =
    (_selectedFilters['nearestMetro'] ?? '').toString().trim().toLowerCase();

    if (nearMetro || metroQuery.isNotEmpty) {
      filtered = filtered.where((hotel) {
        final text = _hotelSearchText(hotel);

        if (metroQuery.isNotEmpty && !text.contains(metroQuery)) {
          return false;
        }

        if (nearMetro) {
          final metroDistance = _firstDoubleField(hotel, [
            'metroDistance',
            'distanceToMetro',
            'nearestMetroDistance',
          ]);

          if (metroDistance != null) return metroDistance <= 5;
          return text.contains('metro') || text.contains('subway');
        }

        return true;
      }).toList();
    }

    // Boolean booking/certificate filters.
    final booleanFilters = <String, List<String>>{
      'freeCancellation': ['free cancellation', 'freeCancellation'],
      'payNow': ['pay now', 'payNow'],
      'payOnSpot': ['pay on the spot', 'pay at property', 'pay at hotel'],
      'payAtHotel': ['pay at hotel', 'payAtHotel'],
      'breakfastIncluded': ['breakfast included', 'breakfastIncluded'],
      'parkingAvailable': ['parking', 'parkingAvailable'],
      'wifiAvailable': ['wifi', 'wi-fi', 'internet', 'wifiAvailable'],
      'sustainabilityCertification': [
        'sustainability certification',
        'sustainabilityCertified',
      ],
    };

    for (final entry in booleanFilters.entries) {
      if (_selectedFilters[entry.key] == true) {
        filtered = filtered.where((hotel) {
          final text = _hotelSearchText(hotel);
          return entry.value.any((term) => text.contains(term.toLowerCase()));
        }).toList();
      }
    }

    final sortBy = _selectedFilters['sortBy']?.toString();

    if (sortBy == 'Price: Low to High') {
      filtered.sort((a, b) => _priceOf(a).compareTo(_priceOf(b)));
    } else if (sortBy == 'Price: High to Low') {
      filtered.sort((a, b) => _priceOf(b).compareTo(_priceOf(a)));
    } else if (sortBy == 'Rating: Highest First') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortBy == 'Distance: Nearest First') {
      filtered.sort((a, b) {
        final ad = _firstDoubleField(a, [
          'distance',
          'distanceKm',
          'distanceFromCenter',
          'distanceFromCityCenter',
        ]);
        final bd = _firstDoubleField(b, [
          'distance',
          'distanceKm',
          'distanceFromCenter',
          'distanceFromCityCenter',
        ]);

        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return ad.compareTo(bd);
      });
    }

    return filtered;
  }

  List<RetailListingModel> _filterByTextOptions(
      List<RetailListingModel> listings,
      dynamic rawOptions,
      String Function(RetailListingModel) textBuilder,
      ) {
    final options = (rawOptions as List?)
        ?.map((e) => e.toString().trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList() ??
        [];

    if (options.isEmpty) return listings;

    return listings.where((hotel) {
      final text = textBuilder(hotel);
      return options.any((option) => _optionMatchesText(option, text));
    }).toList();
  }

  bool _optionMatchesText(String option, String text) {
    const aliases = <String, List<String>>{
      'free internet': ['free internet', 'internet', 'wifi', 'wi-fi'],
      'transfer': ['transfer', 'airport shuttle', 'shuttle'],
      'parking': ['parking'],
      'swimming pool': ['swimming pool', 'pool'],
      'fitness centre': ['fitness centre', 'fitness center', 'gym'],
      'bar or restaurant': ['bar', 'restaurant'],
      'conference hall': ['conference hall', 'conference'],
      'spa services': ['spa services', 'spa'],
      'ski slope nearby': ['ski slope', 'ski'],
      'beach nearby': ['beach'],
      'air-conditioning': ['air-conditioning', 'air conditioning', 'ac'],
      'private bathroom': ['private bathroom', 'private bath'],
      'kitchen': ['kitchen'],
      'balcony': ['balcony'],
      'suitable for children': ['suitable for children'],
      'for guests with disabilities': ['disabilities', 'accessible'],
      'pets allowed': ['pets allowed', 'pet friendly'],
      'smoking allowed': ['smoking allowed', 'smoking'],
      'double bed': ['double bed'],
      'separate beds': ['separate beds', 'twin beds'],
      'breakfast included': ['breakfast included', 'breakfast'],
      'no meals included': ['no meals included', 'room only'],
      'breakfast + dinner or lunch included': [
        'breakfast + dinner',
        'breakfast + lunch',
        'half board',
      ],
      'breakfast, lunch and dinner included': [
        'breakfast, lunch and dinner',
        'full board',
      ],
      'all-inclusive': ['all-inclusive', 'all inclusive'],
    };

    final terms = aliases[option] ?? [option];
    return terms.any(text.contains);
  }

  String _hotelSearchText(RetailListingModel hotel) {
    final dynamic item = hotel;
    final values = <String>[];

    try {
      final dynamic json = item.toJson();
      values.add(jsonEncode(json));
    } catch (_) {}

    values.add(hotel.name.toString());
    values.add(hotel.category.toString());
    values.add(hotel.kind.toString());
    values.add(hotel.subcategory.toString());

    return values.join(' ').toLowerCase();
  }

  double? _firstDoubleField(
      RetailListingModel hotel,
      List<String> fieldNames,
      ) {
    final dynamic item = hotel;

    for (final fieldName in fieldNames) {
      dynamic value;
      try {
        switch (fieldName) {
          case 'distance':
            value = item.distance;
            break;
          case 'distanceKm':
            value = item.distanceKm;
            break;
          case 'distanceFromCenter':
            value = item.distanceFromCenter;
            break;
          case 'distanceFromCityCenter':
            value = item.distanceFromCityCenter;
            break;
          case 'metroDistance':
            value = item.metroDistance;
            break;
          case 'distanceToMetro':
            value = item.distanceToMetro;
            break;
          case 'nearestMetroDistance':
            value = item.nearestMetroDistance;
            break;
        }
      } catch (_) {
        value = null;
      }

      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }

    return null;
  }

  int? _firstIntField(
      RetailListingModel hotel,
      List<String> fieldNames,
      ) {
    final dynamic item = hotel;

    for (final fieldName in fieldNames) {
      dynamic value;
      try {
        switch (fieldName) {
          case 'numberOfRooms':
            value = item.numberOfRooms;
            break;
          case 'roomCount':
            value = item.roomCount;
            break;
          case 'rooms':
            value = item.rooms;
            break;
          case 'availableRooms':
            value = item.availableRooms;
            break;
        }
      } catch (_) {
        value = null;
      }

      if (value is num) return value.toInt();
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }

    return null;
  }

  String _normalise(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .trim();
  }

  bool _typeMatches(String selected, String actual) {
    if (selected == actual) return true;

    const aliases = {
      'hotels': 'hotel',
      'hostels': 'hostel',
      'apartments': 'apartment',
      'guesthouses': 'guest house',
      'apartment hotels': 'apartment hotel',
    };

    return aliases[selected] == actual || aliases[actual] == selected;
  }

  Widget _buildResults() {
    return BlocBuilder<HotelSearchCubit, HotelSearchState>(
      builder: (context, searchState) {
        if (_hasSearched) {
          if (_locating || searchState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (searchState.errorMessage != null) {
            return _buildMessage(
              icon: Icons.error_outline_rounded,
              title: 'Search failed',
              message: searchState.errorMessage!,
            );
          }

          final listings = _sortListings(
            _applyFilters(
              _filterByCategory(searchState.results),
            ),
          );

          if (listings.isEmpty) {
            return _buildMessage(
              icon: Icons.search_off_rounded,
              title: 'No hotels found',
              message:
              'No hotels found for "${_searchController.text.trim()}".',
            );
          }

          return _buildDeals(
            listings: listings,
            title: 'Search Results',
          );
        }

        return _buildCategoryResults();
      },
    );
  }

  // ============================================================
  // DEFAULT CATEGORY RESULTS
  // ============================================================

  Widget _buildCategoryResults() {
    return BlocBuilder<HotelCubit, HotelState>(
      builder: (context, state) {
        final listings = _sortListings(
          _applyFilters(
            _filterByCategory(state.visibleListings),
          ),
        );

        if (listings.isEmpty) {
          return _buildMessage(
            icon: Icons.hotel_outlined,
            title: 'No deals available',
            message: 'No ${_selectedCategory.toLowerCase()} '
                'deals are available right now.',
          );
        }

        return _buildDeals(
          listings: listings,
          title: '${_categoryTitle()} Deals',
        );
      },
    );
  }

  //===========================================================
  // SORT LABEL
  //===========================================================

  double _priceOf(RetailListingModel item) {
    return double.tryParse(
      item.basePrice.toString(),
    ) ??
        0;
  }

  List<RetailListingModel> _sortListings(
      List<RetailListingModel> listings,
      ) {
    final sorted = List<RetailListingModel>.from(listings);

    switch (_selectedSort) {
      case HotelSortOption.recommended:
        return sorted;

      case HotelSortOption.priceLowToHigh:
        sorted.sort(
              (a, b) => _priceOf(a).compareTo(_priceOf(b)),
        );
        return sorted;

      case HotelSortOption.priceHighToLow:
        sorted.sort(
              (a, b) => _priceOf(b).compareTo(_priceOf(a)),
        );
        return sorted;
    }
  }


  // ============================================================
  // CATEGORY FILTER
  // ============================================================

  List<RetailListingModel> _filterByCategory(
      List<RetailListingModel> listings,
      ) {
    final rawCategory = _selectedCategory.trim().toLowerCase();

    if (rawCategory == 'all') {
      return listings;
    }

    String normalize(String s) {
      final lower = s.trim().toLowerCase();
      if (lower == 'hotels') return 'hotel';
      if (lower == 'resorts') return 'resort';
      if (lower == 'villas') return 'villa';
      if (lower == 'camping') return 'camping';
      if (lower == 'luxury_villas' ||
          lower == 'luxury villas' ||
          lower == 'luxury-villas') {
        return 'luxury-villa';
      }
      return lower;
    }

    final category = normalize(rawCategory);

    // Backend marks luxury villas by a 'luxury' slug (kind `luxury-villa`).
    if (category == 'luxury-villa') {
      return listings
          .where((i) => [i.kind, i.category, i.subcategory]
          .any((v) => v.toLowerCase().contains('luxury')))
          .toList();
    }

    // Villas and Luxury Villas are separate chips: a luxury villa is not a Villa.
    bool isLuxury(RetailListingModel i) => [i.kind, i.category, i.subcategory]
        .any((v) => v.toLowerCase().contains('luxury'));

    return listings.where((item) {
      if (category == 'villa' && isLuxury(item)) return false;
      final itemCategory = normalize(item.category);
      final itemKind = normalize(item.kind);
      final itemSubcategory = normalize(item.subcategory);

      return itemCategory == category ||
          itemKind == category ||
          itemSubcategory == category ||
          itemCategory.contains(category) ||
          itemKind.contains(category) ||
          itemSubcategory.contains(category);
    }).toList();
  }

  String _categoryTitle() {
    switch (_selectedCategory.trim().toLowerCase()) {
      case 'luxury-villa':
      case 'luxury_villas':
        return 'Luxury Villa';
      default:
        return _selectedCategory;
    }
  }

  // ============================================================
  // DEALS
  // ============================================================

  Widget _buildDeals({
    required List<RetailListingModel> listings,
    required String title,
  }) {
    if (_visibleCount > listings.length && listings.isNotEmpty) {
      _visibleCount = listings.length;
    }

    final visibleListings = listings.take(_visibleCount).toList();

    final bool hasMore = _visibleCount < listings.length;
    final bool showLess =
        !hasMore && listings.length > _itemsPerPage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridViewCard(
          listings: visibleListings,
          onHotelTap: (hotel) {
            _openHotelDetails(hotel);
          },
        ),

        if (listings.length > _itemsPerPage)
          _buildLoadMoreButton(
            hasMore: hasMore,
            showLess: showLess,
          ),
      ],
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

  // ============================================================
  // RESULTS HEADER
  // ============================================================

  Future<void> _openFilterPage() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => HotelFilterPage(
          initialFilters: _selectedFilters,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _selectedFilters = result;

      _visibleCount = _itemsPerPage;
    });
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: DS.accentRed),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DS.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: DS.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Widget _buildLoadMoreButton(
      {required bool hasMore, required bool showLess}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: () {
            setState(() {
              if (showLess) {
                _visibleCount = _itemsPerPage;
              } else {
                _visibleCount += _itemsPerPage;
              }
            });
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: DS.borderMedium,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showLess ? 'Show Less Deals' : 'Load More Deals',
                style: GoogleFonts.inter(
                  color: DS.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                showLess
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: DS.textPrimary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _showPicker() async {
    DateTime? tempStartDate = _selectedStartDate;
    DateTime? tempEndDate = _selectedEndDate;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: DS.card,
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select dates',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: DS.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      icon: const Icon(Icons.close, color: Color(0xFF111827)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 420,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: DS.primaryBlue,
                      ),
                    ),
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      selectionMode: DateRangePickerSelectionMode.range,
                      minDate: DateTime.now(),
                      showActionButtons: true,
                      confirmText: 'Apply',
                      cancelText: 'Cancel',
                      startRangeSelectionColor: DS.primaryBlue,
                      endRangeSelectionColor: DS.primaryBlue,
                      todayHighlightColor: DS.primaryBlue,
                      rangeSelectionColor:
                      DS.primaryBlue.withValues(alpha: .15),
                      initialSelectedRange: PickerDateRange(
                        tempStartDate,
                        tempEndDate,
                      ),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          final range = args.value as PickerDateRange;
                          tempStartDate = range.startDate;
                          tempEndDate = range.endDate;
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
                      onCancel: () {
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // GUEST EDITOR
  // ============================================================

  Widget _editGuests() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 18),
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

          const SizedBox(height: 10),

          Text(
            'Please provide right number of children along with their right age for best options and prices.',
            style: GoogleFonts.inter(
              color: DS.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 12),

          Divider(color: DS.borderLight),

          Visibility(
            visible: children > 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Text(
                  'Age Of Children',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DS.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: children >= 5 ? 239 : null,
                  child: ListView.separated(
                    itemCount: children,
                    physics: children > 5
                        ? BouncingScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Child ${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: DS.textPrimary,
                              ),
                            ),
                          ),

                          Container(
                            width: 99,
                            height: 38,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: DS.card,
                              borderRadius: BorderRadius.circular(DS.radiusPill),
                              border: Border.all(color: DS.borderMedium),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedAge,
                                menuMaxHeight: 300,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: <DropdownMenuItem<int>>[
                                  ...List.generate(17, (index) {
                                    return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text('${index + 1} Yr'),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedAge = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Divider(color: DS.borderLight),
              ],
            ),
          ),

          Center(
            child: SizedBox(
              height: 48,
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditGuestVisible = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DS.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DS.radiusButton),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COUNTER
  // ============================================================
  Widget buildCounter({
    required String title,
    String? subtitle,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DS.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: DS.textSecondary,
                    ),
                  ),
              ],
            ),
          ),

          // Quantity pill:  -  value  +
          Container(
            width: 99,
            height: 32,
            decoration: BoxDecoration(
              color: DS.card,
              borderRadius: BorderRadius.circular(DS.radiusPill),
              border: Border.all(color: DS.borderMedium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onMinus,
                  child: const Icon(
                    Icons.remove,
                    size: 16,
                    color: DS.textPrimary,
                  ),
                ),
                Text(
                  value.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: DS.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: onPlus,
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: DS.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}