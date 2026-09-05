import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/services/api_service.dart';
import '../../utils/share_helper.dart';

class SharePopupStoreSheet {
  static void show(
    BuildContext context,
    Map<String, dynamic> fundraiser,
  ) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    try {
      final String shareLink = fundraiser['share_link']?.toString() ?? '';
      final String shopName = fundraiser['name']?.toString() ?? 'My Shop';

      // Construct shop image URL
      var shopImageUrl = '';
      if (fundraiser['image'] != null &&
          fundraiser['image'].toString().isNotEmpty &&
          fundraiser['image'].toString() != 'null') {
        shopImageUrl = ApiService.formatImageUrl(
          fundraiser['image'].toString(),
        );
      }

      // Construct shop video URL
      var shopVideoUrl = '';
      if (fundraiser['video'] != null &&
          fundraiser['video'].toString().isNotEmpty &&
          fundraiser['video'].toString() != 'null') {
        shopVideoUrl = ApiService.formatImageUrl(
          fundraiser['video'].toString(),
        );
      }

      final String shopDescription =
          fundraiser['description']?.toString() ??
          'Support my fundraising campaign!';

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        builder: (sheetContext) {
          final double coverHeight = isTablet ? 140.0 : 140.h;
          final double avatarSize = isTablet ? 100.0 : 100.w;

          return Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 16.h,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pull bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Cover Image with overlapping circular avatar
                  SizedBox(
                    height: coverHeight + (avatarSize / 2),
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: coverHeight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 18.0 : 18.r,
                            ),
                            child: Image.asset(
                              'assets/images/popupstorebg.PNG',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Overlapping Circular Profile Image
                        Positioned(
                          left: isTablet ? 20.0 : 20.w,
                          top: coverHeight - (avatarSize / 2),
                          child: Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: isTablet ? 3.5 : 3.5.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: shopImageUrl.isNotEmpty
                                  ? Image.network(
                                      shopImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: const Color(0xFFFFEAF4),
                                                child: Icon(
                                                  Icons.person,
                                                  color: const Color(
                                                    0xFFFF6FB6,
                                                  ),
                                                  size: isTablet ? 48.0 : 48.sp,
                                                ),
                                              ),
                                    )
                                  : Container(
                                      color: const Color(0xFFFFEAF4),
                                      child: Icon(
                                        Icons.person,
                                        color: const Color(0xFFFF6FB6),
                                        size: isTablet ? 48.0 : 48.sp,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Store Name Right of Avatar Below Cover
                        Positioned(
                          left:
                              (isTablet ? 20.0 : 20.w) +
                              avatarSize +
                              (isTablet ? 12.0 : 12.w),
                          top: coverHeight + (isTablet ? 6.0 : 6.h),
                          right: isTablet ? 16.0 : 16.w,
                          child: Text(
                            '$shopName Pop-Up Store',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 15.0 : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: (avatarSize / 2) + 12.h),
                  if (shopDescription.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8FB),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: const Color(0xFFEAEAEE)),
                      ),
                      child: Text(
                        shopDescription,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          color: Colors.black54,
                          height: 1.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                  // Link display and copy button
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: shareLink.isNotEmpty
                              ? () async {
                                  final Uri url = Uri.parse(shareLink);
                                  try {
                                    if (!await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      Get.snackbar(
                                        'Error',
                                        'Could not launch $shareLink',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.withAlpha(
                                          26,
                                        ),
                                        colorText: Colors.black,
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      'Error',
                                      'Invalid link format',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red.withAlpha(26),
                                      colorText: Colors.black,
                                    );
                                  }
                                }
                              : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F7),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Text(
                              shareLink.isNotEmpty
                                  ? shareLink
                                  : 'No link available',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                color: Colors.black87,
                                decoration: shareLink.isNotEmpty
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: shareLink));
                          Get.snackbar(
                            'Copied',
                            'Link copied to clipboard!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black.withAlpha(26),
                            colorText: Colors.black,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A2E),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Builder(
                        builder: (btnContext) {
                          return GestureDetector(
                            onTap: () {
                              final String shareText = shareLink.isNotEmpty
                                  ? 'Check out $shopName Pop-Up Store and support our fundraiser!\n\n$shopDescription\n\n$shareLink'
                                  : shopName.isNotEmpty
                                  ? 'Check out $shopName Pop-Up Store and support our fundraiser!\n\n$shopDescription'
                                  : 'Check out our fundraising Pop-Up Store!\n\n$shopDescription';

                              final box =
                                  btnContext.findRenderObject() as RenderBox?;
                              ShareHelper.shareTextAndImage(
                                shareText,
                                box != null
                                    ? (box.localToGlobal(Offset.zero) &
                                          box.size)
                                    : null,
                                imageUrl: shopImageUrl.isNotEmpty
                                    ? shopImageUrl
                                    : null,
                                videoUrl: shopVideoUrl.isNotEmpty
                                    ? shopVideoUrl
                                    : null,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6FB6),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 10.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      );
    } catch (e, stack) {
      debugPrint('=== EXCEPTION IN SharePopupStoreSheet: $e ===');
      debugPrint(stack.toString());
      Get.snackbar(
        'Error',
        'Could not show share options: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.black,
      );
    }
  }
}
