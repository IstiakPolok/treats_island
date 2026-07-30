import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class LaunchEventScreen extends StatelessWidget {
  const LaunchEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 500.0 : double.infinity,
          ),
          child: Column(
            children: [
              SizedBox(
                height: isTablet ? 250.0 : 220.h,
                width: double.infinity,
                child: Image.asset(
                  'assets/placeholder/myevent.png',
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 24.w,
                    vertical: isTablet ? 16.0 : 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(isTablet ? 30.0 : 30.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LAUNCH YOUR\nFUNDRAISING EVENT',
                        style: GoogleFonts.antonSc(
                          fontSize: isTablet ? 32.0 : 32.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: isTablet ? 22.0 : 22.h),
                      _InfoRow(
                        iconAsset: 'assets/icons/icon1.png',
                        title: 'Choose your fundraising window',
                        subtitle:
                            'Select when your candy fundraiser will go live\n'
                            'and how long supporters can shop.',
                      ),
                      SizedBox(height: isTablet ? 16.0 : 16.h),
                      _InfoRow(
                        iconAsset: 'assets/icons/icon2.png',
                        title: 'Invite your team',
                        subtitle:
                            'Share your unique event link so members can\n'
                            'join and create their personal pop-up stores.',
                      ),
                      SizedBox(height: isTablet ? 16.0 : 16.h),
                      _InfoRow(
                        iconAsset: 'assets/icons/icon3.png',
                        title: 'Raise together',
                        subtitle:
                            'Every team member gets a personalized\n'
                            'storefront to share, helping your fundraiser\n'
                            'grow faster.',
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: isTablet ? 48.0 : 48.h,
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.toNamed(AppStrings.scheduleEventRoute),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 30.0 : 30.r,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Create Event',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16.0 : 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 4.0 : 4.h),
                      const Spacer(),
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
}

class _InfoRow extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          iconAsset,
          width: isTablet ? 20.0 : 20.sp,
          height: isTablet ? 20.0 : 20.sp,
        ),
        SizedBox(width: isTablet ? 12.0 : 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16.0 : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: isTablet ? 3.0 : 3.h),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
