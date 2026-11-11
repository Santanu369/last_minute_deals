import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';
import 'package:lmd_app/features/payment/presentation/cubit/cashfree/cashfree_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/cashfree/cashfree_state.dart';
import 'package:lmd_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/payment_state.dart';
import 'package:lmd_app/features/payment/presentation/cubit/stay_quote_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/stay_quote_state.dart';
import 'package:lmd_app/features/payment/presentation/pages/payment_checkout_page.dart';
import 'package:lmd_app/features/booking/presentation/pages/bookings_history_page.dart';
import 'package:lmd_app/features/booking/presentation/pages/app_date_time.dart';
import 'package:lmd_app/core/utils/app_snackbar.dart';

class YourSelectionPage extends StatefulWidget {
  final String stayName;
  final String listingId;
  final String dealId;
  final String sku;
  final String variantId;
  final String provider;
  final String paymentMethod;
  final String dateRange;
  final double price;
  final double basePrice;
  final String imagePath;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int rooms;
  final int adults;
  final int children;
  final int initialTabIndex;
  final String? initialGuestName;
  final String? initialGuestEmail;
  final String? initialGuestPhone;
  final String? initialArrivalPreference;

  const YourSelectionPage({
    super.key,
    required this.paymentMethod,
    required this.sku,
    required this.listingId,
    required this.dealId,
    required this.variantId,
    required this.provider,
    required this.dateRange,
    required this.stayName,
    required this.price,
    required this.basePrice,
    required this.imagePath,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.children,
    this.initialTabIndex = 0,
    this.initialGuestName,
    this.initialGuestEmail,
    this.initialGuestPhone,
    this.initialArrivalPreference,
  });

  @override
  State<YourSelectionPage> createState() => _YourSelectionPageState();
}

class _YourSelectionPageState extends State<YourSelectionPage> {
  // Navigation tabs: 0: Cart, 1: Guests, 2: Payment
  late int _currentTabIndex;

  // Cart & Pricing state
  int rooms = 1;
  bool _isUpdatingRooms = false;
  bool _couponApplied = false;
  final TextEditingController _couponController = TextEditingController();
  final NumberFormat _formatter = NumberFormat('#,##,###');

  // Guest Details controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Payment controllers
  final cardholderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();

  String? selectedArrivalPreference = 'FLEXIBLE';
  final arrivalPreferences = {
    "I'm flexible": 'FLEXIBLE',
    'Early morning (8 AM - 11 AM)': 'EARLY_MORNING_8_11',
    'Late morning (11 AM - 2 PM)': 'LATE_MORNING_11_14',
    'Afternoon (2 PM - 5 PM)': 'AFTERNOON_14_17',
    'Evening (5 PM - 8 PM)': 'EVENING_17_20',
    'Late Evening (8 PM - 11 PM)': 'LATE_EVENING_20_23',
  };

  String selectedPaymentMethod = 'card';
  String? _bookingId;
  bool _isPaying = false;
  final CFPaymentGatewayService _cfPaymentGatewayService = CFPaymentGatewayService();

  // Design tokens
  static const Color _kBg = DS.background;
  static const Color _kBorder = DS.borderLight; // cards, header, bottom bar
  static const Color _kInputBorder = DS.borderMedium; // inputs, quantity pill
  static const Color _kDark = DS.textPrimary;
  static const Color _kGray = DS.textSecondary;
  static const Color _kPlaceholder = DS.textTertiary;
  static const Color _kRed = DS.accentRed;
  static const Color _kPillBg = Color(0xFFF0F1F5); // stepper / chips
  static const Color _kInputBg = DS.card;
  static const Color _kGreenBg = DS.successLight;
  static const Color _kGreenText = DS.success;
  static const Color _kOrange = DS.accentRed;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    rooms = widget.rooms;

    _cfPaymentGatewayService.setCallback(verifyPayment, onError);

    selectedPaymentMethod = widget.paymentMethod.toLowerCase() == 'cod' ? 'cod' : 'card';

