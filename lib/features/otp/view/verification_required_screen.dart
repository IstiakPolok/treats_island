import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_code_screen.dart';

class VerificationRequiredScreen extends StatelessWidget {
  const VerificationRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFFFF6FB6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 90.h),
              Center(
                child: Text(
                  'VERIFICATION REQUIRED',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.antonSc(
                    fontSize: 28.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Center(
                child: Text(
                  'To help keep sucurе, we\'ll text you a one\n'
                  'time (otp)',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const OtpCodeScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
