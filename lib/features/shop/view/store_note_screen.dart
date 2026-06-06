import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreNoteScreen extends StatelessWidget {
  const StoreNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAF4),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFFFC9E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 14.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Get Inspiration',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6FB6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'STORE NOTE',
                style: GoogleFonts.antonSc(
                  fontSize: 26.sp,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'This will appear on your pop-up store',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "What's the goal of this fundraiser?",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black38,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEDEDF2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6FB6)),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6FB6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
