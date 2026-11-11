import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';

class HotelFilterPage extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;

  const HotelFilterPage({
    super.key,
    this.initialFilters,
  });

  @override
  State<HotelFilterPage> createState() => _HotelFilterPageState();
}

class _HotelFilterPageState extends State<HotelFilterPage> {
  // ============================================================
  // DESIGN TOKENS (from centralized theme)
  // ============================================================
  static const Color _primaryDark = DS.textPrimary; // text colour
  static const Color _active = DS.primaryBlue; // buttons, selected, links
  static const Color _border = DS.borderLight;
  static const Color _textSecondary = DS.textSecondary;
  static const Color _checkboxText = DS.textPrimary;
  static const Color _inputBorder = DS.borderMedium;
  static const Color _inputBg = DS.card;
  static const Color _pageBg = DS.background;
  static const Color _uppercaseLabel = DS.textTertiary;

  late bool _favoritesOnly;
  late String _sortBy;
  late TextEditingController _hotelNameController;

  final Set<String> _selectedMeals = {};
  final Set<int> _selectedStarRatings = {};

  final Set<String> _selectedPropertyTypes = {};
  final Set<String> _selectedAmenities = {};
  final Set<String> _selectedGuestRatings = {};

  final Set<String> _selectedFacilities = {};
  final Set<String> _selectedRoomFeatures = {};
  final Set<String> _selectedAccommodationFeatures = {};
  final Set<String> _selectedBrands = {};
  final Set<String> _selectedBedTypes = {};
  final Set<int> _selectedRoomCounts = {};

  bool _freeCancellation = false;
  bool _payNow = false;
  bool _payOnSpot = false;
  bool _payAtHotel = false;
  bool _breakfastIncluded = false;
  bool _parkingAvailable = false;
  bool _wifiAvailable = false;
  bool _nearMetro = false;
  bool _showAllBrands = false;
  bool _sustainabilityCertification = false;

  bool _showMoreFacilities = false;
  bool _showMorePropertyTypes = false;

  double _maxDistance = 30;
  double _minPrice = 0;
  double _maxPrice = 500000;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _nearestMetroController;

  @override
  void initState() {
    super.initState();

    final filters = widget.initialFilters ?? {};

    _favoritesOnly = filters['favoritesOnly'] ?? false;
    _sortBy = filters['sortBy'] ?? 'Distance: Nearest First';

    _hotelNameController = TextEditingController(
      text: filters['hotelName'] ?? '',
    );

    _selectedMeals.addAll(List<String>.from(filters['meals'] ?? []));
    _selectedStarRatings.addAll(List<int>.from(filters['starRatings'] ?? []));
    _selectedPropertyTypes
        .addAll(List<String>.from(filters['propertyTypes'] ?? []));
    _selectedAmenities.addAll(List<String>.from(filters['amenities'] ?? []));
    _selectedGuestRatings
        .addAll(List<String>.from(filters['guestRatings'] ?? []));
    _selectedFacilities
        .addAll(List<String>.from(filters['facilities'] ?? []));
    _selectedRoomFeatures
        .addAll(List<String>.from(filters['roomFeatures'] ?? []));
    _selectedAccommodationFeatures
        .addAll(List<String>.from(filters['accommodationFeatures'] ?? []));
    _selectedBrands.addAll(List<String>.from(filters['brands'] ?? []));
    _selectedBedTypes.addAll(List<String>.from(filters['bedTypes'] ?? []));
    _selectedRoomCounts.addAll(List<int>.from(filters['roomCounts'] ?? []));

    _freeCancellation = filters['freeCancellation'] ?? false;
    _payNow = filters['payNow'] ?? false;
    _payOnSpot = filters['payOnSpot'] ?? false;
    _payAtHotel = filters['payAtHotel'] ?? false;
    _breakfastIncluded = filters['breakfastIncluded'] ?? false;
    _parkingAvailable = filters['parkingAvailable'] ?? false;
    _wifiAvailable = filters['wifiAvailable'] ?? false;
    _nearMetro = filters['nearMetro'] ?? false;
    _sustainabilityCertification =
        filters['sustainabilityCertification'] ?? false;
    _maxDistance = (filters['maxDistance'] ?? 30).toDouble();
    _minPrice = (filters['minPrice'] ?? 0).toDouble();
    _maxPrice = (filters['maxPrice'] ?? 500000).toDouble();

    _minPriceController =
        TextEditingController(text: _minPrice.round().toString());
    _maxPriceController =
        TextEditingController(text: _maxPrice.round().toString());
    _nearestMetroController =
        TextEditingController(text: filters['nearestMetro'] ?? '');
  }

