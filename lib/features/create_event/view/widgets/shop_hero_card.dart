import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shop/view/create_pop_up_store_screen.dart';

class ShopHeroCard extends StatelessWidget {
  const ShopHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: () => Get.to(() => const CreatePopUpStoreScreen()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          color: const Color(0xFFF6D6E5),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: -16.h,
                child: Image.asset(
                  'assets/images/createshobgcard.png',
                  width: 150.w,
                  height: 150.w,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREATE YOUR POP-UP STORE',
                            style: GoogleFonts.antonSc(
                              fontSize: isTablet ? 22.0 : 22.sp,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Your Virtual Pop-Up Store',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6FB6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
