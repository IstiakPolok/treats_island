import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/nameset_controller.dart';

class NameSetScreen extends StatelessWidget {
  const NameSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NameSetController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28.0.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),

                      // ── Centered Logo ──────────────────────────────────────────
                      Image.asset(
                        AppAssets.splashLogo,
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: 20.h),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.antonSc(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1A1A2E),
                              height: 1.1,
                            ),
                            children: [
                              const TextSpan(text: "SETUP YOUR\n"),
                              TextSpan(
                                text: 'PROFILE',
                                style: const TextStyle(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // ── Image Picker ─────────────────────────────────────────
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Obx(() => CircleAvatar(
                              radius: 54.r,
                              backgroundColor: const Color(0xFFF0F0F3),
                              backgroundImage: controller.selectedImagePath.value != null
                                  ? FileImage(File(controller.selectedImagePath.value!))
                                  : null,
                              child: controller.selectedImagePath.value == null
                                  ? Icon(
                                      Icons.person_outline_rounded,
                                      size: 54.sp,
                                      color: const Color(0xFF707080),
                                    )
                                  : null,
                            )),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // ── Full Name Field ─────────────────────────────────────────
                      TextField(
                        controller: controller.nameController,
                        style: GoogleFonts.poppins(fontSize: 16.sp),
                        decoration: InputDecoration(
                          hintText: 'Full name',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.withValues(alpha: 0.6),
                            fontSize: 16.sp,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFFE0E0E0),
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ── Email Field ─────────────────────────────────────────
                      TextField(
                        controller: controller.emailController,
                        style: GoogleFonts.poppins(fontSize: 16.sp),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email address',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.withValues(alpha: 0.6),
                            fontSize: 16.sp,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFFE0E0E0),
                              width: 1.w,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2.w,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),
                      SizedBox(height: 40.h),

                      // ── Get Started Button ──────────────────────────────────
                      Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : PrimaryButton(
                                text: 'Get started!',
                                onPressed: controller.submitName,
                              ),
                      ),

                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
