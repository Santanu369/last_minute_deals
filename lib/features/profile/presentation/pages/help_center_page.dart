import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';

class FAQItem {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});
}

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final List<FAQItem> _faqs = const [
    FAQItem(
      question: 'How do I book a hotel?',
      answer: "Search for your destination or category on our home page, select your preferred hotel deal, choose your dates, and click 'Book Now'. Follow the checkout instructions to complete your payment.",
    ),
    FAQItem(
      question: 'When will I receive my booking confirmation?',
      answer: "Your booking voucher and confirmation email are generated instantly upon successful payment. You can also view all your active bookings anytime under 'My Trip' in your profile.",
    ),
    FAQItem(
      question: 'Can I cancel my booking?',
      answer: 'Cancellation policies vary by hotel and deal type. Please review the specific cancellation rules listed on the hotel detail page before confirming your reservation.',
    ),
    FAQItem(
      question: 'Can I modify my booking?',
      answer: "To modify dates or guest details, please contact our support team directly. Modifications are subject to availability and the specific hotel's policy.",
    ),
    FAQItem(
      question: 'Is my payment secure?',
      answer: 'Yes, all transactions are processed through secure, encrypted payment gateways. We do not store your complete card details on our servers.',
    ),
    FAQItem(
      question: "I didn't receive my booking confirmation.",
      answer: "Please check your spam or promotions folder first. If it's still missing, log in to your account to view your booking under 'My Trip', or contact support.",
    ),
  ];

  List<FAQItem> _filteredFaqs = [];
  String _searchQuery = '';
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _faqs;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _expandedIndices.clear(); // Close any open answers during search
      final q = query.toLowerCase();
      _filteredFaqs = query.trim().isEmpty
          ? _faqs
          : _faqs
          .where((f) =>
      f.question.toLowerCase().contains(q) ||
          f.answer.toLowerCase().contains(q))
          .toList();
    });
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
                          Text('Help Center',
                              style: DS.ts(14, FontWeight.w500, DS.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Search Bar (56px, 12px radius)
                  Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: DS.card,
                      borderRadius: BorderRadius.circular(DS.radiusInput.r),
                      border: Border.all(color: DS.borderMedium),
                    ),
                    child: TextField(
                      onChanged: _onSearchChanged,
                      style: DS.ts(14, FontWeight.w400, DS.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search for help...',
                        hintStyle: DS.ts(14, FontWeight.w400, DS.textTertiary),
                        prefixIcon: Icon(Icons.search, color: DS.textSecondary, size: 20.r),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text('Frequently Asked Questions',
                      style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
                  SizedBox(height: 12.h),

                  // FAQs List
                  _filteredFaqs.isEmpty
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Center(
                      child: Text(
                        'No results found for "$_searchQuery"',
                        style: DS.ts(14, FontWeight.w400, DS.textSecondary),
                      ),
                    ),
                  )
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredFaqs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final faq = _filteredFaqs[index];
                      final originalIndex = _faqs.indexOf(faq);
                      final isExpanded = _expandedIndices.contains(originalIndex);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: DS.cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => setState(() {
                                isExpanded
                                    ? _expandedIndices.remove(originalIndex)
                                    : _expandedIndices.add(originalIndex);
                              }),
                              borderRadius: BorderRadius.circular(DS.radiusCard.r),
                              child: Padding(
                                padding: EdgeInsets.all(DS.screenPadding.w),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        faq.question,
                                        style: DS.ts(15, FontWeight.w600, DS.textPrimary),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: DS.primaryBlue,
                                      size: 22.r,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded) ...[
                              const Divider(color: DS.borderLight, height: 1),
                              Padding(
                                padding: EdgeInsets.all(DS.screenPadding.w),
                                child: Text(
                                  faq.answer,
                                  style: DS.ts(14, FontWeight.w400, DS.textSecondary,
                                      height: 1.5),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Bottom Support Card
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
                          child: Icon(Icons.help_outline_rounded,
                              color: DS.primaryBlue, size: 20.r),
                        ),
                        SizedBox(height: 16.h),
                        Text('Still need help?',
                            style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
                        SizedBox(height: 8.h),
                        Text(
                          'Our 24/7 support team is here to assist you with any questions or concerns.',
                          textAlign: TextAlign.center,
                          style: DS.ts(14, FontWeight.w400, DS.textSecondary, height: 1.5),
                        ),
                        SizedBox(height: 20.h),
                        DSPrimaryButton(
                          // Returns back to the Contact Us screen
                          onPressed: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('CONTACT SUPPORT',
                                  style: DS.ts(14, FontWeight.w700, Colors.white)),
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16.r),
                            ],
                          ),
                        ),
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
}