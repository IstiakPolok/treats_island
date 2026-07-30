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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final logoSize = isTablet ? 120.0 : 120.w;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 420.0 : double.infinity,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24.0 : 28.0.w,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: isTablet ? 40.0 : 40.h),

                          // ── Centered Logo ──────────────────────────────────────────
                          Image.asset(
                            AppAssets.splashLogo,
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: isTablet ? 20.0 : 20.h),

                          // ── Header Text ──────────────────────────────────────────
                          Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.antonSc(
                                  fontSize: isTablet ? 32.0 : 40.sp,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF1A1A2E),
                                  height: 1.1,
                                ),
                                children: [
                                  const TextSpan(text: "SETUP YOUR\n"),
                                  TextSpan(
                                    text: 'PROFILE',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 30.0 : 30.h),

                          // ── Image Picker ─────────────────────────────────────────
                          GestureDetector(
                            onTap: controller.pickImage,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Obx(() => CircleAvatar(
                                      radius: isTablet ? 54.0 : 54.r,
                                      backgroundColor: const Color(0xFFF0F0F3),
                                      backgroundImage:
                                          controller.selectedImagePath.value !=
                                                  null
                                              ? FileImage(
                                                  File(
                                                    controller
                                                        .selectedImagePath
                                                        .value!,
                                                  ),
                                                )
                                              : null,
                                      child: controller
                                                  .selectedImagePath.value ==
                                              null
                                          ? Icon(
                                              Icons.person_outline_rounded,
                                              size: isTablet ? 54.0 : 54.sp,
                                              color: const Color(0xFF707080),
                                            )
                                          : null,
                                    )),
                                Container(
                                  padding: EdgeInsets.all(
                                    isTablet ? 8.0 : 8.w,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    size: isTablet ? 18.0 : 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isTablet ? 30.0 : 30.h),

                          // ── Full Name Field ─────────────────────────────────────────
                          TextField(
                            controller: controller.nameController,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16.0 : 16.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Full name',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.withValues(alpha: 0.6),
                                fontSize: isTablet ? 16.0 : 16.sp,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFE0E0E0),
                                  width: isTablet ? 1.0 : 1.w,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: isTablet ? 2.0 : 2.w,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 20.0 : 20.h),

                          // ── Email Field ─────────────────────────────────────────
                          TextField(
                            controller: controller.emailController,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 16.0 : 16.sp,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email address',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey.withValues(alpha: 0.6),
                                fontSize: isTablet ? 16.0 : 16.sp,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFFE0E0E0),
                                  width: isTablet ? 1.0 : 1.w,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: isTablet ? 2.0 : 2.w,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(),
                          SizedBox(height: isTablet ? 40.0 : 40.h),

                          // ── Get Started Button ──────────────────────────────────
                          Obx(
                            () => controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : PrimaryButton(
                                    text: 'Get started!',
                                    onPressed: controller.submitName,
                                  ),
                          ),

                          SizedBox(height: isTablet ? 60.0 : 60.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
