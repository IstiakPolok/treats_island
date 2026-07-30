import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable round-edged primary action button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = Colors.white,
    this.height = 56.0,
    this.width = double.infinity,
    this.borderRadius = 30.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return SizedBox(
      width: width == double.infinity
          ? double.infinity
          : (isTablet ? width : width.w),
      height: isTablet ? height : height.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? borderRadius : borderRadius.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 24.w),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 16 : 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
