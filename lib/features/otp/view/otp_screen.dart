import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/widgets.dart';
import '../controller/otp_controller.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // ── Centered Logo ──────────────────────────────────────────
                      Image.asset(
                        AppAssets.splashLogo,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'OTP CODE\nVERIFICATION',
                          style: GoogleFonts.antonSc(
                            fontSize: 48,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF1A1A2E),
                            height: 1.1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Subtitle ─────────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Code Has Been Sent To 010******',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A2E).withValues(alpha: 0.8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── OTP Input Fields ──────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _buildOTPField(context, index, controller),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Resend / Timer ────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: Obx(() {
                          if (controller.canResend.value) {
                            return GestureDetector(
                              onTap: controller.resendCode,
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Didn’t receive the code? '),
                                    TextSpan(
                                      text: 'Resend',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  const TextSpan(text: 'Resend code in '),
                                  TextSpan(
                                    text: '${controller.secondsRemaining.value}s',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                      ),

                      const SizedBox(height: 30),

                      // ── Error Message ────────────────────────────────────────
                      Obx(() {
                        if (controller.hasError.value) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              border: Border.all(color: const Color(0xFFEF9A9A)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Oh no! The code you entered is incorrect.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.red.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const Spacer(),

                      // ── Verification Button ──────────────────────────────────
                      Obx(() {
                        return controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              )
                            : PrimaryButton(
                                text: controller.hasError.value
                                    ? 'Try again?'
                                    : 'Send verification code',
                                backgroundColor: controller.hasError.value
                                    ? Colors.red
                                    : AppColors.primary,
                                onPressed: controller.verifyOTP,
                              );
                      }),

                      const SizedBox(height: 20),
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

  Widget _buildOTPField(
      BuildContext context, int index, OTPController controller) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.pink.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              controller.focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}

