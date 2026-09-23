import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/stripe_connect_controller.dart';

class ShopPayoutStatusBanner extends StatelessWidget {
  const ShopPayoutStatusBanner({super.key});

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final StripeConnectController controller =
        Get.isRegistered<StripeConnectController>()
            ? Get.find<StripeConnectController>()
            : Get.put(StripeConnectController());

    return Obx(() {
      final status = controller.status.value;
      final bool isConnected = status?.payoutsEnabled ?? false;
      final double totalEarned = status?.totalCreatorEarnings ?? 0.0;
      final double pendingPayout = status?.pendingPayoutAmount ?? 0.0;
      final double transferred = status?.transferredAmount ?? 0.0;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isTablet ? 18.0 : 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isConnected
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFE0B2),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isConnected
                            ? Icons.account_balance_rounded
                            : Icons.account_balance_outlined,
                        size: isTablet ? 18.0 : 18.sp,
                        color: isConnected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'My Shop Earnings',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 14.0 : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                if (isConnected)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 12.sp,
                          color: const Color(0xFF2E7D32),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 10.0 : 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pending_actions_rounded,
                          size: 12.sp,
                          color: const Color(0xFFE65100),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Setup Needed',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 10.0 : 10.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 14.h),

            // Earnings Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FC),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Earned (50%)',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 10.5 : 10.5.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _formatCurrency(totalEarned),
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 16.0 : 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FC),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isConnected ? 'Transferred to Bank' : 'Pending Payout',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 10.5 : 10.5.sp,
                            color: isConnected
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _formatCurrency(
                            isConnected ? transferred : pendingPayout,
                          ),
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
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // State specific banner & action
            if (!isConnected) ...[
              // State 1: Not connected
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6.w),
                        Text(
                          'Action Required',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBF360C),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      pendingPayout > 0
                          ? 'You have ${_formatCurrency(pendingPayout)} waiting! Connect your bank account so we can transfer your 50%.'
                          : 'Connect your bank account so customer candy purchases can be deposited directly to you.',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 11.5 : 11.5.sp,
                        color: const Color(0xFF5D4037),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: isTablet ? 46.0 : 46.h,
                child: ElevatedButton(
                  onPressed: controller.isOnboardingLoading.value
                      ? null
                      : () => controller.startOnboarding(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6FB6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: controller.isOnboardingLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Complete Payout Setup',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (pendingPayout > 0) ...[
                SizedBox(height: 8.h),
                Center(
                  child: TextButton.icon(
                    onPressed: controller.isRetrying.value
                        ? null
                        : () => controller.retryPendingPayouts(),
                    icon: controller.isRetrying.value
                        ? SizedBox(
                            width: 14.r,
                            height: 14.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: Color(0xFF1A1A2E),
                            ),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 14.sp,
                            color: const Color(0xFF1A1A2E),
                          ),
                    label: Text(
                      'Transfer Pending Earnings Now',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 11.5 : 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ),
              ],
            ] else ...[
              // State 2: Connected & verified
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16.sp,
                      color: const Color(0xFF2E7D32),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Direct Deposit Active',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B5E20),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Payouts are automatically sent to your connected bank account.',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 11.5 : 11.5.sp,
                              color: const Color(0xFF2E7D32),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: isTablet ? 46.0 : 46.h,
                child: OutlinedButton.icon(
                  onPressed: controller.isDashboardLoading.value
                      ? null
                      : () => controller.openDashboard(),
                  icon: controller.isDashboardLoading.value
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1A1A2E),
                          ),
                        )
                      : Icon(
                          Icons.open_in_new_rounded,
                          size: 16.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                  label: Text(
                    'View Stripe Payout Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFD4D4DF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
