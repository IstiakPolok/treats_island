import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../otp/view/verification_required_screen.dart';
import '../../../shop/controller/stripe_connect_controller.dart';
import '../../controller/schedule_event_controller.dart';
import 'overview_card.dart';

class EventPayoutManagerCard extends StatelessWidget {
  final ScheduleEventController controller;

  const EventPayoutManagerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final StripeConnectController stripeController =
        Get.isRegistered<StripeConnectController>()
        ? Get.find<StripeConnectController>()
        : Get.put(StripeConnectController());

    return Obx(() {
      final Map<String, dynamic> rawMap = controller.createdEvent;
      final Map<String, dynamic>? eventData = rawMap['event'] is Map
          ? rawMap['event'] as Map<String, dynamic>
          : null;

      final dynamic isMineValue =
          eventData?['is_mine'] ??
          rawMap['is_mine'] ??
          eventData?['is_creator'] ??
          rawMap['is_creator'];
      final bool isMine = isMineValue != null
          ? (isMineValue == true ||
              isMineValue.toString().toLowerCase() == 'true')
          : true;

      if (!isMine) {
        return const SizedBox.shrink();
      }

      final String? payoutNumber =
          eventData?['payout_manager']?.toString() ??
          rawMap['payout_manager']?.toString();
      final bool hasPayoutNumber =
          payoutNumber != null &&
          payoutNumber.trim().isNotEmpty &&
          payoutNumber != 'null';

      final stripeStatus = stripeController.status.value;
      final bool isPayoutsEnabled = stripeStatus?.payoutsEnabled ?? false;
      final double pending = stripeStatus?.pendingPayoutAmount ?? 0.0;

      return OverviewCard(
        title: 'Payout Info',
        trailing: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 10.0 : 10.w,
            vertical: isTablet ? 4.0 : 4.h,
          ),
          decoration: BoxDecoration(
            color: isPayoutsEnabled
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPayoutsEnabled
                    ? Icons.check_circle_rounded
                    : Icons.account_balance_rounded,
                size: isTablet ? 11.0 : 11.sp,
                color: isPayoutsEnabled
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFE65100),
              ),
              SizedBox(width: 4.w),
              Text(
                isPayoutsEnabled ? 'Active' : 'Setup Needed',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 10.0 : 10.sp,
                  fontWeight: FontWeight.w600,
                  color: isPayoutsEnabled
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100),
                ),
              ),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPayoutsEnabled) ...[
              Text(
                'Direct deposit is active. Your 50% profits are automatically deposited to your connected bank account.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => stripeController.openDashboard(),
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: 14.sp,
                      color: const Color(0xFFFF6FB6),
                    ),
                    label: Text(
                      'Stripe Dashboard',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF6FB6),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const VerificationRequiredScreen());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Manage Settings',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                pending > 0
                    ? 'You have \$${pending.toStringAsFixed(2)} in pending earnings! Connect your bank account with Stripe to receive your direct deposits.'
                    : 'Connect your bank account or debit card with Stripe to receive direct deposit earnings.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: stripeController.isOnboardingLoading.value
                        ? null
                        : () => stripeController.startOnboarding(),
                    icon: stripeController.isOnboardingLoading.value
                        ? SizedBox(
                            width: 14.r,
                            height: 14.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                    label: Text(
                      'Connect Bank',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6FB6),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const VerificationRequiredScreen());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'More details',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 14.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            if (hasPayoutNumber) ...[
              Divider(height: 20.h, color: const Color(0xFFF1F1F5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payout Manager Contact',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 10.5 : 10.5.sp,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        payoutNumber,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.5 : 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => const VerificationRequiredScreen());
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: const Color(0xFFFE53A1),
                      size: isTablet ? 18.0 : 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }
}
