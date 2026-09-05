import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const ArrowButton({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Container(
      width: isTablet ? 40.0 : 40.w,
      height: isTablet ? 40.0 : 40.w,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(
          Icons.arrow_outward_rounded,
          color: iconColor,
          size: isTablet ? 24.0 : 24.sp,
        ),
      ),
    );
  }
}
