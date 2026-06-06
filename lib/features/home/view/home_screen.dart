import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                          'HELLO,',
                          style: GoogleFonts.antonSc(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A2E),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Jhon',
                          style: GoogleFonts.poppins(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Thursday, April 30',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'MY EVENT',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF262626),
                  
                ),
              ),
              SizedBox(height: 10.h),
              _EventCard(
                title: 'ORGANIZED AN EVENT',
                subtitle: 'Schedule A Fundraiser For Your\nTeam',
                assetPath: 'assets/placeholder/myevent.png',
                onTap: () => Get.toNamed(AppStrings.launchEventRoute),
              ),
              SizedBox(height: 16.h),
              _PinkActionCard(
                title: 'ENTER EVENT CODE',
              ),
              SizedBox(height: 24.h),
              Text(
                'GET STARTED IN MINUTES',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 210.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _MiniVideoCard(
                      title: 'Launch Your\nPop-Up Store',
                      subtitle: 'Set up your personalized candy\nstorefront in just a few taps.',
                      duration: '1:23',
                      assetPath: 'assets/placeholder/homescreengetstarted1.png',
                    ),
                    SizedBox(width: 14),
                    _MiniVideoCard(
                      title: 'Share Your Store',
                      subtitle: 'Send your unique fund link\nthrough text, email, or social.',
                      duration: '0:58',
                      assetPath: 'assets/placeholder/homescreengetstarted2.png',
                    ),
                    SizedBox(width: 14),
                      _MiniVideoCard(
                      title: 'Share Your Store',
                      subtitle: 'Send your unique fund link\nthrough text, email, or social.',
                      duration: '0:58',
                      assetPath: 'assets/placeholder/homescreengetstarted3.png',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback? onTap;

  const _EventCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            Positioned(
              left: 16.w,
              top: 16.h,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.antonSc(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 16.w,
              bottom: 16.h,
              child: _ArrowButton(
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinkActionCard extends StatelessWidget {
  final String title;

  const _PinkActionCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
     // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6DDE8),
        borderRadius: BorderRadius.circular(26.r),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/images/pinkeventcard.png',
              
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text(
                  title,
                  style: GoogleFonts.antonSc(
                    fontSize:28.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const Spacer(),
                _ArrowButton(
                  backgroundColor: AppColors.primary,
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniVideoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String assetPath;

  const _MiniVideoCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: SizedBox(
        width: 210.w,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12.w,
              top: 12.h,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded),
              ),
            ),
            Positioned(
              right: 12.w,
              top: 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  duration,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const _ArrowButton({
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        size: 32.w,
        Icons.arrow_outward_rounded,
        color: iconColor,
      ),
    );
  }
}
