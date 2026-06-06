import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 120),

                      // ── Centered Logo ──────────────────────────────────────────
                      Image.asset(
                        AppAssets.splashLogo,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 40),

                      // ── Header Text ──────────────────────────────────────────
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.antonSc(
                              fontSize: 48,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF1A1A2E),
                              height: 1.1,
                            ),
                            children: [
                              const TextSpan(text: "WHAT'S YOUR "),
                              TextSpan(
                                text: 'FULL\nNAME ?',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Name Field ─────────────────────────────────────────
                      TextField(
                        controller: controller.nameController,
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Full name',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.withValues(alpha: 0.6),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // ── Get Started Button ──────────────────────────────────
                      Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : PrimaryButton(
                                text: 'Get start!',
                                onPressed: controller.submitName,
                              ),
                      ),

                      const SizedBox(height: 100),
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