  @override
  void dispose() {
    _hotelNameController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _nearestMetroController.dispose();
    super.dispose();
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  void _clearAll() {
    setState(() {
      _favoritesOnly = false;
      _sortBy = 'Distance: Nearest First';

      _hotelNameController.clear();

      _selectedMeals.clear();
      _selectedStarRatings.clear();
      _selectedPropertyTypes.clear();
      _selectedAmenities.clear();
      _selectedGuestRatings.clear();
      _selectedFacilities.clear();
      _selectedRoomFeatures.clear();
      _selectedAccommodationFeatures.clear();
      _selectedBrands.clear();
      _selectedBedTypes.clear();
      _selectedRoomCounts.clear();

      _freeCancellation = false;
      _payNow = false;
      _payOnSpot = false;
      _payAtHotel = false;
      _breakfastIncluded = false;
      _parkingAvailable = false;
      _wifiAvailable = false;
      _nearMetro = false;
      _sustainabilityCertification = false;
      _maxDistance = 30;
      _minPrice = 0;
      _maxPrice = 500000;
      _minPriceController.text = '0';
      _maxPriceController.text = '500000';
      _nearestMetroController.clear();
    });
  }

  // ============================================================
  // APPLY
  // ============================================================

  void _applyFilters() {
    final filters = <String, dynamic>{
      'favoritesOnly': _favoritesOnly,
      'sortBy': _sortBy,
      'hotelName': _hotelNameController.text.trim(),
      'meals': _selectedMeals.toList(),
      'starRatings': _selectedStarRatings.toList(),
      'propertyTypes': _selectedPropertyTypes.toList(),
      'amenities': _selectedAmenities.toList(),
      'guestRatings': _selectedGuestRatings.toList(),
      'freeCancellation': _freeCancellation,
      'payNow': _payNow,
      'payOnSpot': _payOnSpot,
      'payAtHotel': _payAtHotel,
      'breakfastIncluded': _breakfastIncluded,
      'parkingAvailable': _parkingAvailable,
      'wifiAvailable': _wifiAvailable,
      'nearMetro': _nearMetro,
      'maxDistance': _maxDistance,
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
      'facilities': _selectedFacilities.toList(),
      'roomFeatures': _selectedRoomFeatures.toList(),
      'accommodationFeatures': _selectedAccommodationFeatures.toList(),
      'sustainabilityCertification': _sustainabilityCertification,
      'roomCounts': _selectedRoomCounts.toList(),
      'bedTypes': _selectedBedTypes.toList(),
      'brands': _selectedBrands.toList(),
      'nearestMetro': _nearestMetroController.text.trim(),
    };

    Navigator.pop(context, filters);
  }

  // ============================================================
  // COUNT
  // ============================================================

  int get _filterCount {
    int count = 0;

    if (_favoritesOnly) count++;
    if (_hotelNameController.text.trim().isNotEmpty) count++;

    count += _selectedMeals.length;
    count += _selectedStarRatings.length;
    count += _selectedPropertyTypes.length;
    count += _selectedAmenities.length;
    count += _selectedGuestRatings.length;
    count += _selectedFacilities.length;
    count += _selectedRoomFeatures.length;
    count += _selectedAccommodationFeatures.length;
    count += _selectedRoomCounts.length;
    count += _selectedBedTypes.length;
    count += _selectedBrands.length;

    if (_freeCancellation) count++;
    if (_payNow) count++;
    if (_payOnSpot) count++;
    if (_payAtHotel) count++;
    if (_breakfastIncluded) count++;
    if (_parkingAvailable) count++;
    if (_wifiAvailable) count++;
    if (_nearMetro) count++;
    if (_sustainabilityCertification) count++;
    if (_maxDistance != 30) count++;
    if (_minPrice != 0 || _maxPrice != 500000) count++;
    if (_nearestMetroController.text.trim().isNotEmpty) count++;

    return count;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,

      // ========================================================
      // HEADER — sticky 64px, white bg, bottom border, back arrow
      // left, centered title, Clear All + X circle right.
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64.h,
        shape: const Border(
          bottom: BorderSide(color: _border, width: 1),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: _primaryDark,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Filters',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: _primaryDark,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
            ),
            child: Text(
              'Clear All',
              style: GoogleFonts.inter(
                color: _active,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: const BoxDecoration(
                  color: DS.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: _primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
          children: [
            // ==================================================
            // FAVORITES
            // ==================================================
            _buildCard(
              child: Row(
                children: [
                  Icon(Icons.favorite, color: DS.accentRed, size: 20.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Favorites',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: _primaryDark,
                      ),
                    ),
                  ),
                  _buildToggleSwitch(
                    value: _favoritesOnly,
                    onChanged: (value) =>
                        setState(() => _favoritesOnly = value),
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // SORT
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Sort by'),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    initialValue: _sortBy,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: _primaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _inputDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Distance: Nearest First',
                        child: Text('Distance: Nearest First'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: Low to High',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: High to Low',
                        child: Text('Price: High to Low'),
                      ),
                      DropdownMenuItem(
                        value: 'Rating: Highest First',
                        child: Text('Rating: Highest First'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sortBy = value);
                    },
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // HOTEL NAME
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Hotel name'),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _hotelNameController,
                    style: GoogleFonts.inter(fontSize: 14.sp, color: _primaryDark),
                    decoration: _inputDecoration(hintText: 'For example, Hilton'),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // MEALS
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Meals'),
                  SizedBox(height: 6.h),
                  for (final meal in [
                    'No meals included',
                    'Breakfast included',
                    'Breakfast + dinner or lunch included',
                    'Breakfast, lunch and dinner included',
                    'All-inclusive',
                  ])
                    _buildCheckboxRow(
                      title: meal,
                      value: _selectedMeals.contains(meal),
                      onChanged: (value) => _toggleMeal(meal, value),
                    ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // STAR RATING
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Star Rating'),
                  SizedBox(height: 6.h),
                  for (int stars = 5; stars >= 1; stars--)
                    _buildStarCheckboxRow(stars),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // PAYMENT AND BOOKING
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Payment and booking'),
                  SizedBox(height: 6.h),
                  _buildCheckboxRow(
                    title: 'Free cancellation available',
                    value: _freeCancellation,
                    onChanged: (value) =>
                        setState(() => _freeCancellation = value),
                  ),
                  _buildCheckboxRow(
                    title: 'Pay now',
                    value: _payNow,
                    onChanged: (value) => setState(() => _payNow = value),
                  ),
                  _buildCheckboxRow(
                    title: 'Pay on the spot',
                    value: _payOnSpot,
                    onChanged: (value) => setState(() => _payOnSpot = value),
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // LOCATION
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Location'),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From the city center',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                        ),
                      ),
                      Text(
                        '${_maxDistance.round()} km',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _primaryDark,
                        ),
                      ),
                    ],
                  ),
                  _buildStyledSlider(
                    value: _maxDistance.clamp(0, 50),
                    min: 0,
                    max: 50,
                    onChanged: (value) => setState(() => _maxDistance = value),
                  ),
                  _buildCheckboxRow(
                    title: 'Near the metro',
                    value: _nearMetro,
                    onChanged: (value) => setState(() => _nearMetro = value),
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // REVIEWS RATING
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Reviews rating'),
                  SizedBox(height: 6.h),
                  for (final rating in [
                    '9 and higher',
                    '8 and higher',
                    '7 and higher',
                    '6 and higher',
                    '5 and higher',
                  ])
                    _buildCheckboxRow(
                      title: rating,
                      value: _selectedGuestRatings.contains(rating),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedGuestRatings.add(rating)
                              : _selectedGuestRatings.remove(rating);
                        });
                      },
                    ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // PRICE
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Price for a night in INR'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _priceField(
                          label: 'Min Price',
                          controller: _minPriceController,
                          onChanged: (value) {
                            setState(() {
                              _minPrice = value.clamp(0, _maxPrice).toDouble();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _priceField(
                          label: 'Max Price',
                          controller: _maxPriceController,
                          onChanged: (value) {
                            setState(() {
                              _maxPrice =
                                  value.clamp(_minPrice, 500000).toDouble();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildStyledRangeSlider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'INR 0',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _textSecondary,
                        ),
                      ),
                      Text(
                        'INR 500,000',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // FACILITIES AND SERVICES
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Facilities and Services'),
                  SizedBox(height: 12.h),
                  _uppercaseLabelText('IN THE HOTEL'),
                  SizedBox(height: 6.h),
                  for (final facility in [
                    'Free Internet',
                    'Transfer',
                    'Parking',
                    'Swimming Pool',
                    'Fitness centre',
                    'Bar or restaurant',
                    'Conference hall',
                    'Spa Services',
                    'Ski slope nearby',
                    'Beach nearby',
                    'Jacuzzi',
                    if (_showMoreFacilities) ...[
                      '24-hour front desk',
                      'Luggage storage',
                      'Laundry service',
                      'Room service',
                      'Currency exchange',
                      'Tour desk',
                      'Concierge service',
                      'Family rooms',
                      'Non-smoking rooms',
                      'Elevator',
                      'Daily housekeeping',
                    ],
                  ])
                    _buildCheckboxRow(
                      title: facility,
                      value: _selectedFacilities.contains(facility),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedFacilities.add(facility)
                              : _selectedFacilities.remove(facility);
                        });
                      },
                    ),
                  SizedBox(height: 6.h),
                  _buildShowMoreLabel(
                    _showMoreFacilities ? 'Show less' : 'Show 11 more',
                    onTap: () => setState(
                            () => _showMoreFacilities = !_showMoreFacilities),
                    expanded: _showMoreFacilities,
                  ),
                  SizedBox(height: 8.h),
                  const Divider(height: 1, color: _border),
                  SizedBox(height: 16.h),
                  _uppercaseLabelText('IN THE ROOM'),
                  SizedBox(height: 6.h),
                  for (final feature in [
                    'Air-conditioning',
                    'Private Bathroom',
                    'Kitchen',
                    'Balcony',
                  ])
                    _buildCheckboxRow(
                      title: feature,
                      value: _selectedRoomFeatures.contains(feature),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedRoomFeatures.add(feature)
                              : _selectedRoomFeatures.remove(feature);
                        });
                      },
                    ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // ACCOMMODATION FEATURES
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Accommodation features'),
                  SizedBox(height: 6.h),
                  for (final feature in [
                    'Suitable for children',
                    'For guests with disabilities',
                    'Pets allowed',
                    'Smoking allowed',
                  ])
                    _buildCheckboxRow(
                      title: feature,
                      value: _selectedAccommodationFeatures.contains(feature),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedAccommodationFeatures.add(feature)
                              : _selectedAccommodationFeatures.remove(feature);
                        });
                      },
                    ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // CERTIFICATES
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Certificates'),
                  SizedBox(height: 6.h),
                  _buildCheckboxRow(
                    title: 'Sustainability certification',
                    value: _sustainabilityCertification,
                    onChanged: (value) =>
                        setState(() => _sustainabilityCertification = value),
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // PROPERTY TYPE
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Property Type'),
                  SizedBox(height: 6.h),
                  for (final type in [
                    'Hotels',
                    'Hostels',
                    'Apartments',
                    'Apartment hotels',
                    'Guesthouses',
                    if (_showMorePropertyTypes) ...[
                      'Bed and breakfasts',
                      'Homestays',
                      'Holiday homes',
                      'Lodges',
                      'Motels',
                      'Farm stays',
                    ],
                  ])
                    _buildCheckboxRow(
                      title: type,
                      value: _selectedPropertyTypes.contains(type),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedPropertyTypes.add(type)
                              : _selectedPropertyTypes.remove(type);
                        });
                      },
                    ),
                  SizedBox(height: 4.h),
                  _buildShowMoreLabel(
                    _showMorePropertyTypes ? 'Show less' : 'Show 6 more',
                    onTap: () => setState(() =>
                    _showMorePropertyTypes = !_showMorePropertyTypes),
                    expanded: _showMorePropertyTypes,
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // NUMBER OF ROOMS
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Number of Rooms'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (int room = 1; room <= 6; room++)
                        _buildRoomChoice(room),
                    ],
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // TYPE OF BED
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Type of Bed'),
                  SizedBox(height: 6.h),
                  for (final bed in ['Double bed', 'Separate beds'])
                    _buildCheckboxRow(
                      title: bed,
                      value: _selectedBedTypes.contains(bed),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedBedTypes.add(bed)
                              : _selectedBedTypes.remove(bed);
                        });
                      },
                    ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // BRANDS
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Brands'),
                  SizedBox(height: 6.h),
                  for (final brand in [
                    'Accor Hotels',
                    'Ibis',
                    'Mercure',
                    'Ibis Styles',
                    'Adagio Aparthotel Access',
                    'Hilton',
                    'Marriott',
                    'Radisson Blu',
                    'Best Western',
                    'NH Hotels',
                    if (_showAllBrands) ...[
                      'Holiday Inn',
                      'Crowne Plaza',
                      'Sheraton',
                      'Wyndham',
                      'Novotel',
                      'Hyatt',
                      'InterContinental',
                      'DoubleTree',
                      'Sofitel',
                      'Pullman',
                    ],
                  ])
                    _buildCheckboxRow(
                      title: brand,
                      value: _selectedBrands.contains(brand),
                      onChanged: (value) {
                        setState(() {
                          value
                              ? _selectedBrands.add(brand)
                              : _selectedBrands.remove(brand);
                        });
                      },
                    ),
                  SizedBox(height: 4.h),
                  _buildShowMoreLabel(
                    _showAllBrands ? 'Show less' : 'Show 10 more',
                    onTap: () =>
                        setState(() => _showAllBrands = !_showAllBrands),
                    expanded: _showAllBrands,
                  ),
                ],
              ),
            ),

            _cardGap(),

            // ==================================================
            // NEAREST METRO STATION
            // ==================================================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Nearest Metro Station'),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _nearestMetroController,
                    style: GoogleFonts.inter(fontSize: 14.sp, color: _primaryDark),
                    decoration: _inputDecoration(hintText: 'Metro station'),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM BAR — sticky 96px, white, top border, full-width
      // 52px rounded 14 button, bg #EF4444
      // ========================================================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: DS.card,
          border: Border(top: BorderSide(color: _border, width: 1)),
        ),
        child: SafeArea(
          minimum: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: SizedBox(
            height: 48.h,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: _active,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DS.radiusButton.r),
                ),
              ),
              child: Text(
                'Apply Filters ($_filterCount properties)',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  Widget _cardGap() => SizedBox(height: 14.h);

  Widget _priceField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(fontSize: 14.sp, color: _primaryDark),
          decoration: _inputDecoration(),
          onChanged: (text) {
            final parsed = double.tryParse(text);
            if (parsed != null) onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildRoomChoice(int room) {
    final selected = _selectedRoomCounts.contains(room);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            _selectedRoomCounts.remove(room);
          } else {
            _selectedRoomCounts.add(room);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? _active : DS.card,
          borderRadius: BorderRadius.circular(DS.radiusPill.r),
          border: Border.all(
            color: selected ? _active : _border,
            width: 1,
          ),
        ),
        child: Text(
          '$room ${room == 1 ? 'room' : 'rooms'}',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : _checkboxText,
          ),
        ),
      ),
    );
  }

  Widget _buildShowMoreLabel(
      String text, {
        required VoidCallback onTap,
        bool expanded = false,
      }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              color: _active,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 18.r,
            color: _active,
          ),
        ],
      ),
    );
  }

  Widget _uppercaseLabelText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: _uppercaseLabel,
        letterSpacing: 0.88,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: _border, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: _primaryDark,
      ),
    );
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(color: DS.textTertiary, fontSize: 14.sp),
      filled: true,
      fillColor: _inputBg,
      constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _inputBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: _active, width: 1),
      ),
    );
  }

  // Custom toggle switch — 60x32, gray OFF / red ON
  Widget _buildToggleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 60.w,
        height: 32.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: value ? _active : const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 26.w,
          height: 26.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom checkbox — 22x22, rounded 6, red fill + white tick when checked
  Widget _buildCheckboxRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            _checkboxBox(value),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: _checkboxText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkboxBox(bool value) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 22.w,
      height: 22.h,
      decoration: BoxDecoration(
        color: value ? _active : DS.card,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: value ? _active : DS.borderMedium,
          width: 1.5,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: 16.r, color: Colors.white)
          : null,
    );
  }

  Widget _buildStarCheckboxRow(int stars) {
    final value = _selectedStarRatings.contains(stars);
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (value) {
              _selectedStarRatings.remove(stars);
            } else {
              _selectedStarRatings.add(stars);
            }
          });
        },
        child: Row(
          children: [
            _checkboxBox(value),
            SizedBox(width: 12.w),
            Row(
              children: List.generate(
                stars,
                    (index) => Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: Icon(Icons.star, size: 18.r, color: DS.starYellow),
                ),
              ),
            ),
            if (stars == 1) ...[
              SizedBox(width: 6.w),
              Text(
                'or without star rating',
                style: GoogleFonts.inter(fontSize: 13.sp, color: _textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStyledSlider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        activeTrackColor: _active,
        inactiveTrackColor: _inputBorder,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 3,
        ),
        thumbColor: Colors.white,
        overlayColor: _active.withValues(alpha: 0.15),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStyledRangeSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6,
        activeTrackColor: _active,
        inactiveTrackColor: _inputBorder,
        thumbColor: Colors.white,
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 3,
        ),
        overlayColor: _active.withValues(alpha: 0.15),
      ),
      child: RangeSlider(
        values: RangeValues(_minPrice, _maxPrice),
        min: 0,
        max: 500000,
        labels: RangeLabels(
          'INR ${_minPrice.round()}',
          'INR ${_maxPrice.round()}',
        ),
        onChanged: (values) {
          setState(() {
            _minPrice = values.start;
            _maxPrice = values.end;
            _minPriceController.text = _minPrice.round().toString();
            _maxPriceController.text = _maxPrice.round().toString();
          });
        },
      ),
    );
  }

  void _toggleMeal(String meal, bool value) {
    setState(() {
      if (value) {
        _selectedMeals.add(meal);
      } else {
        _selectedMeals.remove(meal);
      }
    });
  }
}