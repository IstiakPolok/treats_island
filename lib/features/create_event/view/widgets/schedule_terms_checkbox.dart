import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/view/terms_conditions_screen.dart';

class ScheduleTermsCheckbox extends StatelessWidget {
  final RxBool agreeToTerms;
  final VoidCallback onToggle;

  const ScheduleTermsCheckbox({
    super.key,
    required this.agreeToTerms,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 20.0 : 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Obx(
              () => Container(
                width: isTablet ? 22.0 : 22.sp,
                height: isTablet ? 22.0 : 22.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: agreeToTerms.value
                        ? AppColors.primary
                        : Colors.black38,
                    width: 1.5,
                  ),
                  color: agreeToTerms.value
                      ? AppColors.primary
                      : Colors.transparent,
                ),
                child: agreeToTerms.value
                    ? Icon(
                        Icons.check,
                        size: isTablet ? 14.0 : 14.sp,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 12.0 : 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.to(() => const TermsConditionsScreen()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms and Conditions *',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 14.0 : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D2C),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: isTablet ? 4.0 : 4.h),
                  Text(
                    'By signing up, you agree to our Terms and Conditions and Privacy Policy.',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12.0 : 12.sp,
                      color: Colors.black45,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
