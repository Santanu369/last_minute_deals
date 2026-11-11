import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final double? size;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.radius = 25,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    String? resolvedUrl = imageUrl;
    if (resolvedUrl != null && resolvedUrl.isNotEmpty && !resolvedUrl.startsWith('http')) {
      final baseUrl = ApiConstants.baseUrl;
      if (resolvedUrl.startsWith('/')) {
        resolvedUrl = '$baseUrl$resolvedUrl';
      } else {
        resolvedUrl = '$baseUrl/$resolvedUrl';
      }
    }

    final double diameter = radius * 2;

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return _buildDefaultAvatar();
    }

    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: resolvedUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('UserAvatar Image Load Error: $error (URL: $url)');
            return _buildDefaultAvatar();
          },
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: radius,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(fontSize: size),
      ),
    );
  }
}
