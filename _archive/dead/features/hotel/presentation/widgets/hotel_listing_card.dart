import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotelListingCard extends StatelessWidget {
  const HotelListingCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.city,
    required this.price,
    required this.rating,
    required this.onTap,
    this.badgeText = 'Few rooms left',
    this.availabilityText = "Book before it's gone",
    this.discountText,
    this.buttonText = 'Book Now',
  });

  final String imageUrl;
  final String name;
  final String city;
  final dynamic price;
  final String rating;

  final String badgeText;
  final String availabilityText;
  final String? discountText;
  final String buttonText;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                child: imageUrl.isEmpty
                    ? Container(
                        height: 240.h,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 240.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => SizedBox(
                          height: 240.h,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          height: 240.h,
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
              ),

              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF7346),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ),

              if (discountText != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      discountText!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4D49D9),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 6.h),

                          Text(
                            city,
                            style: const TextStyle(color: Color(0xff767676)),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14.r,
                            color: Color(0xffFFB800),
                          ),

                          SizedBox(width: 4.w),

                          Text(
                            rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Color(0xff4D49D9)),
                              children: [
                                TextSpan(
                                  text: '₹$price',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                TextSpan(
                                  text: ' /night',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff767676),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            availabilityText,
                            style: TextStyle(
                              color: Color(0xffBB1414),
                              fontWeight: FontWeight.w600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    FilledButton(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xff4D49D9),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      ),
                      child: Text(buttonText),
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
}
