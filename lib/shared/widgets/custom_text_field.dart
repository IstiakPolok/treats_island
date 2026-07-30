import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// A reusable text input field with a bottom underline border
/// designed to match the Treats Island UI.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      cursorColor: AppColors.primary,
      style: GoogleFonts.poppins(
        fontSize: isTablet ? 16.0 : 16.sp,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: GoogleFonts.poppins(
          fontSize: isTablet ? 15.0 : 15.sp,
          color: AppColors.textHint,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: isTablet ? 12.0 : 12.h),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: isTablet ? 1.5 : 1.5.w,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: isTablet ? 2.0 : 2.0.w,
          ),
        ),
      ),
    );
  }
}
