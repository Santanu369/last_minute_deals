import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/widgets/basic_appbar.dart';
import 'package:lmd_app/core/constants/app_images.dart';
import 'package:lmd_app/core/theme/basic_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;

  const PaymentPage({super.key, this.totalAmount = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: 'Payment',
        color: Color(0xff2E3337),
        isActions: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              SizedBox(height: 18.h),
              _totalDue(),
              SizedBox(height: 22.h),
              _placeDetails(),
              SizedBox(height: 22.h),
              _giftCards(),
              SizedBox(height: 22.h),
              _paymentOptions(),
              SizedBox(height: 22.h),
              _termsAndServices(),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalDue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BasicTextStyle(
          title: 'Total Due',
          weight: FontWeight.w700,
          size: 18.r,
          height: 1.77,
          spacing: -0.6,
          color: Color(0xff2E3337),
        ),
        Row(
          children: [
            BasicTextStyle(
              title: totalAmount > 0
                  ? '₹${totalAmount.toStringAsFixed(0)}'
                  : 'TBA',
              weight: FontWeight.w700,
              size: 18.r,
              height: 1.1,
              spacing: 0,
              color: Color(0xff1A1A1A),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 18.h,
              width: 18.w,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                borderRadius: BorderRadiusGeometry.circular(9999),
                border: Border.all(width: 1, color: Color(0xff767B80)),
              ),
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 16.r,
                  color: Color(0xff4D49D9),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _placeDetails() {
    return AspectRatio(
      aspectRatio: 342 / 91,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                spreadRadius: 0,
                color: Color(0x40000000),
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 114 / 91,
                child: Image.asset(AppImages.bookingPlace, fit: .cover),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicTextStyle(
                        title: 'Palacio Villa',
                        weight: FontWeight.w700,
                        size: 18.r,
                        height: 1.2,
                        spacing: 0,
                        color: Color(0xff1F2024),
                      ),
                      BasicTextStyle(
                        title: 'Santorini, Greece • 4.2 km away',
                        weight: FontWeight.w400,
                        size: 10.r,
                        height: 1.7,
                        spacing: 0,
                        color: Color(0xff434343),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BasicTextStyle(
                              title: '1 Jun | 12:00PM - 2 Jan | 12:00PM',
                              weight: FontWeight.w400,
                              size: 10.r,
                              height: 1.3,
                              spacing: 0,
                              color: Color(0xff767B80),
                            ),
                            BasicTextStyle(
                              title: '1 Room, 2 Adults',
                              weight: FontWeight.w600,
                              size: 12.r,
                              height: 1.3,
                              spacing: 0,
                              color: Color(0xff767B80),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _giftCards() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 49,
        maxHeight: 52,
        minWidth: 342,
        maxWidth: 700,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(12),
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              spreadRadius: 0,
              color: Color(0x40000000),
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 9.0.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/payments/gift_card.png',
                    fit: .contain,
                    height: 22.h,
                    width: 22.w,
                  ),
                  SizedBox(width: 10.w),
                  BasicTextStyle(
                    title: 'Gift Cards',
                    weight: FontWeight.w700,
                    size: 12.r,
                    height: 1,
                    spacing: 0,
                    color: Color(0xff292929),
                  ),
                ],
              ),
              Center(
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 18.r,
                  color: Color(0xff4D49D9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentOptions() {
    List<String> paymentOptions = [
      'assets/payments/payment_option_1.png',
      'assets/payments/payment_option_2.png',
      'assets/payments/payment_option_3.png',
      'assets/payments/payment_option_4.png',
      'assets/payments/payment_option_5.png',
      'assets/payments/payment_option_6.png',
      'assets/payments/payment_option_7.png',
    ];

    List paymentOptionTitles = [
      'UPI Options',
      'Credit/Debit/ATM Card',
      'Net Banking',
      'Pay Later',
      'Gift Cards & E-wallets',
      'EMI',
      'PhonePe',
    ];

    List<String> paymentOptionSubtitles = [
      'Pay directly from your Bank Account',
      'Visa, MasterCard, Amex, Rupay & more',
      '40+ Banks Available',
      'Lazypay',
      'AmazonPay, Mobikwik & Gift Cards',
      'Credit/Debit Card EMI available',
      'Pay with PhonePe',
    ];
    return Column(
      children: [
        Row(
          children: [
            BasicTextStyle(
              title: 'Payment Options',
              weight: FontWeight.w700,
              size: 22.r,
              height: 1.45,
              spacing: -0.6,
              color: Color(0xff2E3337),
            ),
          ],
        ),
        SizedBox(height: 22.h),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 342, maxWidth: 700),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (BuildContext context, int index) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: 49, maxHeight: 52),
                child: Container(
                  // height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadiusGeometry.only(
                      topLeft: index == 0 ? Radius.circular(12.r) : Radius.zero,
                      topRight: index == 0 ? Radius.circular(12.r) : Radius.zero,
                      bottomLeft: index == 6
                          ? Radius.circular(12.r)
                          : Radius.zero,
                      bottomRight: index == 6
                          ? Radius.circular(12.r)
                          : Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        spreadRadius: 0,
                        color: Color(0x40000000),
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ListTile(
                      // horizontalTitleGap: 9,
                      iconColor: Color(0xff4D49D9),

                      contentPadding: EdgeInsets.only(
                        left: 9.w,
                        right: 9.w,
                        bottom: 0,
                        top: 0,
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 9.0.h),
                        child: Image.asset(
                          paymentOptions[index],
                          fit: .contain,
                          height: 22.h,
                          width: 22.w,
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Row(
                                    children: [
                                      BasicTextStyle(
                                        title: paymentOptionTitles[index],
                                        weight: FontWeight.w700,
                                        size: 12.r,
                                        height: 1,
                                        spacing: 0,
                                        color: Color(0xff292929),
                                      ),
                                      ...List.generate(4, (index) {
                                        return Container(
                                          margin: EdgeInsets.only(left: 2.w),
                                          child: SvgPicture.asset(
                                            'assets/payments/upi_option_1.svg',
                                            fit: .contain,
                                            height: 14.h,
                                            width: 14.w,
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                                : BasicTextStyle(
                                    title: paymentOptionTitles[index],
                                    weight: FontWeight.w700,
                                    size: 12.r,
                                    height: 1,
                                    spacing: 0,
                                    color: Color(0xff292929),
                                  ),
                            BasicTextStyle(
                              title: paymentOptionSubtitles[index],
                              weight: FontWeight.w500,
                              size: 10.r,
                              height: 2,
                              spacing: 0,
                              color: Color(0xff767676),
                            ),
                          ],
                        ),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(bottom: 9.0.h),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios, size: 18.r),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _termsAndServices() {
    return Text.rich(
      TextSpan(
        text: 'By continuing to pay, I understand and agree with the',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          height: 1,
          letterSpacing: 0,
          color: Color(0xff1A1A1A),
        ),
        children: [
          TextSpan(
            text: ' Terms of Service, Privacy Policy',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
              color: Color(0xff4D49D9),
            ),
          ),
          TextSpan(text: '  and'),
          TextSpan(
            text: ' User Agreement',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
              color: Color(0xff4D49D9),
            ),
          ),
          TextSpan(text: ' of Last Minutes Deal.'),
        ],
      ),
    );
  }
}