    if (widget.initialGuestEmail != null && widget.initialGuestEmail!.isNotEmpty) {
      emailController.text = widget.initialGuestEmail!;
    }
    if (widget.initialGuestPhone != null && widget.initialGuestPhone!.isNotEmpty) {
      phoneController.text = widget.initialGuestPhone!;
    }
    if (widget.initialGuestName != null && widget.initialGuestName!.isNotEmpty) {
      fullNameController.text = widget.initialGuestName!;
      final parts = fullNameController.text.split(' ');
      if (parts.isNotEmpty) {
        firstNameController.text = parts.first;
        if (parts.length > 1) {
          lastNameController.text = parts.sublist(1).join(' ');
        }
      }
    }
    if (widget.initialArrivalPreference != null && widget.initialArrivalPreference!.isNotEmpty) {
      selectedArrivalPreference = widget.initialArrivalPreference;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState.status == AuthStatus.authenticated && authState.user != null) {
      if (fullNameController.text.isEmpty) {
        fullNameController.text =
            '${authState.user!.firstName} ${authState.user!.lastName}'.trim();
      }
      if (emailController.text.isEmpty) {
        emailController.text = authState.user!.email;
      }
      if (firstNameController.text.isEmpty) {
        final parts = fullNameController.text.split(' ');
        if (parts.isNotEmpty) {
          firstNameController.text = parts.first;
          if (parts.length > 1) {
            lastNameController.text = parts.sublist(1).join(' ');
          }
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StayQuoteCubit>().getStayQuote(
        listingId: widget.listingId,
        dealId: widget.dealId,
        sku: widget.sku,
        checkIn: AppDateTime.checkInApi,
        checkOut: AppDateTime.checkOutApi,
        rooms: rooms,
      );
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    cardholderNameController.dispose();
    cardNumberController.dispose();
    cardExpiryController.dispose();
    super.dispose();
  }

  Future<void> _refreshQuote() async {
    await context.read<StayQuoteCubit>().getStayQuote(
      listingId: widget.listingId,
      dealId: widget.dealId,
      sku: widget.sku,
      checkIn: AppDateTime.checkInApi,
      checkOut: AppDateTime.checkOutApi,
      rooms: rooms,
    );
  }

  void _incrementQuantity() async {
    if (_isUpdatingRooms) return;
    if (rooms >= 10) {
      AppSnackbar.showError(context, 'Maximum 10 rooms allowed');
      return;
    }
    setState(() {
      _isUpdatingRooms = true;
      rooms++;
    });
    await _refreshQuote();
    if (mounted) {
      setState(() {
        _isUpdatingRooms = false;
      });
    }
  }

  void _decrementQuantity() async {
    if (_isUpdatingRooms) return;
    if (rooms <= 1) {
      AppSnackbar.showError(context, 'Minimum 1 room required');
      return;
    }
    setState(() {
      _isUpdatingRooms = true;
      rooms--;
    });
    await _refreshQuote();
    if (mounted) {
      setState(() {
        _isUpdatingRooms = false;
      });
    }
  }

  void verifyPayment(String orderId) {
    if (_bookingId != null) {
      context.read<CashfreeCubit>().syncPayment(bookingId: _bookingId!);
    }
    if (mounted) {
      setState(() {
        _isPaying = false;
      });
    }
  }

  void onError(CFErrorResponse error, String orderId) {
    if (mounted) {
      setState(() {
        _isPaying = false;
      });
    }
    if (_bookingId != null) {
      context.read<CashfreeCubit>().syncPayment(bookingId: _bookingId!);
    }
  }

  void _openBookingVerify({required String status}) {
    final bookingId = _bookingId;
    if (bookingId == null || !mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BookingsHistoryPage()),
    );
  }

  Future<void> _openCashfree({
    required String orderId,
    required String paymentSessionId,
  }) async {
    try {
      final session = CFSessionBuilder()
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .setEnvironment(CFEnvironment.SANDBOX)
          .build();

      final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();
      _cfPaymentGatewayService.doPayment(payment);
    } catch (e) {
      debugPrint('CASHFREE SDK ERROR: $e');
    }
  }

  bool _validateGuestDetails() {
    if (firstNameController.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'First Name is required');
      setState(() => _currentTabIndex = 1);
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Last Name is required');
      setState(() => _currentTabIndex = 1);
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Email Address is required');
      setState(() => _currentTabIndex = 1);
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Phone Number is required');
      setState(() => _currentTabIndex = 1);
      return false;
    }
    return true;
  }

