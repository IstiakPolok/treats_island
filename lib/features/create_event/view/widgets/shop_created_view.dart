import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/api_service.dart';
import '../../../shop/view/create_pop_up_store_screen.dart';
import '../../../shop/view/store_note_screen.dart';
import '../../controller/schedule_event_controller.dart';
import '../supporters_screen.dart';
import 'shop_action_row.dart';
import 'video_player_screen.dart';

class ShopCreatedView extends StatelessWidget {
  final ScheduleEventController controller;
  final Map<String, dynamic>? fundraiser;
  final VoidCallback onShareTap;
  final VoidCallback? onRefresh;

  const ShopCreatedView({
    super.key,
    required this.controller,
    required this.fundraiser,
    required this.onShareTap,
    this.onRefresh,
  });

  Widget _buildShopListItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12.0 : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 11.0 : 11.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18.sp, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    final String? imgPath = fundraiser?['image']?.toString();
    final String? vidPath = fundraiser?['video']?.toString();

    final String imageUrl =
        (imgPath != null && imgPath.isNotEmpty && imgPath != 'null')
            ? ApiService.formatImageUrl(imgPath)
            : 'https://cdn.vectorstock.com/i/500p/28/59/flat-style-male-avatar-person-icon-vector-59492859.jpg';

    final String? videoUrl =
        (vidPath != null && vidPath.isNotEmpty && vidPath != 'null')
            ? ApiService.formatImageUrl(vidPath)
            : null;

    final double coverHeight = isTablet ? 140.0 : 140.h;
    final double avatarSize = isTablet ? 100.0 : 120.w;

    return Column(
      children: [
        SizedBox(
          height: coverHeight + (avatarSize / 2),
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover Image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: coverHeight,
                child: GestureDetector(
                  onTap: () {
                    if (videoUrl != null) {
                      Get.to(() => VideoPlayerScreen(videoUrl: videoUrl));
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      isTablet ? 18.0 : 18.r,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/popupstorebg.PNG',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/popupstorebg.PNG',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        if (videoUrl != null) ...[
                          Container(color: Colors.black12),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(isTablet ? 8.0 : 8.r),
                              child: Container(
                                padding: EdgeInsets.all(
                                  isTablet ? 6.0 : 6.r,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  size: isTablet ? 26.0 : 26.sp,
                                  color: const Color(0xFFFF6FB6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
                      color: const Color(0xFFFF6FB6),
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
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFFFEAF4),
                                child: Icon(
                                  Icons.person,
                                  color: const Color(0xFFFF6FB6),
                                  size: isTablet ? 50.0 : 50.sp,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFFFFEAF4),
                            child: Icon(
                              Icons.person,
                              color: const Color(0xFFFF6FB6),
                              size: isTablet ? 50.0 : 50.sp,
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
                  '${fundraiser?['name']?.toString() ?? 'My Shop'} ',
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
        SizedBox(height: 16.h),
        ShopActionRow(
          controller: controller,
          fundraiser: fundraiser,
          onShareTap: onShareTap,
        ),
        SizedBox(height: 12.h),
        _buildShopListItem(
          context: context,
          title: 'Message to Supporters',
          onTap: () =>
              Get.to(() => const StoreNoteScreen())?.then((value) {
                if (value == true) {
                  onRefresh?.call();
                }
              }),
          subtitle:
              fundraiser?['description']?.toString() != null &&
                      fundraiser!['description'].toString().trim().isNotEmpty
                  ? fundraiser!['description'].toString()
                  : 'This will appear on your pop-up store.',
        ),
        SizedBox(height: 12.h),
        _buildShopListItem(
          context: context,
          title: 'My Supporters',
          subtitle: 'View your pop-up store supporters.',
          onTap: () => Get.to(() => const SupportersScreen()),
        ),
        SizedBox(height: 12.h),
        _buildShopListItem(
          context: context,
          title: 'Pop-up store settings',
          subtitle: 'Preview and edit your pop-up store.',
          onTap: () => Get.to(() => const CreatePopUpStoreScreen()),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
