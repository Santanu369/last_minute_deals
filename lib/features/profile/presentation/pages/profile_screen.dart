import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/core/constants/app_images.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/widgets/user_avatar.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/pages/login_page.dart';
import 'package:lmd_app/features/booking/data/services/booking_service.dart';
import 'package:lmd_app/features/booking/presentation/cubit/booking_history_cubit.dart';
import 'package:lmd_app/features/booking/presentation/pages/bookings_history_page.dart';
import 'package:lmd_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:lmd_app/features/profile/presentation/pages/customer_support_page.dart';
import 'package:lmd_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:lmd_app/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? _bookingsCount;

  @override
  void initState() {
    super.initState();
    // Load fresh user profile details from API
    context.read<AuthCubit>().loadProfile();
    _fetchBookingsCount();
  }

  Future<void> _fetchBookingsCount() async {
    if (context.read<AuthCubit>().state.user == null) return;
    try {
      final bookings = await BookingService().getMyBookings(status: '');
      if (mounted) setState(() => _bookingsCount = bookings.length);
    } catch (e) {
      debugPrint('Error fetching bookings count: $e');
    }
  }

  String _formatDob(String dob) {
    try {
      return DateFormat('MMMM d, yyyy').format(DateTime.parse(dob));
    } catch (_) {
      return dob;
    }
  }

  Future<void> _open(String url, String name) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $name');
    }
  }

  Future<void> openInstagram() => _open(
      'https://www.instagram.com/nearby.hoteldeals?igsh=N2Nkdm5rbG84NmFs&utm_source=qr',
      'Instagram');

  Future<void> openFacebook() => _open(
      'https://www.facebook.com/people/Last-Minutes-Deal/61569357812156/?rdid=hRFzs3KCl7EqpkkM&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1K7VtbuRxN%2F',
      'Facebook');

  Future<void> openLinkedin() => _open(
      'https://www.linkedin.com/company/nearby-hotel-deals-by-last-minutes-deal/posts/?feedView=all',
      'Linkedin');

  Future<void> openX() => _open('https://x.com/LastMinutesDeal', 'X/Twitter');

  Future<void> openHosting() => _open('https://admin.lastminutessdeal.com/login', 'Hosting');

  void _openLogin() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const LoginPage()));

  void _openEditProfile() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const EditProfilePage()),
  ).then((_) {
    if (mounted) context.read<AuthCubit>().loadProfile();
  });

  Future<bool> _confirmLogout() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: DS.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DS.radiusCard.r)),
          title: Text('confirm_logout'.tr(), style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
          content: Text('are_you_sure_logout'.tr(),
              style: DS.ts(14, FontWeight.w400, DS.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('no'.tr(), style: DS.ts(14, FontWeight.w500, DS.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('yes'.tr(), style: DS.ts(14, FontWeight.w700, DS.primaryBlue)),
            ),
          ],
        ),
      ) ??
          false;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final hasDob = user?.dob != null && user!.dob!.isNotEmpty;

        return Scaffold(
          backgroundColor: DS.background,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DS.maxWidth),
              child: RefreshIndicator(
                color: DS.primaryBlue,
                onRefresh: () async {
                  await context.read<AuthCubit>().loadProfile();
                  await _fetchBookingsCount();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomPadding + 84),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: DS.card,
                          border: Border(bottom: BorderSide(color: DS.borderLight)),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            DS.screenPadding.w, topPadding + 48, DS.screenPadding.w, 20.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user?.firstName ?? "there".tr()} ${user?.lastName ?? ''}'.trim(),
                                    style: DS.ts(20, FontWeight.w700, DS.textPrimary),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    user?.email ?? 'Log in to manage your account',
                                    style: DS.ts(12, FontWeight.w400, DS.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: DS.background,
                                border: Border.all(color: DS.borderLight),
                              ),
                              child: UserAvatar(
                                imageUrl: user?.profileImage,
                                name: user?.firstName ?? '',
                                radius: 28,
                                size: 26.r,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w),
                        child: Column(
                          children: [
                            SizedBox(height: DS.screenPadding.h),

                            // 2. Quick actions: My Trips, Profile, Wishlists
                            Row(
                              children: [
                                Expanded(
                                  child: _buildQuickActionButton(
                                    icon: Icons.assignment_outlined,
                                    label: 'my_trips'.tr(),
                                    badgeText: (_bookingsCount ?? 0) > 0 ? '$_bookingsCount' : null,
                                    onTap: () {
                                      if (user == null) return _openLogin();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider<BookingHistoryCubit>(
                                            create: (_) => BookingHistoryCubit(
                                              bookingService: BookingService(),
                                            )..loadBookingHistory(),
                                            child: const BookingsHistoryPage(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: _buildQuickActionButton(
                                    icon: Icons.person_outline_rounded,
                                    label: 'profile'.tr(),
                                    onTap: () => user == null ? _openLogin() : _openEditProfile(),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: _buildQuickActionButton(
                                    icon: Icons.favorite_border_rounded,
                                    label: 'wishlists'.tr(),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => WishlistPage()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),

                            // 3. Complete your profile
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(DS.screenPadding.w),
                              decoration: DS.cardDecoration(),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'complete_your_profile'.tr(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: DS.ts(14, FontWeight.w700, DS.textPrimary),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          hasDob ? _formatDob(user.dob!) : 'add_birthday_for_perks'.tr(),
                                          style: DS.ts(12, FontWeight.w400, DS.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _openEditProfile,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 4.h),
                                      child: hasDob
                                          ? Icon(Icons.edit_rounded,
                                          color: DS.textTertiary, size: 18.r)
                                          : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('add'.tr(),
                                              style: DS.ts(13, FontWeight.w700, DS.primaryBlue)),
                                          Icon(Icons.chevron_right,
                                              color: DS.primaryBlue, size: 16.r),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // 4. Main menu
                            _buildCard(
                              Column(
                                children: [
                                  _buildListTile(
                                    icon: Icons.chat_bubble_outline_rounded,
                                    title: 'customer_support'.tr(),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const CustomerSupportPage()),
                                    ),
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.notifications_none_rounded,
                                    title: 'notifications'.tr(),
                                    onTap: () => NotificationsPage.open(context),
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.rate_review_outlined,
                                    title: 'my_reviews'.tr(),
                                    onTap: () {},
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.card_giftcard_rounded,
                                    title: 'gift_cards'.tr(),
                                    onTap: () {},
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.people_outline_rounded,
                                    title: 'refer_and_earn'.tr(),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // 5. Get started with hosting
                            _buildCard(
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: openHosting,
                                  borderRadius: BorderRadius.circular(DS.radiusCard.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(14.r),
                                          child: Image.asset(
                                            'assets/images/limitedOffer.png',
                                            width: 56.w,
                                            height: 56.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('get_started_with_hosting'.tr(),
                                                  style: DS.ts(15, FontWeight.w600, DS.textPrimary)),
                                              SizedBox(height: 3.h),
                                              Text('limited_offer_earn_more'.tr(),
                                                  style: DS.ts(12, FontWeight.w400, DS.textSecondary)),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.chevron_right, color: DS.textTertiary, size: 16.r),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // 6. Settings
                            _buildCard(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                                    child: Text('settings'.tr().toUpperCase(), style: DS.label()),
                                  ),
                                  _buildListTile(
                                    icon: Icons.account_balance_outlined,
                                    title: 'country'.tr(),
                                    onTap: () {},
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.payments_outlined,
                                    title: 'currency'.tr(),
                                    onTap: () {},
                                  ),
                                  _buildDivider(),
                                  _buildListTile(
                                    icon: Icons.notifications_active_outlined,
                                    title: 'communication_preferences'.tr(),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // 7. Rate us
                            _buildCard(
                              _buildListTile(
                                icon: Icons.star_outline_rounded,
                                title: 'rate_us'.tr(),
                                onTap: () {},
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // 8. Log in / Log out
                            _buildCard(
                              user == null
                                  ? _buildListTile(
                                icon: Icons.login_rounded,
                                title: 'log_in_register'.tr(),
                                onTap: _openLogin,
                              )
                                  : _buildListTile(
                                icon: Icons.logout_rounded,
                                title: 'log_out'.tr(),
                                onTap: () async {
                                  if (await _confirmLogout()) {
                                    if (!context.mounted) return;
                                    await context.read<AuthCubit>().logout();
                                    if (context.mounted) _openLogin();
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 28.h),

                            // 9. Footer & social links
                            Text('join_with_us_show_some_love'.tr(),
                                style: DS.ts(12, FontWeight.w500, DS.textSecondary)),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialImageButton(AppImages.facebookIcon, onTap: openFacebook),
                                SizedBox(width: 16.w),
                                _buildSocialImageButton(AppImages.instaIcon, onTap: openInstagram),
                                SizedBox(width: 16.w),
                                _buildSocialImageButton('assets/profile_page/twitterXIcon.png',
                                    onTap: openX),
                                SizedBox(width: 16.w),
                                _buildSocialImageButton(AppImages.linkedinIcon, onTap: openLinkedin),
                              ],
                            ),
                            SizedBox(height: 36.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Quick action tile (My Trips, Profile, Wishlists)
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? badgeText,
  }) {
    return Container(
      height: 80.h,
      decoration: DS.cardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DS.radiusCard.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: DS.textPrimary, size: 22.r),
                  if (badgeText != null)
                    Positioned(
                      top: -6,
                      right: -10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        decoration: BoxDecoration(
                          color: DS.accentRed,
                          borderRadius: BorderRadius.circular(DS.radiusPill),
                        ),
                        child: Text(badgeText,
                            textAlign: TextAlign.center,
                            style: DS.ts(10, FontWeight.w700, Colors.white)),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(label, style: DS.ts(12, FontWeight.w500, DS.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) => Container(
    width: double.infinity,
    decoration: DS.cardDecoration(),
    child: child,
  );

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w),
          child: Row(
            children: [
              Icon(icon, color: DS.textSecondary, size: 20.r),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(title, style: DS.ts(14, FontWeight.w500, DS.textPrimary)),
              ),
              Icon(Icons.chevron_right, color: DS.textTertiary, size: 16.r),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(
    height: 1,
    thickness: 1,
    indent: 16,
    endIndent: 16,
    color: DS.borderLight,
  );

  Widget _buildSocialImageButton(String assetPath, {required VoidCallback onTap}) {
    // If a twitterXIcon.svg is passed, use the valid twitterXIcon.png asset
    String path = assetPath;
    if (path == AppImages.twitterIcon || path.contains('twitterXIcon.svg')) {
      path = 'assets/profile_page/twitterXIcon.png';
    }
    final isSvg = path.toLowerCase().endsWith('.svg');

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 32.w,
          height: 32.w,
          child: isSvg
              ? SvgPicture.asset(path, fit: BoxFit.cover)
              : Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => SizedBox(width: 32.w, height: 32.w),
          ),
        ),
      ),
    );
  }
}