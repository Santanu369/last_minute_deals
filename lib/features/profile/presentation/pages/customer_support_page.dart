import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lmd_app/core/config/support_config.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';
import 'package:lmd_app/features/profile/presentation/pages/help_center_page.dart';

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: SupportConfig.email,
      queryParameters: {'subject': 'Support Request - Last Minutes Deal'},
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: SupportConfig.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DS.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: DS.screenPadding.w, vertical: DS.screenPadding.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button Row
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: DS.textSecondary, size: 20.r),
                          SizedBox(width: 8.w),
                          TranslatedText(
                            text: 'Back to Home',
                            style: DS.ts(14, FontWeight.w500, DS.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Availability badge
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: DS.accentLight,
                        borderRadius: BorderRadius.circular(DS.radiusPill),
                      ),
                      child: TranslatedText(
                        text: SupportConfig.availabilityHeader,
                        style: DS.ts(11, FontWeight.w700, DS.accentRed, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Title
                  Center(
                    child: TranslatedText(
                      text: 'Contact Us',
                      style: DS.ts(20, FontWeight.w700, DS.textPrimary),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Supporting description
                  Center(
                    child: TranslatedText(
                      text:
                      'Have questions about your booking, account, or payment? Reach out anytime and our team will get back to you immediately.',
                      textAlign: TextAlign.center,
                      style: DS.ts(14, FontWeight.w400, DS.textSecondary, height: 1.5),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Main Help Card
                  Container(
                    width: double.infinity,
                    decoration: DS.cardDecoration(),
                    padding: EdgeInsets.all(DS.screenPadding.w),
                    child: Column(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: const BoxDecoration(
                            color: DS.background,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.headset_mic_outlined,
                              color: DS.primaryBlue, size: 20.r),
                        ),
                        SizedBox(height: 16.h),
                        TranslatedText(
                          text: 'Need Help?',
                          style: DS.ts(16, FontWeight.w600, DS.textPrimary),
                        ),
                        SizedBox(height: 8.h),
                        TranslatedText(
                          text:
                          'Our dedicated support team is standing by around the clock to assist with your bookings, changes, or any travel inquiries you might have.',
                          textAlign: TextAlign.center,
                          style: DS.ts(14, FontWeight.w400, DS.textSecondary, height: 1.5),
                        ),
                        SizedBox(height: 20.h),

                        _buildContactOptionCard(
                          title: 'DIRECT EMAIL',
                          value: SupportConfig.email,
                          icon: Icons.mail_outline_rounded,
                          onTap: _launchEmail,
                        ),
                        SizedBox(height: 12.h),
                        _buildContactOptionCard(
                          title: '24/7 SUPPORT PHONE',
                          value: SupportConfig.displayPhone,
                          icon: Icons.phone_outlined,
                          onTap: _launchPhone,
                        ),
                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          child: DSPrimaryButton(
                            onPressed: _launchEmail,
                            child: TranslatedText(
                              text: 'Email Us Directly',
                              style: DS.ts(14, FontWeight.w700, Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildHelpCenterButton(context),
                      ],
                    ),
                  ),
                  SizedBox(height: DS.screenPadding.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOptionCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: DS.card,
          borderRadius: BorderRadius.circular(DS.radiusInput.r),
          border: Border.all(color: DS.borderMedium),
        ),
        child: Column(
          children: [
            Text(title, style: DS.label()),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: DS.textSecondary, size: 20.r),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: DS.ts(14, FontWeight.w500, DS.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCenterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: DS.borderMedium),
          backgroundColor: DS.card,
          foregroundColor: DS.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusButton.r),
          ),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpCenterPage()),
        ),
        child: TranslatedText(
          text: 'Visit Help Center',
          style: DS.ts(14, FontWeight.w700, DS.textPrimary),
        ),
      ),
    );
  }
}