  void _submitCheckout() {
    if (!_validateGuestDetails()) return;

    setState(() {
      _isPaying = true;
    });

    fullNameController.text =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();

    final body = {
      'listing_id': widget.listingId,
      'variant_id': widget.variantId,
      'deal_id': widget.dealId,
      'sku': widget.sku,
      'provider': widget.provider,
      'payment_method': selectedPaymentMethod == 'cod' ? 'cod' : 'cashfree',
      'stay': {
        'check_in': AppDateTime.checkInApi,
        'check_out': AppDateTime.checkOutApi,
        'rooms': rooms,
        'adults': widget.adults,
        'children': widget.children,
      },
      'guest': {
        'full_name': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'arrival_preference': selectedArrivalPreference ?? 'FLEXIBLE',
      }
    };

    context.read<PaymentCubit>().checkoutStay(body: body);
  }

  void _handleBottomButtonTap(double totalAmount) {
    if (_currentTabIndex == 0) {
      // Advance to Guests tab
      setState(() {
        _currentTabIndex = 1;
      });
    } else if (_currentTabIndex == 1) {
      // Validate Guests and advance to Payment tab
      if (_validateGuestDetails()) {
        setState(() {
          _currentTabIndex = 2;
        });
      }
    } else {
      // On Payment tab, submit booking
      _submitCheckout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quoteState = context.watch<StayQuoteCubit>().state;

    int nightCount = widget.checkOutDate.difference(widget.checkInDate).inDays;
    if (nightCount <= 0) nightCount = 1;

    double originalPricePerNight = widget.basePrice > 0 ? widget.basePrice : widget.price;
    double originalSubtotal = originalPricePerNight * rooms * nightCount;
    double discountedSubtotal = quoteState is StayQuoteLoaded
        ? quoteState.quote.nightsSubtotal.toDouble()
        : (widget.price * rooms * nightCount);

    double propertyDiscount = originalSubtotal - discountedSubtotal;
    if (propertyDiscount < 0) propertyDiscount = 0;

    int discountPercentage = originalPricePerNight > 0
        ? (((originalPricePerNight - widget.price) / originalPricePerNight) * 100).round()
        : 0;

    double itemTotal = originalSubtotal;
    double couponDiscount = _couponApplied ? 4100.0 : 0.0;

    double taxes = quoteState is StayQuoteLoaded
        ? (quoteState.quote.total - quoteState.quote.nightsSubtotal).toDouble()
        : (widget.price * rooms * nightCount) * 0.18;

    double totalAmount = itemTotal - propertyDiscount - couponDiscount + taxes;
    if (totalAmount < 0) totalAmount = 0;

    String checkInStr = DateFormat('MMM d').format(widget.checkInDate);
    String checkOutStr = DateFormat('MMM d').format(widget.checkOutDate);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWidescreen = screenWidth > 450;

    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is CheckoutSuccess) {
              _bookingId = state.response.bookingId;

              if (selectedPaymentMethod == 'cod') {
                _openBookingVerify(status: 'PENDING');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentCheckoutPage(
                      bookingId: _bookingId!,
                      totalAmount: totalAmount,
                      stayName: widget.stayName,
                      guestEmail: emailController.text.trim(),
                      guestPhone: phoneController.text.trim(),
                    ),
                  ),
                ).then((_) {
                  if (mounted) {
                    setState(() {
                      _isPaying = false;
                    });
                  }
                });
              }
            }

            if (state is PaymentError) {
              if (mounted) {
                setState(() {
                  _isPaying = false;
                });
              }
              AppSnackbar.showError(context, state.message);
            }
          },
        ),
        BlocListener<CashfreeCubit, CashfreeState>(
          listener: (context, state) async {
            if (state is CashfreeSessionReady) {
              await _openCashfree(
                orderId: state.session.orderId,
                paymentSessionId: state.session.paymentSessionId,
              );
            }

            if (state is CashfreeSuccess) {
              if (state.response.paymentStatus == 'PAID') {
                _openBookingVerify(status: 'COMPLETED');
              } else if (state.response.paymentStatus == 'PENDING') {
                if (mounted) setState(() => _isPaying = false);
                _openBookingVerify(status: 'PENDING');
              } else {
                if (mounted) setState(() => _isPaying = false);
                _openBookingVerify(status: 'FAILED');
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isWidescreen ? 24.0 : 0.0,
                horizontal: isWidescreen ? 16.0 : 0.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isWidescreen ? 32 : 0),
                    border: isWidescreen ? Border.all(color: _kBorder, width: 1) : null,
                    boxShadow: isWidescreen
                        ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                        : null,
                  ),
                  clipBehavior: isWidescreen ? Clip.antiAlias : Clip.none,
                  child: Column(
                    children: [
                      // Header 56px white, border bottom 1px #E5E7EB
                      _buildHeader(),

                      // Segmented Tabs: Cart / Guests / Payment
                      _buildSegmentedTabs(),

                      // Tab Content
                      Expanded(
                        child: Container(
                          color: _kBg,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_currentTabIndex == 0) ...[
                                  // CART TAB
                                  SizedBox(height: 12.h),
                                  _buildCartCard(nightCount, checkInStr, checkOutStr, itemTotal),
                                  _buildSavingCornerHeader(),
                                  if (_couponApplied) _buildCouponAppliedCard(couponDiscount),
                                  _buildCouponInput(),
                                  _buildBillDetails(
                                    itemTotal: itemTotal,
                                    propertyDiscount: propertyDiscount,
                                    couponDiscount: couponDiscount,
                                    taxes: taxes,
                                    totalAmount: totalAmount,
                                    discountPercentage: discountPercentage,
                                  ),
                                  SizedBox(height: 24.h),
                                ] else if (_currentTabIndex == 1) ...[
                                  // GUESTS TAB
                                  _buildGuestsHeader(),
                                  _buildContactDetailsCard(),
                                  _buildRoomGuestCard(),
                                  SizedBox(height: 24.h),
                                ] else ...[
                                  // PAYMENT TAB
                                  _buildPaymentHeader(),
                                  _buildPaymentMethodsCard(),
                                  _buildSecurityInfo(),
                                  SizedBox(height: 24.h),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Sticky Bottom Bar
                      _buildBottomBar(totalAmount),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================
  Widget _buildHeader() {
    return Container(
      height: 56.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (_currentTabIndex > 0) {
                  setState(() => _currentTabIndex--);
                } else {
                  Navigator.pop(context);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: Icon(Icons.arrow_back, size: 22.r, color: _kDark),
              ),
            ),
          ),
          TranslatedText(
            text: 'Cart', style: GoogleFonts.inter( color: _kDark, fontSize: 20.sp, fontWeight: FontWeight.w700,
          ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert_rounded, size: 22.r, color: _kDark),
              splashRadius: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SEGMENTED TABS (Cart / Guests / Payment)
  // ===========================================================================
  Widget _buildSegmentedTabs() {
    final tabs = ['Cart', 'Guests', 'Payment'];
    // Cart stepper: active pill #111827 / white, others #F0F1F5 / #9CA3AF
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _currentTabIndex == index;
          return Padding(
            padding: EdgeInsets.only(
              right: index == tabs.length - 1 ? 0 : 8.w,
            ),
            child: GestureDetector(
              onTap: () {
                if (index == 2 && _currentTabIndex < 2) {
                  if (!_validateGuestDetails()) return;
                }
                setState(() => _currentTabIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? DS.textPrimary : _kPillBg,
                  borderRadius: BorderRadius.circular(DS.radiusPill.r),
                ),
                child: Text(
                  tabs[index],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : DS.textTertiary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: CART COMPONENTS
  // ===========================================================================
  Widget _buildCartCard(int nightCount, String checkInStr, String checkOutStr, double itemTotal) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.w), decoration: BoxDecoration( color: DS.card, borderRadius: BorderRadius.circular(DS.radiusCard.r), border: Border.all(color: _kBorder, width: 1), boxShadow: DS.shadowCard, ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 96x96 image with 4px outer padding, 12px inner radius & STAY badge
          Stack(
            children: [
              Container(
                width: 96.w,
                height: 96.h,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: _kPillBg,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.imagePath,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: _kPillBg,
                      child: Icon(Icons.hotel_rounded, color: _kPlaceholder, size: 32.r),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _kRed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: TranslatedText(
                    text: 'STAY',
                    style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w700, letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Content Row gap 12px
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  text: widget.stayName, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter( color: _kDark, fontSize: 15.sp, fontWeight: FontWeight.w600,
                ),
                ),
                SizedBox(height: 4.h),
                TranslatedText(
                  text: '$nightCount Night${nightCount > 1 ? 's' : ''} • $checkInStr - $checkOutStr', style: GoogleFonts.inter( color: _kGray, fontSize: 12.sp, fontWeight: FontWeight.w400,
                ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Quantity pill: bg #F9FAFB border 1px #E5E7EB radius 24px height 32px width 88px
                    Container(
                      height: 32.h,
                      width: 88.w,
                      decoration: BoxDecoration(
                        color: DS.card, borderRadius: BorderRadius.circular(DS.radiusPill.r), border: Border.all(color: _kInputBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _decrementQuantity,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                              child: TranslatedText(
                                text: '—', style: GoogleFonts.inter( color: _kDark, fontSize: 14.sp, fontWeight: FontWeight.w500,
                              ),
                              ),
                            ),
                          ),
                          TranslatedText(
                            text: rooms.toString().padLeft(2, '0'), style: GoogleFonts.inter( color: _kDark, fontSize: 14.sp, fontWeight: FontWeight.w500,
                          ),
                          ),
                          GestureDetector(
                            onTap: _incrementQuantity,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                              child: Text(
                                '+', style: GoogleFonts.inter( color: _kDark, fontSize: 14.sp, fontWeight: FontWeight.w500,
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price 16px bold
                    TranslatedText(
                      text: '₹${_formatter.format(itemTotal)}',
                      style: GoogleFonts.inter(
                        color: _kDark,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingCornerHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 18.r, color: _kOrange),
                SizedBox(width: 8.w),
                Flexible(
                  child: TranslatedText(
                    text: 'Saving Corner', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter( color: _kDark, fontSize: 16.sp, fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: TranslatedText(
              text: 'VIEW ALL COUPONS',
              style: GoogleFonts.inter(
                color: _kRed,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponAppliedCard(double couponDiscount) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _kBorder, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E8), borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.local_offer_rounded, color: DS.accentRed, size: 18.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  text: 'COUPON APPLIED',
                  style: GoogleFonts.inter(
                    color: _kRed, fontSize: 12.sp, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                TranslatedText(
                  text: 'You saved ₹${_formatter.format(couponDiscount)} on this booking',
                  style: GoogleFonts.inter(
                    color: _kGray,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _couponApplied = false;
              });
            },
            child: TranslatedText(
              text: 'REMOVE',
              style: GoogleFonts.inter(
                color: _kRed, fontSize: 12.sp, fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponInput() {
    return Container(
      height: 48.h, margin: EdgeInsets.symmetric(horizontal: 16.w), padding: EdgeInsets.symmetric(horizontal: 16.w), decoration: BoxDecoration( color: DS.card, borderRadius: BorderRadius.circular(DS.radiusButton.r), border: Border.all(color: _kInputBorder, width: 1),
    ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              style: GoogleFonts.inter(
                color: _kDark,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: 'Enter coupon code',
                hintStyle: GoogleFonts.inter(
                  color: _kPlaceholder,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final code = _couponController.text.trim().toUpperCase();
              if (code.isNotEmpty) {
                if (code == 'WELCOME100' || code == 'LMD100' || code == 'FESTIVE') {
                  setState(() {
                    _couponApplied = true;
                  });
                  AppSnackbar.showError(context, 'Coupon applied successfully!');
                } else {
                  AppSnackbar.showError(context, 'Invalid Coupon Code');
                }
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: TranslatedText(
                text: 'APPLY',
                style: GoogleFonts.inter(
                  color: _kRed,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails({
    required double itemTotal,
    required double propertyDiscount,
    required double couponDiscount,
    required double taxes,
    required double totalAmount,
    required int discountPercentage,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text: 'Bill Details', style: GoogleFonts.inter( color: _kDark, fontSize: 14.sp, fontWeight: FontWeight.w700,
          ),
          ),
          SizedBox(height: 14.h),
          _buildBillRow('Item Total', '₹${_formatter.format(itemTotal)}'),
          if (propertyDiscount > 0)
            _buildBillRow(
              'Property Discount ($discountPercentage% OFF)',
              '-₹${_formatter.format(propertyDiscount)}',
              isNegative: true,
            ),
          if (_couponApplied && couponDiscount > 0)
            _buildBillRow(
              'Coupon Discount',
              '-₹${_formatter.format(couponDiscount)}',
              isNegative: true,
            ),
          _buildBillRow('Taxes & Service Fees', '₹${_formatter.format(taxes)}'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: _kPillBg, height: 1, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    text: 'TOTAL AMOUNT', style: GoogleFonts.inter( color: DS.textTertiary, fontSize: 11.sp, fontWeight: FontWeight.w500, letterSpacing: 0.88,
                  ),
                  ),
                  SizedBox(height: 4.h),
                  TranslatedText(
                    text: '₹${_formatter.format(totalAmount)}',
                    style: GoogleFonts.inter(
                      color: _kDark,
                      fontSize: 24.sp, fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h), decoration: BoxDecoration( color: _kGreenBg, borderRadius: BorderRadius.circular(DS.radiusPill.r),
              ),
                child: TranslatedText(
                  text: 'NO CONVENIENCE FEE',
                  style: GoogleFonts.inter(
                    color: _kGreenText, fontSize: 10.sp, fontWeight: FontWeight.w700, letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isNegative = false}) {
    return SizedBox(
      height: 36.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TranslatedText(
              text: label, style: GoogleFonts.inter( color: _kGray, fontSize: 13.sp, fontWeight: FontWeight.w400,
            ),
            ),
          ),
          SizedBox(width: 8.w),
          TranslatedText(
            text: value,
            style: GoogleFonts.inter(
              color: isNegative ? DS.success : _kDark,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 2: GUESTS COMPONENTS
  // ===========================================================================
  Widget _buildGuestsHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text: 'Complete Your Booking',
            style: GoogleFonts.inter(
              color: _kDark,
              fontSize: 20.sp, fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          TranslatedText(
            text: 'Secure ${widget.stayName} for your upcoming stay.', style: GoogleFonts.inter( color: _kGray, fontSize: 14.sp, fontWeight: FontWeight.w400,
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: _kRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '1',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              TranslatedText(
                text: 'Contact Details',
                style: GoogleFonts.inter(
                  color: _kDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: DS.borderLight, height: 1, thickness: 1),
          SizedBox(height: 16.h),
          _buildFieldLabel('EMAIL ADDRESS *'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: emailController,
            hint: 'john@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),
          _buildFieldLabel('PHONE NUMBER *'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: phoneController,
            hint: '+91 9876543210',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),
          _buildFieldLabel('ARRIVAL PREFERENCE'),
          SizedBox(height: 6.h),
          _buildArrivalPreferenceDropdown(),
        ],
      ),
    );
  }

  Widget _buildRoomGuestCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: _kRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '2',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TranslatedText (
                  text: 'Room 1 Details (${widget.adults} Adults, ${widget.children} Children)',
                  style: GoogleFonts.inter(
                    color: _kDark,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: DS.borderLight, height: 1, thickness: 1),
          SizedBox(height: 16.h),
          _buildFieldLabel('ADULT 1 - FIRST NAME *'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: firstNameController,
            hint: 'John',
          ),
          SizedBox(height: 16.h),
          _buildFieldLabel('ADULT 1 - LAST NAME *'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: lastNameController,
            hint: 'Doe',
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return TranslatedText (
      text: label,
      style: GoogleFonts.inter(
        color: DS.textTertiary, fontSize: 11.sp, fontWeight: FontWeight.w500, letterSpacing: 0.88,
      ),
    );
  }

  Widget _buildCleanInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: _kInputBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _kInputBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          color: _kDark,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: _kPlaceholder,
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildArrivalPreferenceDropdown() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: _kInputBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _kInputBorder, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedArrivalPreference,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _kRed,
            size: 18.r,
          ),
          style: GoogleFonts.inter(
            color: _kDark,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          items: arrivalPreferences.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: TranslatedText(text: entry.key),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedArrivalPreference = value);
            }
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 3: PAYMENT COMPONENTS
  // ===========================================================================
  Widget _buildPaymentHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text:'Payment Details',
            style: GoogleFonts.inter(
              color: _kDark,
              fontSize: 20.sp, fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          TranslatedText(
            text: 'Choose your preferred payment method below.', style: GoogleFonts.inter( color: _kGray, fontSize: 14.sp, fontWeight: FontWeight.w400,
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: _kBorder, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: _kRed,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: TranslatedText(
                  text: '3',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Payment Method',
                style: GoogleFonts.inter(
                  color: _kDark,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(color: DS.borderLight, height: 1, thickness: 1),
          SizedBox(height: 16.h),
          _buildPaymentOptionTile(
            id: 'card',
            label: 'Credit / Debit Card',
            icon: Icons.credit_card_outlined,
          ),
          SizedBox(height: 10.h),
          _buildPaymentOptionTile(
            id: 'upi',
            label: 'UPI Instant Payment',
            icon: Icons.account_balance_wallet_outlined,
          ),
          SizedBox(height: 10.h),
          _buildPaymentOptionTile(
            id: 'cod',
            label: 'Pay at Hotel Counter',
            icon: Icons.storefront_outlined,
          ),
          SizedBox(height: 20.h),
          _buildSelectedPaymentDetails(),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isSelected = selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = id;
        });
      },
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? DS.successLight : DS.card, borderRadius: BorderRadius.circular(14.r), border: Border.all( color: isSelected ? DS.success : _kBorder,
          width: isSelected ? 1.5 : 1,
        ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.r,
              color: isSelected ? _kDark : _kGray,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TranslatedText(
                text: label,
                style: GoogleFonts.inter(
                  color: isSelected ? _kDark : DS.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all( color: isSelected ? DS.success : _kInputBorder, width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPaymentDetails() {
    if (selectedPaymentMethod == 'card') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('CARDHOLDER NAME'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: cardholderNameController,
            hint: 'Name on card',
          ),
          SizedBox(height: 14.h),
          _buildFieldLabel('CARD NUMBER'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: cardNumberController,
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 14.h),
          _buildFieldLabel('EXPIRY DATE'),
          SizedBox(height: 6.h),
          _buildCleanInputField(
            controller: cardExpiryController,
            hint: 'MM / YY',
          ),
        ],
      );
    } else if (selectedPaymentMethod == 'upi') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: DS.background, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: _kBorder, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.bolt_rounded, color: DS.primaryBlue, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: TranslatedText(
                text:'Supports Google Pay, PhonePe, Paytm, BHIM and all major UPI apps via Cashfree Payment Gateway.',
                style: GoogleFonts.inter(
                  color: DS.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: DS.background, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: _kBorder, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline_rounded, color: DS.success, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: TranslatedText(
                text: 'No advance online payment required. Pay the full amount directly at the hotel counter during check-in using Cash, Card, or UPI.',
                style: GoogleFonts.inter(
                  color: DS.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSecurityInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _kBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: DS.success, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: TranslatedText(
              text: 'Your payment information is encrypted and securely processed. We never store your full card details or CVV.',
              style: GoogleFonts.inter(
                color: _kGray,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STICKY BOTTOM BAR
  // ===========================================================================
  Widget _buildBottomBar(double totalAmount) {
    String buttonText = 'Proceed to Pay ₹${_formatter.format(totalAmount)} →';
    if (_currentTabIndex == 1) {
      buttonText = 'Continue to Payment →';
    } else if (_currentTabIndex == 2) {
      buttonText = selectedPaymentMethod == 'cod'
          ? 'Confirm (Pay at Hotel) →'
          : 'Confirm & Pay ₹${_formatter.format(totalAmount)} →';
    }

    return Container(
      height: 72.h, decoration: const BoxDecoration( color: DS.card,
      border: Border(
        top: BorderSide(color: _kBorder, width: 1),
      ),
    ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), child: SizedBox( width: double.infinity, height: 48.h,
      child: ElevatedButton(
        onPressed: _isPaying ? null : () => _handleBottomButtonTap(totalAmount),
        style: ElevatedButton.styleFrom(
          backgroundColor: DS.primaryBlue, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(DS.radiusButton.r),
        ),
        ),
        child: _isPaying
            ? SizedBox(
          width: 22.w,
          height: 22.h,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : TranslatedText(
          text: buttonText,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
    );
  }
}