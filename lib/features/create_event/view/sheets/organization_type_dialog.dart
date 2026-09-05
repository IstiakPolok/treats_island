import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/schedule_event_controller.dart';

class OrganizationTypeDialog {
  static void show(BuildContext context, ScheduleEventController controller) {
    final List<String> categories = controller.categories.toList();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40.0 : 16.w,
          vertical: isTablet ? 40.0 : 24.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        ),
        child: Container(
          width: isTablet ? 450.0 : double.infinity,
          padding: EdgeInsets.all(isTablet ? 24.0 : 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: isTablet ? 24.0 : 24.sp,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16.0 : 16.w),
                  Text(
                    'Organization Type',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 20.0 : 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D1D2C),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 28.0 : 28.h),

              categories.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isTablet ? 24.0 : 24.h,
                      ),
                      child: Center(
                        child: Text(
                          'No categories found',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : Obx(
                      () => Wrap(
                        spacing: isTablet ? 10.0 : 10.w,
                        runSpacing: isTablet ? 12.0 : 12.h,
                        children: categories.map((category) {
                          final isSelected =
                              controller.organization.value == category;
                          return GestureDetector(
                            onTap: () {
                              controller.organization.value = category;
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isTablet ? 16.0 : 16.w,
                                vertical: isTablet ? 10.0 : 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFF1F1F5),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 25.0 : 25.r,
                                ),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 14.0 : 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF1D1D2C)
                                      : const Color(0xFF525252),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: isTablet ? 12.0 : 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
