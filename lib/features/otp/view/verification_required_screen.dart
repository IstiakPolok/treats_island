import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';

class VerificationRequiredScreen extends StatefulWidget {
  const VerificationRequiredScreen({super.key});

  @override
  State<VerificationRequiredScreen> createState() =>
      _VerificationRequiredScreenState();
}

class _VerificationRequiredScreenState
    extends State<VerificationRequiredScreen> {
  final TextEditingController _numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;
    final String? existingNumber =
        eventData?['payout_manager']?.toString() ??
        controller.createdEvent['payout_manager']?.toString();
    if (existingNumber != null &&
        existingNumber.isNotEmpty &&
        existingNumber != 'null') {
      _numberController.text = existingNumber;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const buttonColor = Color(0xFFFF6FB6);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32.0 : 24.w,
            vertical: isTablet ? 24.0 : 16.h,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550.0),
              child: Form(
                key: _formKey,
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
                            fontSize: isTablet ? 16.0 : 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 40.0 : 40.h),
                    Center(
                      child: Text(
                        'ADD PAYOUT MANAGER NUMBER',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.antonSc(
                          fontSize: isTablet ? 26.0 : 26.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 12.0 : 12.h),
                    Center(
                      child: Text(
                        'Please enter the phone number of your payout manager.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 14.0 : 14.sp,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 36.0 : 36.h),
                    Text(
                      'Payout Manager Number',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 13.0 : 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: isTablet ? 8.0 : 8.h),
                    TextFormField(
                      controller: _numberController,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 15.0 : 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: isTablet ? 14.0 : 14.sp,
                          color: Colors.black38,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20.0 : 20.w,
                          vertical: isTablet ? 16.0 : 16.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isTablet ? 36.0 : 36.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: isTablet ? 54.0 : 54.h,
                        child: ElevatedButton(
                          onPressed: controller.isUpdating.value
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  final eventData =
                                      controller.createdEvent['event']
                                          as Map<String, dynamic>?;
                                  final int? eventId =
                                      eventData?['id'] as int? ??
                                      controller.createdEvent['id'] as int?;

                                  if (eventId == null) {
                                    Get.snackbar(
                                      'Error',
                                      'No active event found to update.',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }

                                  final success = await controller.updateEvent(
                                    eventId: eventId,
                                    payoutManager: _numberController.text
                                        .trim(),
                                  );

                                  if (success) {
                                    Get.snackbar(
                                      'Success',
                                      'Payout manager number updated successfully!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green.withValues(
                                        alpha: 0.1,
                                      ),
                                      colorText: Colors.black,
                                    );
                                    Get.off(
                                      () => EventOverviewScreen(
                                        controller: controller,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: controller.isUpdating.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Save Payout Manager',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 16.0 : 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
