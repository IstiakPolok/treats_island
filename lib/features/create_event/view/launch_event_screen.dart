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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 220.h,
            width: double.infinity,
            child: Image.asset(
              'assets/placeholder/myevent.png',
              fit: BoxFit.fitWidth,
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LAUNCH YOUR\nFUNDRAISING EVENT',
                  style: GoogleFonts.antonSc(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 22.h),
                _InfoRow(
                  iconAsset: 'assets/icons/icon1.png',
                  title: 'Choose your fundraising window',
                  subtitle:
                      'Select when your candy fundraiser will go live\n'
                      'and how long supporters can shop.',
                ),
                SizedBox(height: 16.h),
                _InfoRow(
                  iconAsset: 'assets/icons/icon2.png',
                  title: 'Invite your team',
                  subtitle:
                      'Share your unique event link so members can\n'
                      'join and create their personal pop-up stores.',
                ),
                SizedBox(height: 16.h),
                _InfoRow(
                  iconAsset: 'assets/icons/icon3.png',
                  title: 'Raise together',
                  subtitle:
                      'Every team member gets a personalized\n'
                      'storefront to share, helping your fundraiser\n'
                      'grow faster.',
                ),
                SizedBox(height: 16.h),
                //Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppStrings.scheduleEventRoute),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create Event',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconAsset, width: 20.sp, height: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
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
