import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';
import '../../shop/controller/stripe_connect_controller.dart';

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

  final StripeConnectController _stripeController =
      Get.isRegistered<StripeConnectController>()
      ? Get.find<StripeConnectController>()
      : Get.put(StripeConnectController());

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
    _stripeController.fetchConnectStatus();
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
              child: SingleChildScrollView(
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
                    SizedBox(height: isTablet ? 20.0 : 20.h),

                    Center(
                      child: Text(
                        'PAYOUT INFO',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.antonSc(
                          fontSize: isTablet ? 26.0 : 26.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    SizedBox(height: isTablet ? 8.0 : 8.h),
                    Center(
                      child: Text(
                        'Connect your bank account via Stripe to receive your 50% profit share from every candy sale.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 28.0 : 24.h),

                    // Stripe Connect Card
                    Obx(() {
                      final status = _stripeController.status.value;
                      final bool isConnected = status?.payoutsEnabled ?? false;
                      final double totalEarned =
                          status?.totalCreatorEarnings ?? 0.0;
                      final double pendingPayout =
                          status?.pendingPayoutAmount ?? 0.0;
                      final double transferred =
                          status?.transferredAmount ?? 0.0;

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isTablet ? 20.0 : 18.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7FD),
                          borderRadius: BorderRadius.circular(22.r),
                          border: Border.all(
                            color: isConnected
                                ? const Color(0xFFC8E6C9)
                                : const Color(0xFFE2D6F5),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.r),
                                  decoration: BoxDecoration(
                                    color: isConnected
                                        ? const Color(0xFFE8F5E9)
                                        : const Color(0xFFFFEAF4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isConnected
                                        ? Icons.check_circle_rounded
                                        : Icons.account_balance_wallet_rounded,
                                    size: isTablet ? 20.0 : 20.sp,
                                    color: isConnected
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFFF6FB6),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    isConnected
                                        ? 'Direct Deposit Active'
                                        : 'Stripe Payout Connection',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 15.0 : 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),

                            // Stats row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Earned (50%)',
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 11.0 : 11.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '\$${totalEarned.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 16.0 : 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1A2E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isConnected
                                            ? 'Transferred'
                                            : 'Pending Payout',
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 11.0 : 11.sp,
                                          color: isConnected
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFE65100),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        isConnected
                                            ? '\$${transferred.toStringAsFixed(2)}'
                                            : '\$${pendingPayout.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet ? 16.0 : 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isConnected
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFE65100),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 14.h),
                            Text(
                              isConnected
                                  ? 'Your bank details are verified with Stripe. Transfers are initiated automatically.'
                                  : 'Customers can purchase candy right now, and your 50% profits are safely held until you connect your bank account.',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 12.0 : 12.sp,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 18.h),

                            // Main Stripe Button
                            SizedBox(
                              width: double.infinity,
                              height: isTablet ? 50.0 : 48.h,
                              child: ElevatedButton(
                                onPressed:
                                    _stripeController
                                            .isOnboardingLoading
                                            .value ||
                                        _stripeController
                                            .isDashboardLoading
                                            .value
                                    ? null
                                    : () {
                                        if (isConnected) {
                                          _stripeController.openDashboard();
                                        } else {
                                          _stripeController.startOnboarding();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isConnected
                                      ? const Color(0xFF1A1A2E)
                                      : buttonColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                ),
                                child:
                                    _stripeController
                                            .isOnboardingLoading
                                            .value ||
                                        _stripeController
                                            .isDashboardLoading
                                            .value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            isConnected
                                                ? Icons.open_in_new_rounded
                                                : Icons.account_balance_rounded,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            isConnected
                                                ? 'View Stripe Payout Dashboard'
                                                : 'Connect Bank Account (Stripe)',
                                            style: GoogleFonts.poppins(
                                              fontSize: isTablet ? 14.0 : 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: isTablet ? 32.0 : 28.h),
                    Divider(color: const Color(0xFFEDEDF4)),
                    SizedBox(height: isTablet ? 20.0 : 18.h),

                    // Optional Payout Manager Contact Number
                    Text(
                      'Payout Manager Contact Number (Optional)',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 13.0 : 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'If your organization has an adult supervisor or treasurer overseeing payouts, you can save their contact number here.',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 11.5 : 11.5.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _numberController,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 15.0 : 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A1A2E),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter manager phone number (optional)',
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
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: isTablet ? 50.0 : 48.h,
                        child: OutlinedButton(
                          onPressed: controller.isUpdating.value
                              ? null
                              : () async {
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
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD4D4DF)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: controller.isUpdating.value
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF1A1A2E),
                                )
                              : Text(
                                  'Save Manager Number',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 14.0 : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
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
