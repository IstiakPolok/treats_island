import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../shared/widgets/bottom_navbar.dart';
import '../../otp/view/verification_required_screen.dart';
import '../../shop/view/create_pop_up_store_screen.dart';
import '../../shop/view/store_note_screen.dart';
import 'supporters_screen.dart';
import 'leaderboard_screen.dart';

import '../controller/schedule_event_controller.dart';

class EventOverviewScreen extends StatefulWidget {
  final ScheduleEventController controller;
  final bool showCongratsSheet;
  final bool showShopTab;

  const EventOverviewScreen({
    super.key,
    required this.controller,
    this.showCongratsSheet = false,
    this.showShopTab = false,
  });

  @override
  State<EventOverviewScreen> createState() => _EventOverviewScreenState();
}

class _EventOverviewScreenState extends State<EventOverviewScreen> {
  late bool _isShopSelected;
  String _organizerName = 'No Name added';

  @override
  void initState() {
    super.initState();
    _isShopSelected = widget.showShopTab;
    _loadOrganizerName();
    if (widget.showCongratsSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCongratsSheet();
      });
    }
  }

  Future<void> _loadOrganizerName() async {
    final name = await SharedPreferencesHelper.getName();
    if (name.isNotEmpty) {
      setState(() {
        _organizerName = name;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildShopHeroCard() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: () => Get.to(() => const CreatePopUpStoreScreen()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          color: const Color(0xFFF6D6E5),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: -16.h,
                child: Image.asset(
                  'assets/images/createshobgcard.png',
                  width: 150.w,
                  height: 150.w,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREATE YOUR POP-UP STORE',
                            style: GoogleFonts.antonSc(
                              fontSize: isTablet ? 22.0 : 22.sp,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Your Virtual Pop-Up Store',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF6FB6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareBottomSheet(
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
          fundraiser['image'].toString().isNotEmpty) {
        shopImageUrl = ApiService.formatImageUrl(
          fundraiser['image'].toString(),
        );
      }

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        builder: (sheetContext) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 30.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: shopImageUrl.isNotEmpty
                        ? Image.network(
                            shopImageUrl,
                            width: isTablet ? 280.0 : 300.w,
                            height: isTablet ? 280.0 : 300.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  'assets/icons/icon2.png',
                                  width: isTablet ? 280.0 : 300.w,
                                  height: isTablet ? 280.0 : 300.w,
                                  fit: BoxFit.cover,
                                ),
                          )
                        : Image.asset(
                            'assets/icons/icon2.png',
                            width: isTablet ? 280.0 : 300.w,
                            height: isTablet ? 280.0 : 300.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                  // Pull bar
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8FB),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFEAEAEE)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                ' $shopName Pop-Up Store',

                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 15.0 : 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A2E),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Support my fundraising campaign!',
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 12.0 : 12.sp,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
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
                                  ? 'Check out $shopName Pop-Up Store and support our fundraiser!\n\n$shareLink'
                                  : shopName.isNotEmpty
                                  ? 'Check out $shopName Pop-Up Store and support our fundraiser!'
                                  : 'Check out our fundraising Pop-Up Store!';

                              final box =
                                  btnContext.findRenderObject() as RenderBox?;
                              final Rect? origin =
                                  (box != null &&
                                      box.hasSize &&
                                      box.size.width > 0 &&
                                      box.size.height > 0)
                                  ? (box.localToGlobal(Offset.zero) & box.size)
                                  : null;

                              Share.share(
                                shareText,
                                subject: '$shopName Pop-Up Store',
                                sharePositionOrigin: origin,
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
      debugPrint('=== EXCEPTION IN _showShareBottomSheet: $e ===');
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

  Widget _buildShopActionRow(Map<String, dynamic>? fundraiser) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final goalVal = fundraiser?['goal'];
    final double? parsedGoal = goalVal != null
        ? double.tryParse(goalVal.toString())
        : null;
    final String goalText = parsedGoal != null
        ? '\$${parsedGoal.toInt()}'
        : '\$0';

    final achievedVal = fundraiser?['achieved'];
    final double? parsedAchieved = achievedVal != null
        ? double.tryParse(achievedVal.toString())
        : null;
    final String achievedText = parsedAchieved != null
        ? '\$${parsedAchieved.toInt()}'
        : '\$0';

    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final String status = eventData?['status']?.toString() ?? '';
    final bool isOngoing = status.toLowerCase() == 'ongoing';

    if (isOngoing) {
      final double achVal = parsedAchieved ?? 0.0;
      final double gVal = parsedGoal ?? 1200.0;
      final double progress = gVal > 0 ? (achVal / gVal).clamp(0.0, 1.0) : 0.0;

      // Calculate time remaining using start_date and duration
      String timeToGo = 'Ongoing';
      if (eventData?['start_date'] != null && eventData?['duration'] != null) {
        final parsedStart = DateTime.tryParse(
          eventData!['start_date'].toString(),
        );
        final durationDays =
            int.tryParse(eventData['duration'].toString()) ?? 5;
        if (parsedStart != null) {
          final end = parsedStart.add(Duration(days: durationDays));
          final now = DateTime.now();
          final diff = end.difference(now);
          if (diff.isNegative) {
            timeToGo = 'Event ended';
          } else {
            final days = diff.inDays;
            final hours = diff.inHours % 24;
            timeToGo = '$days Day $hours Hours To Go';
          }
        }
      }

      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: -10.h,
              child: Image.asset(
                'assets/images/money.png',
                width: 160.w,
                height: 160.w,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Fundraise',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 13.0 : 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          achievedText,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 28.0 : 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        final eventData =
                            widget.controller.createdEvent['event']
                                as Map<String, dynamic>?;
                        final int? eventId =
                            eventData?['id'] as int? ??
                            widget.controller.createdEvent['id'] as int?;
                        debugPrint(
                          '🚀 [SHARE LINK TAP] Tapped Share Link Button',
                        );
                        debugPrint(
                          '🔗 API URL: https://api.treatsislandgo.com/event/$eventId/my-fundraiser/',
                        );

                        Map<String, dynamic>? data =
                            fundraiser ??
                            widget.controller.fundraiserDetails.value;
                        if (data == null || data.isEmpty) {
                          data = await _getFundraiserDetails();
                        }

                        debugPrint('📦 Response Body (Fundraiser Data): $data');
                        debugPrint('👉 Share Link: ${data?["share_link"]}');

                        if (data != null && context.mounted) {
                          _showShareBottomSheet(context, data);
                        } else {
                          Get.snackbar(
                            'Error',
                            'Could not load Pop-up store details. Please try again.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black.withAlpha(26),
                            colorText: Colors.black,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.15),
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Text(
                          'Share Link',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12.h,
                    backgroundColor: const Color(0xFFF1F1F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF6FB6),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          timeToGo,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 13.0 : 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Goal ',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                          TextSpan(
                            text: goalText,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 15.0 : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fundraising Goal',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                    if (isOngoing)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          'Achieved',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goalText,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18.0 : 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    if (isOngoing)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          achievedText,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 18.0 : 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final eventData =
                  widget.controller.createdEvent['event']
                      as Map<String, dynamic>?;
              final int? eventId =
                  eventData?['id'] as int? ??
                  widget.controller.createdEvent['id'] as int?;
              debugPrint(
                '🚀 [SHARE LINK TAP (not ongoing)] Tapped Share Link Button',
              );
              debugPrint(
                '🔗 API URL: https://api.treatsislandgo.com/event/$eventId/my-fundraiser/',
              );

              Map<String, dynamic>? data =
                  fundraiser ?? widget.controller.fundraiserDetails.value;
              if (data == null || data.isEmpty) {
                data = await _getFundraiserDetails();
              }

              debugPrint('📦 Response Body (Fundraiser Data): $data');
              debugPrint('👉 Share Link: ${data?["share_link"]}');

              if (data != null && context.mounted) {
                _showShareBottomSheet(context, data);
              } else {
                Get.snackbar(
                  'Error',
                  'Could not load Pop-up store details. Please try again.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black.withAlpha(26),
                  colorText: Colors.black,
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6FB6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Share Link',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 11.0 : 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopListItem({
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

  List<Widget> _buildShopCreatedChildren(Map<String, dynamic>? fundraiser) {
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

    return [
      GestureDetector(
        onTap: () {
          debugPrint('=== TAP VIDEO CARD: videoUrl = $videoUrl ===');
          if (videoUrl != null) {
            Get.to(() => VideoPlayerScreen(videoUrl: videoUrl));
          }
        },
        child: Container(
          height: 140.h,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF1F1F5),
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.black26,
                        size: 40.sp,
                      ),
                    );
                  },
                ),
                if (videoUrl != null) ...[
                  Container(color: Colors.black26),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 26.sp,
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
      SizedBox(height: 16.h),
      _buildShopActionRow(fundraiser),
      SizedBox(height: 12.h),
      _buildShopListItem(
        title: 'Store Note',
        onTap: () => Get.to(() => const StoreNoteScreen())?.then((value) {
          if (value == true) {
            setState(() {});
          }
        }),
        subtitle:
            fundraiser?['description']?.toString() != null &&
                fundraiser!['description'].toString().trim().isNotEmpty
            ? fundraiser['description'].toString()
            : 'This will appear on your pop-up store.',
      ),
      SizedBox(height: 12.h),
      _buildShopListItem(
        title: 'My Supporters',
        subtitle: 'View your pop-up store supporters.',
        onTap: () => Get.to(() => const SupportersScreen()),
      ),
      SizedBox(height: 12.h),
      _buildShopListItem(
        title: 'Pop-up store settings',
        subtitle: 'Preview and edit your pop-up store.',
        onTap: () => Get.to(() => const CreatePopUpStoreScreen()),
      ),
      SizedBox(height: 24.h),
    ];
  }

  Widget _buildShopInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.sp, color: const Color(0xFF1A1A2E)),
          SizedBox(width: 10.w),
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
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildShopChildren() {
    return [
      _buildShopHeroCard(),
      SizedBox(height: 14.h),
      _buildShopInfoCard(
        icon: Icons.star_border_rounded,
        title: 'Sell with your team',
        subtitle:
            '98% of Organizers that participate in their\nfundraiser help raise 2x more!',
      ),
      SizedBox(height: 12.h),
      _buildShopInfoCard(
        icon: Icons.storefront_outlined,
        title: 'Your virtual Pop-Up Store',
        subtitle:
            'You\'ll have a unique link to share with your\nfriends and family',
      ),
      SizedBox(height: 24.h),
    ];
  }

  Widget _buildFundraiseSummaryCard() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final double totalSale =
        eventData != null && eventData['total_achieved'] != null
        ? double.tryParse(eventData['total_achieved'].toString()) ?? 0.0
        : 0.0;
    final List participants = eventData?['participants'] as List? ?? [];
    final int storeCount = participants.length;

    // Sort participants by shop_achieved in descending order for the leaderboard
    final List sortedParticipants = List.from(participants);
    sortedParticipants.sort((a, b) {
      final double achievedA =
          double.tryParse(a['shop_achieved']?.toString() ?? '0') ?? 0.0;
      final double achievedB =
          double.tryParse(b['shop_achieved']?.toString() ?? '0') ?? 0.0;
      return achievedB.compareTo(achievedA);
    });

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FB),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fundraise Summary',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 15.0 : 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$${totalSale.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 28.0 : 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Total sale',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBF4),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storefront_outlined,
                        size: 14.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$storeCount',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6FB6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Leaderboard',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 15.0 : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => LeaderboardScreen(controller: widget.controller),
                  );
                },
                child: Text(
                  'See more',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF6FB6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (sortedParticipants.length <= 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'No participants yet',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    color: Colors.black45,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedParticipants.length > 5
                  ? 5
                  : sortedParticipants.length,
              separatorBuilder: (context, index) => _buildDivider(),
              itemBuilder: (context, index) {
                final participant =
                    sortedParticipants[index] as Map<String, dynamic>;
                final String participantName =
                    participant['full_name']?.toString() ?? 'Unnamed Seller';
                final String imageSubpath =
                    participant['image']?.toString() ?? '';
                final String avatarUrl = ApiService.formatImageUrl(
                  imageSubpath,
                );
                final double achieved =
                    double.tryParse(
                      participant['shop_achieved']?.toString() ?? '0',
                    ) ??
                    0.0;
                final double goal =
                    double.tryParse(
                      participant['shop_goal']?.toString() ?? '0',
                    ) ??
                    0.0;
                final int supportersCount =
                    int.tryParse(
                      participant['total_supporters']?.toString() ?? '0',
                    ) ??
                    0;
                return _buildLeaderboardItem(
                  index + 1,
                  participantName,
                  supportersCount,
                  achieved,
                  avatarUrl,
                  goal: goal,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(
    int index,
    String name,
    int supporters,
    double amount,
    String avatarUrl, {
    double? goal,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          builder: (context) {
            final double finalGoal = (goal != null && goal > 0)
                ? goal
                : (amount > 600 ? amount * 1.5 : 1200);
            final double progress = finalGoal > 0
                ? (amount / finalGoal).clamp(0.0, 1.0)
                : 0.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 42.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Image.network(
                      avatarUrl,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 70.w,
                          height: 70.w,
                          color: const Color(0xFFF1F1F5),
                          child: Icon(
                            Icons.person,
                            color: Colors.black26,
                            size: 35.sp,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 16.0 : 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.h,
                      backgroundColor: const Color(0xFFEFEFEF),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6FB6),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${amount.toStringAsFixed(0)} ',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF6FB6),
                              ),
                            ),
                            TextSpan(
                              text: 'of ${finalGoal.toStringAsFixed(0)} goal',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$supporters supporters',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                      child: Text(
                        'Visit pop-up store',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 16.0 : 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                '$index',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13.0 : 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                avatarUrl,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40.w,
                    height: 40.w,
                    color: const Color(0xFFF1F1F5),
                    child: Icon(
                      Icons.person,
                      color: Colors.black26,
                      size: 20.sp,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 40.w,
                    height: 40.w,
                    color: const Color(0xFFF1F1F5),
                    child: Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black26,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$supporters supporters',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 11.0 : 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 13.0 : 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.black.withValues(alpha: 0.05));
  }

  List<Widget> _buildEventChildren(bool showFundraiseCard) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return [
      Obx(() {
        final Map<String, dynamic>? eventData =
            widget.controller.createdEvent['event'] as Map<String, dynamic>?;
        final String status = eventData?['status']?.toString() ?? '';
        final bool isOngoing = status.toLowerCase() == 'ongoing';
        if (isOngoing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFundraiseSummaryCard(),
              SizedBox(height: 16.h),
            ],
          );
        }
        return const SizedBox.shrink();
      }),
      Obx(() {
        final Map<String, dynamic>? eventData =
            widget.controller.createdEvent['event'] as Map<String, dynamic>?;
        final String status = eventData?['status']?.toString() ?? '';
        final bool isOngoing = status.toLowerCase() == 'ongoing';

        if (isOngoing) {
          return const SizedBox.shrink();
        }

        final List participants = eventData?['participants'] as List? ?? [];

        if (participants.isEmpty || participants.length == 1) {
          return _Card(
            title: 'Invite Your Team',
            subtitle: 'Nobody Has Joined Yet',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/eventteaminvite.png',
                    width: 200.w,
                    height: 120.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: 140.w,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: _showInviteTeamSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Invite Seller',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return _Card(
          title: 'Your Team',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: participants.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24.h,
                  color: Colors.black.withValues(alpha: 0.05),
                ),
                itemBuilder: (context, index) {
                  final participant =
                      participants[index] as Map<String, dynamic>;
                  final String name =
                      participant['full_name']?.toString() ?? 'No Name';
                  final String? imageRelPath = participant['image']?.toString();
                  final String imageUrl = ApiService.formatImageUrl(
                    imageRelPath,
                  );

                  return Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: 40.w,
                                height: 40.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 40.w,
                                    height: 40.w,
                                    color: const Color(0xFFF1F1F5),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black26,
                                      size: 20.sp,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 40.w,
                                height: 40.w,
                                color: const Color(0xFFF1F1F5),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                  size: 20.sp,
                                ),
                              ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 140.w,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: _showInviteTeamSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Invite Seller',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      SizedBox(height: 16.h),
      Obx(() {
        final Map<String, dynamic> rawMap = widget.controller.createdEvent;
        final Map<String, dynamic>? eventData = rawMap['event'] is Map
            ? rawMap['event'] as Map<String, dynamic>
            : null;
        final String? payoutNumber =
            eventData?['payout_manager']?.toString() ??
            rawMap['payout_manager']?.toString();
        final bool hasPayoutNumber =
            payoutNumber != null &&
            payoutNumber.trim().isNotEmpty &&
            payoutNumber != 'null';

        return _Card(
          title: 'Payout Manager',
          badge: 'Secure & Simple',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPayoutNumber) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payout Manager Number',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 11.0 : 11.sp,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          payoutNumber,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 15.0 : 15.sp,
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
                        Icons.edit,
                        color: const Color(0xFFFE53A1),
                        size: isTablet ? 18.0 : 18.sp,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Text(
                  'Verify yourself and select how to receive\n'
                  'the event earnings.',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 12.0 : 12.sp,
                    color: Colors.black45,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
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
                          'Get started',
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
                ),
              ],
            ],
          ),
        );
      }),
      SizedBox(height: 16.h),
      _Card(
        title: 'Event Details',
        trailing: _SmallPill(text: 'Edit'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final Map<String, dynamic>? eventData =
                  widget.controller.createdEvent['event']
                      as Map<String, dynamic>?;
              final code =
                  eventData?['code'] ??
                  widget.controller.createdEvent['code'] ??
                  'No Code Found';

              return GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code.toString()));
                  Get.snackbar(
                    'Copied',
                    'Event code copied to clipboard!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black.withAlpha(26),
                    colorText: Colors.black,
                  );
                },
                child: _DetailsRow(
                  label: 'EVENT CODE',
                  value: code.toString(),
                  trailing: Icon(
                    Icons.copy_rounded,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                ),
              );
            }),
            _DashedDivider(color: const Color(0xFFEDEDF2)),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoMini(
                    title: 'START DATE',
                    value: DateFormat(
                      'EEEE, MMMM dd, yyyy',
                    ).format(widget.controller.startDate.value),
                  ),
                  _InfoMinidate(
                    title: 'START TIME',
                    value: widget.controller.formattedStartTime,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoMini(
                    title: 'END DATE',
                    value: DateFormat(
                      'EEEE, MMMM dd, yyyy',
                    ).format(widget.controller.endDate),
                  ),
                  _InfoMinidate(
                    title: 'END TIME',
                    value: widget.controller.formattedEndTime,
                  ),
                ],
              ),
            ),
            _DashedDivider(color: const Color(0xFFEDEDF2)),
            Row(
              children: [
                Expanded(
                  child: _InfoMini(title: 'Organizer', value: _organizerName),
                ),
                SizedBox(
                  //width: 125.w,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: () {
                      final Map<String, dynamic>? eventData =
                          widget.controller.createdEvent['event']
                              as Map<String, dynamic>?;
                      final code =
                          eventData?['code'] ??
                          widget.controller.createdEvent['code'] ??
                          '';

                      DateTime? startDateTime;
                      DateTime? endDateTime;
                      if (eventData?['start_date'] != null) {
                        startDateTime = DateTime.tryParse(
                          eventData!['start_date'].toString(),
                        )?.toLocal();
                      }
                      if (eventData?['end_date'] != null) {
                        endDateTime = DateTime.tryParse(
                          eventData!['end_date'].toString(),
                        )?.toLocal();
                      }

                      final String startD = startDateTime != null
                          ? DateFormat('MM/dd/yy').format(startDateTime)
                          : '___/___/26';
                      final String startT = startDateTime != null
                          ? DateFormat(
                              'h:mm a',
                            ).format(startDateTime).toLowerCase()
                          : '9:00 am';
                      final String endD = endDateTime != null
                          ? DateFormat('MM/dd/yy').format(endDateTime)
                          : '___/___/26';
                      final String endT = endDateTime != null
                          ? DateFormat(
                              'h:mm a',
                            ).format(endDateTime).toLowerCase()
                          : '9:00 am';

                      final String inviteLink =
                          'https://treatsislandcandy.store/join-event?je=$code';

                      final String shareText =
                          'Hello Team - I set up a virtual fundraiser with Treats Island Candy! It is 100% contactless. We get to keep 50% of total profit and Treat Island Candy will ship the product directly to our buyers. Each of us will create a Pop-Up Store selling this specialized candy! The prices range from \$15 to \$25 per container and you won\'t find these premium products in general stores. Our fundraising window begins on $startD at $startT and goes until $endD, at $endT. Before the fundraiser begins:\n\n'
                          'Click on the link $inviteLink to JOIN THE EVENT\n\n'
                          'Confirm the Event Code $code.   Download the APP.\n\n'
                          'Create your personalized Pop-Up Store';

                      final box = context.findRenderObject() as RenderBox?;
                      Share.share(
                        shareText,
                        sharePositionOrigin: box != null
                            ? (box.localToGlobal(Offset.zero) & box.size)
                            : null,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Share Event',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      InkWell(
        onTap: () async {
          final String? shareLink = widget
              .controller
              .fundraiserDetails['share_link']
              ?.toString();
          if (shareLink != null && shareLink.isNotEmpty) {
            final Uri url = Uri.parse(shareLink);
            try {
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                Get.snackbar(
                  'Error',
                  'Could not launch $shareLink',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black.withAlpha(26),
                  colorText: Colors.black,
                );
              }
            } catch (e) {
              debugPrint('Launch URL Exception: $e');
            }
          } else {
            Get.snackbar(
              'Info',
              'Share link is not available yet',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black.withAlpha(26),
              colorText: Colors.black,
            );
          }
        },
        borderRadius: BorderRadius.circular(20.r),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.asset(
            'assets/images/imagebutton.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 20.h),
    ];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Edit Event Sheet
  // ─────────────────────────────────────────────────────────────────────────
  void _showEditEventSheet() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final int eventId = eventData?['id'] as int? ?? 0;

    // Pre-fill local state
    final nameCtrl = TextEditingController(
      text: eventData?['name']?.toString() ?? '',
    );

    // Determine the currently selected type name from categoryObjects
    final int? currentTypeId = eventData?['type'] is int
        ? eventData!['type'] as int
        : int.tryParse(eventData?['type']?.toString() ?? '');
    String currentTypeName =
        widget.controller.categoryObjects
            .where((e) => e['id'] == currentTypeId)
            .map((e) => e['name']?.toString() ?? '')
            .firstOrNull ??
        '';
    final selectedType = currentTypeName.obs;

    // Start date
    DateTime? currentStart;
    if (eventData?['start_date'] != null) {
      currentStart = DateTime.tryParse(
        eventData!['start_date'].toString(),
      )?.toLocal();
    }
    currentStart ??= widget.controller.startDate.value;
    final selectedDate = currentStart.obs;

    // Estimated participants
    final List<int?> participantOptions = [null, 5, 10, 20, 30, 50, 51];
    final int? currentParticipants = eventData?['estimated_participants'] is int
        ? eventData!['estimated_participants'] as int
        : int.tryParse(eventData?['estimated_participants']?.toString() ?? '');
    final selectedParticipants = currentParticipants.obs;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Handle bar ───────────────────────────────────────
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ─── Header ───────────────────────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(sheetContext),
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Edit Event',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18.0 : 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // ─── Event Name ───────────────────────────────────────
                Text(
                  'Event Name',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14.0 : 14.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter event name',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: isTablet ? 14.0 : 14.sp,
                      color: Colors.black38,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ─── Organization Type ────────────────────────────────
                Text(
                  'Organization Type',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(() {
                  final cats = widget.controller.categories;
                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: cats.map((cat) {
                      final isSelected = selectedType.value == cat;
                      return GestureDetector(
                        onTap: () => selectedType.value = cat,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A1A2E)
                                : const Color(0xFFF1F1F5),
                            borderRadius: BorderRadius.circular(22.r),
                            border: isSelected
                                ? null
                                : Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF525252),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 20.h),

                // ─── Start Date ───────────────────────────────────────
                Text(
                  'Start Date',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: sheetContext,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 3),
                        ),
                      );
                      if (picked != null) {
                        selectedDate.value = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          selectedDate.value.hour,
                          selectedDate.value.minute,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(selectedDate.value),
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 14.0 : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18.sp,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // ─── Estimated Participants ───────────────────────────
                Text(
                  'Estimated Participants',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 2.4,
                    children: participantOptions.map((opt) {
                      final isSelected = selectedParticipants.value == opt;
                      final label = opt == null
                          ? 'Just me'
                          : opt == 51
                          ? '51+'
                          : '$opt';
                      return GestureDetector(
                        onTap: () => selectedParticipants.value = opt,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFE53A1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFE53A1)
                                  : const Color(0xFFE0E0E0),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 14.0 : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 28.h),

                // ─── Save Button ──────────────────────────────────────
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: widget.controller.isUpdating.value
                          ? null
                          : () async {
                              // Resolve type slug from name
                              final typeName = selectedType.value;
                              String? typeSlug;
                              if (typeName.isNotEmpty) {
                                final match = widget.controller.categoryObjects
                                    .where((e) => e['name'] == typeName)
                                    .firstOrNull;
                                if (match != null) {
                                  typeSlug = match['slug']?.toString();
                                }
                                typeSlug ??= typeName
                                    .toLowerCase()
                                    .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
                                    .replaceAll(RegExp(r'\s+'), '-');
                              }

                              final startIso = selectedDate.value
                                  .toUtc()
                                  .toIso8601String()
                                  .replaceAll(RegExp(r'\.\d+'), '');

                              final int? participants =
                                  selectedParticipants.value;
                              final double? minE = participants != null
                                  ? (participants * 40).toDouble()
                                  : null;
                              final double? maxE = participants != null
                                  ? (participants * 440).toDouble()
                                  : null;

                              final success = await widget.controller
                                  .updateEvent(
                                    eventId: eventId,
                                    name: nameCtrl.text.trim().isEmpty
                                        ? null
                                        : nameCtrl.text.trim(),
                                    typeSlug: typeSlug,
                                    startDateIso: startIso,
                                    estimatedParticipants: participants,
                                    minEstimatedEarning: minE,
                                    maxEstimatedEarning: maxE,
                                  );

                              if (success && sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A2E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: widget.controller.isUpdating.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 15.0 : 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCongratsSheet() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;

    DateTime? startDateTime;
    DateTime? endDateTime;
    if (eventData?['start_date'] != null) {
      startDateTime = DateTime.tryParse(
        eventData!['start_date'].toString(),
      )?.toLocal();
    }
    if (eventData?['end_date'] != null) {
      endDateTime = DateTime.tryParse(
        eventData!['end_date'].toString(),
      )?.toLocal();
    }

    final String eventCode = eventData?['code']?.toString() ?? 'ZVT AYF';
    final String displayStartDate = startDateTime != null
        ? DateFormat('EEEE, MMMM dd, yyyy').format(startDateTime)
        : 'Monday, May 22, 2026';
    final String displayStartTime = startDateTime != null
        ? DateFormat('h:mm a').format(startDateTime)
        : '5.00 pm';
    final String displayEndDate = endDateTime != null
        ? DateFormat('EEEE, MMMM dd, yyyy').format(endDateTime)
        : 'Monday, May 22, 2026';
    final String displayEndTime = endDateTime != null
        ? DateFormat('h:mm a').format(endDateTime)
        : '5.00 pm';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 20.h,
            bottom: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.celebration,
                    color: AppColors.primary,
                    size: 40.sp,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Congratulations, $_organizerName!\nYour Event Is Scheduled',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 20.0 : 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Share the event details with your team and complete\n'
                'the checklist before your fund raise.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 11.0 : 11.sp,
                  color: const Color(0xff525252),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 26.h),
              _DetailsRow(
                label: 'EVENT CODE',
                value: eventCode,
                trailing: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 13.h),

              _DashedDivider(color: const Color.fromARGB(172, 0, 0, 0)),
              SizedBox(height: 13.h),

              Row(
                children: [
                  Expanded(
                    child: _InfoMini(
                      title: 'START DATE',
                      value: displayStartDate,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _InfoMini(
                      title: 'START TIME',
                      value: displayStartTime,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _InfoMini(title: 'END DATE', value: displayEndDate),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _InfoMini(title: 'END TIME', value: displayEndTime),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showChecklistSheet();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/checklist.png',
                        width: 16.sp,
                        height: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'View checklist',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 16.0 : 16.sp,
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
      },
    );
  }

  void _showChecklistSheet() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final List participants = eventData?['participants'] as List? ?? [];
    final bool isTeamInvited = participants.length > 1;

    final String? payoutNumber =
        eventData?['payout_manager']?.toString() ??
        widget.controller.createdEvent['payout_manager']?.toString();
    final bool hasPayoutNumber =
        payoutNumber != null &&
        payoutNumber.trim().isNotEmpty &&
        payoutNumber != 'null';

    final String? shopName = widget.controller.fundraiserDetails['name']
        ?.toString();
    final bool hasShop =
        shopName != null && shopName.trim().isNotEmpty && shopName != 'null';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 12.h,
            bottom: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Hi, $_organizerName',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16.0 : 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Lets get your event set up for success.',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12.0 : 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 18.h),
              _ChecklistRow(text: 'Fundraiser event created', checked: true),
              SizedBox(height: 12.h),
              _ChecklistRow(
                text: 'Invite your team to fundraise',
                checked: isTeamInvited,
                showArrow: true,
                onTap: () {
                  Navigator.pop(context);
                  _showInviteTeamSheet();
                },
              ),
              SizedBox(height: 12.h),
              _ChecklistRow(
                text: 'Add your payment  method',
                checked: hasPayoutNumber,
                showArrow: true,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const VerificationRequiredScreen());
                },
              ),
              SizedBox(height: 12.h),
              _ChecklistRow(
                text: 'Create Organizer Pop-Up Store',
                checked: hasShop,
                showArrow: true,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const CreatePopUpStoreScreen());
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  void _showInviteTeamSheet() {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;

    final code =
        eventData?['code'] ?? widget.controller.createdEvent['code'] ?? '';

    DateTime? startDateTime;
    DateTime? endDateTime;
    if (eventData?['start_date'] != null) {
      startDateTime = DateTime.tryParse(
        eventData!['start_date'].toString(),
      )?.toLocal();
    }
    if (eventData?['end_date'] != null) {
      endDateTime = DateTime.tryParse(
        eventData!['end_date'].toString(),
      )?.toLocal();
    }

    final String startD = startDateTime != null
        ? DateFormat('MM/dd/yy').format(startDateTime)
        : '___/___/26';
    final String startT = startDateTime != null
        ? DateFormat('h:mm a').format(startDateTime).toLowerCase()
        : '9:00 am';
    final String endD = endDateTime != null
        ? DateFormat('MM/dd/yy').format(endDateTime)
        : '___/___/26';
    final String endT = endDateTime != null
        ? DateFormat('h:mm a').format(endDateTime).toLowerCase()
        : '9:00 am';

    final String inviteLink =
        'https://treatsislandcandy.store/join-event?je=$code';

    final String shareText =
        'Hello Team - I set up a virtual fundraiser with Treats Island Candy! It is 100% contactless. We get to keep 50% of total profit and Treat Island Candy will ship the product directly to our buyers. Each of us will create a Pop-Up Store selling this specialized candy! The prices range from \$15 to \$25 per container and you won\'t find these premium products in general stores. Our fundraising window begins on $startD at $startT and goes until $endD, at $endT. Before the fundraiser begins:\n\n'
        'Click on the link $inviteLink to JOIN THE EVENT\n\n'
        'Confirm the Event Code $code.   Download the APP.\n\n'
        'Create your personalized Pop-Up Store';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                    Text(
                      'Invite your team',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 16.0 : 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'INSTRUCTION FOR YOUR TEAM',
                  style: GoogleFonts.antonSc(
                    fontSize: isTablet ? 18.0 : 18.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 220.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFEAEAEE)),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      shareText,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      final box = context.findRenderObject() as RenderBox?;
                      Share.share(
                        shareText,
                        sharePositionOrigin: box != null
                            ? (box.localToGlobal(Offset.zero) & box.size)
                            : null,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Invite your team',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 14.0 : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                          shareText,
                          sharePositionOrigin: box != null
                              ? (box.localToGlobal(Offset.zero) & box.size)
                              : null,
                        );
                      },
                      child: Image.asset(
                        'assets/icons/logos_facebook.png',
                        width: 26.sp,
                        height: 26.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                          shareText,
                          sharePositionOrigin: box != null
                              ? (box.localToGlobal(Offset.zero) & box.size)
                              : null,
                        );
                      },
                      child: Image.asset(
                        'assets/icons/logos_messenger.png',
                        width: 26.sp,
                        height: 26.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                          shareText,
                          sharePositionOrigin: box != null
                              ? (box.localToGlobal(Offset.zero) & box.size)
                              : null,
                        );
                      },
                      child: Image.asset(
                        'assets/icons/logos_whatsapp-icon.png',
                        width: 26.sp,
                        height: 26.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        Share.share(
                          shareText,
                          sharePositionOrigin: box != null
                              ? (box.localToGlobal(Offset.zero) & box.size)
                              : null,
                        );
                      },
                      child: Image.asset(
                        'assets/icons/boxicons_message-detail-filled.png',
                        width: 26.sp,
                        height: 26.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _getFundraiserDetails() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('GET FUNDRAISER: No access token found');
      return null;
    }

    Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    int? eventId =
        eventData?['id'] as int? ??
        widget.controller.createdEvent['id'] as int?;
    if (eventId == null) {
      debugPrint(
        'GET FUNDRAISER: Event ID is null initially. Fetching my events...',
      );
      await widget.controller.fetchMyEvents();
      eventData =
          widget.controller.createdEvent['event'] as Map<String, dynamic>?;
      eventId =
          eventData?['id'] as int? ??
          widget.controller.createdEvent['id'] as int?;
    }

    if (eventId == null) {
      debugPrint('GET FUNDRAISER: Event ID is null after fetching my events');
      return null;
    }

    debugPrint('=== GET FUNDRAISER API REQUEST ===');
    debugPrint('Event ID: $eventId');
    debugPrint(
      'URL: https://api.treatsislandgo.com/event/$eventId/my-fundraiser/',
    );
    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getFundraiser(token, eventId);

      debugPrint('=== GET FUNDRAISER API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Request URL: ${response.request?.url}');
      debugPrint('Response Body: ${response.body}');

      if (response.status.isOk &&
          response.body != null &&
          response.body is Map) {
        final Map<String, dynamic> result = Map<String, dynamic>.from(
          response.body,
        );
        widget.controller.fundraiserDetails.value = result;
        return result;
      }
    } catch (e) {
      debugPrint('=== GET FUNDRAISER API EXCEPTION ===');
      debugPrint('Exception: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: isTablet
                ? const EdgeInsets.fromLTRB(32.0, 56.0, 32.0, 18.0)
                : EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 18.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E2FF),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(isTablet ? 26.0 : 26.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.offAll(MainNavigationScreen()),
                      icon: const Icon(Icons.close),
                    ),
                    Expanded(
                      child: Center(
                        child: Obx(() {
                          final Map<String, dynamic>? eventData =
                              widget.controller.createdEvent['event']
                                  as Map<String, dynamic>?;
                          final String status =
                              eventData?['status']?.toString() ?? '';
                          final bool isOngoing =
                              status.toLowerCase() == 'ongoing';

                          if (isOngoing) {
                            final parsedStart = eventData?['start_date'] != null
                                ? DateTime.tryParse(
                                    eventData!['start_date'].toString(),
                                  )
                                : null;
                            final durationDays = eventData?['duration'] != null
                                ? (int.tryParse(
                                        eventData!['duration'].toString(),
                                      ) ??
                                      5)
                                : 5;
                            return _EventCountdownWidget(
                              startDate: parsedStart ?? DateTime.now(),
                              durationDays: parsedStart != null
                                  ? durationDays
                                  : 0,
                            );
                          }

                          return Text(
                            _isShopSelected ? 'Shop' : 'Event',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18.0 : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          );
                        }),
                      ),
                    ),
                    Obx(() {
                      final Map<String, dynamic>? eventData =
                          widget.controller.createdEvent['event']
                              as Map<String, dynamic>?;
                      final String status =
                          eventData?['status']?.toString() ?? '';
                      final bool isUpcoming =
                          status.toLowerCase() == 'upcoming';
                      final bool isOngoing = status.toLowerCase() == 'ongoing';

                      return Theme(
                        data: Theme.of(context).copyWith(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Color(0xFF1A1A2E),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          color: Colors.white,
                          elevation: 4,
                          offset: const Offset(0, 40),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _showEditEventSheet();
                            } else if (value == 'start') {
                              final eventData =
                                  widget.controller.createdEvent['event']
                                      as Map<String, dynamic>?;
                              final int? eventId =
                                  eventData?['id'] as int? ??
                                  widget.controller.createdEvent['id'] as int?;
                              if (eventId != null) {
                                final nowUtcStr = DateTime.now()
                                    .toUtc()
                                    .toIso8601String()
                                    .replaceAll(RegExp(r'\.\d+'), '');
                                final success = await widget.controller
                                    .updateEvent(
                                      eventId: eventId,
                                      startDateIso: nowUtcStr,
                                    );
                                if (success) {
                                  // Refresh full screen
                                  await widget.controller.fetchMyEvents();
                                  setState(() {});
                                }
                              }
                            } else if (value == 'extend') {
                              final eventData =
                                  widget.controller.createdEvent['event']
                                      as Map<String, dynamic>?;
                              final int? eventId =
                                  eventData?['id'] as int? ??
                                  widget.controller.createdEvent['id'] as int?;
                              if (eventId != null) {
                                final success = await widget.controller
                                    .extendEvent(eventId: eventId);
                                if (success) {
                                  await widget.controller.fetchMyEvents();
                                  setState(() {});
                                }
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  enabled: !isOngoing,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: isOngoing
                                            ? Colors.grey
                                            : const Color(0xFFFE53A1),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          'Edit Event',
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: isOngoing
                                                ? Colors.grey
                                                : const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'start',
                                  enabled: !isOngoing,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.flash_on,
                                        color: isOngoing
                                            ? Colors.grey
                                            : const Color(0xFFFE53A1),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          'Start Event Now',
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: isOngoing
                                                ? Colors.grey
                                                : const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'extend',
                                  enabled: !isUpcoming,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add_circle,
                                        color: isUpcoming
                                            ? Colors.grey
                                            : const Color(0xFFFE53A1),
                                        size: 18.sp,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          'Extend 3 Days More',
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: isUpcoming
                                                ? Colors.grey
                                                : const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final Map<String, dynamic>? eventData =
                            widget.controller.createdEvent['event']
                                as Map<String, dynamic>?;

                        DateTime? startDateTime;
                        DateTime? endDateTime;
                        if (eventData?['start_date'] != null) {
                          startDateTime = DateTime.tryParse(
                            eventData!['start_date'].toString(),
                          )?.toLocal();
                        }
                        if (eventData?['end_date'] != null) {
                          endDateTime = DateTime.tryParse(
                            eventData!['end_date'].toString(),
                          )?.toLocal();
                        }

                        final String dynamicTeamName =
                            eventData?['name']?.toString() ?? 'No Name added';
                        final String dateRangeStr =
                            (startDateTime != null && endDateTime != null)
                            ? '${DateFormat('MMM d').format(startDateTime)} - ${DateFormat('MMM d').format(endDateTime)}'
                            : 'No Date Added';

                        final creatorMap =
                            eventData?['creator'] as Map<String, dynamic>?;
                        final String creatorName =
                            creatorMap?['full_name']?.toString() ?? '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              creatorName.isNotEmpty
                                  ? '$creatorName  '
                                  : 'Organizer',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 12.0 : 12.sp,
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(height: isTablet ? 2.0 : 2.h),
                            Row(
                              children: [
                                Text(
                                  dynamicTeamName,
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 16.0 : 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 2.0 : 2.h),
                            Text(
                              dateRangeStr,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 12.0 : 12.sp,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    InkWell(
                      onTap: _showChecklistSheet,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 18.0 : 18.r,
                      ),
                      child: CircleAvatar(
                        radius: isTablet ? 18.0 : 18.r,
                        backgroundColor: Colors.black,
                        child: Stack(
                          children: [
                            Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/icons/checklist.png',
                                ),
                                width: isTablet ? 20.0 : 20.w,
                                height: isTablet ? 20.0 : 20.w,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: isTablet ? 10.0 : 10.w,
                                height: isTablet ? 10.0 : 10.w,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 16.0 : 16.h),
                Container(
                  padding: EdgeInsets.all(10.w),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isShopSelected = false;
                            });
                          },
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: _isShopSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 24.0 : 24.r,
                              ),
                              border: Border.all(
                                color: _isShopSelected
                                    ? Colors.black12
                                    : Colors.transparent,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: isTablet ? 14.0 : 14.sp,
                                    color: _isShopSelected
                                        ? Colors.black45
                                        : Colors.white,
                                  ),
                                  SizedBox(width: isTablet ? 6.0 : 6.w),
                                  Text(
                                    'Event',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 13.0 : 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _isShopSelected
                                          ? Colors.black45
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 8.0 : 8.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isShopSelected = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(
                            isTablet ? 24.0 : 24.r,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 12.0 : 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: _isShopSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(
                                isTablet ? 24.0 : 24.r,
                              ),
                              border: Border.all(
                                color: _isShopSelected
                                    ? Colors.transparent
                                    : Colors.black12,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.storefront_outlined,
                                    size: isTablet ? 14.0 : 14.sp,
                                    color: _isShopSelected
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                  SizedBox(width: isTablet ? 6.0 : 6.w),
                                  Obx(() {
                                    final String? shopName = widget
                                        .controller
                                        .fundraiserDetails['name']
                                        ?.toString();
                                    final bool hasName =
                                        shopName != null &&
                                        shopName.trim().isNotEmpty &&
                                        shopName != 'null';
                                    return Text(
                                      hasName
                                          ? 'Pop-UP Store'
                                          : 'Create Pop-UP Store',
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 13.0 : 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: _isShopSelected
                                            ? Colors.white
                                            : Colors.black45,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0)
                  : EdgeInsets.all(20.w),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650.0),
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _getFundraiserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final fundraiser = snapshot.data;
                      final String? name = fundraiser?['name']?.toString();
                      final bool hasName =
                          name != null &&
                          name.trim().isNotEmpty &&
                          name != 'null';

                      if (_isShopSelected) {
                        return Column(
                          children: hasName
                              ? _buildShopCreatedChildren(fundraiser)
                              : _buildShopChildren(),
                        );
                      } else {
                        return Column(children: _buildEventChildren(hasName));
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final String? badge;

  const _Card({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 600;
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: isTablet ? 10.0 : 10.r,
            offset: Offset(0, isTablet ? 4.0 : 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 15.0 : 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: isTablet ? 4.0 : 4.h),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 12.0 : 12.sp,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
              if (badge != null)
                _SmallPill(text: badge!)
              else if (trailing != null)
                trailing!,
            ],
          ),
          SizedBox(height: isTablet ? 12.0 : 12.h),
          child,
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  final String text;

  const _SmallPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 10.0 : 10.w,
        vertical: isTablet ? 4.0 : 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: isTablet ? 10.0 : 10.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class _InfoMini extends StatelessWidget {
  final String title;
  final String value;

  const _InfoMini({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 10.0 : 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: isTablet ? 4.0 : 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 12.0 : 12.sp,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _InfoMinidate extends StatelessWidget {
  final String title;
  final String value;

  const _InfoMinidate({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 10.0 : 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: isTablet ? 4.0 : 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 12.0 : 12.sp,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const _DetailsRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 10.0 : 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: isTablet ? 6.0 : 6.h),
        Row(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 14.0 : 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(width: isTablet ? 6.0 : 6.w),
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final String text;
  final bool checked;
  final bool showArrow;
  final VoidCallback? onTap;

  const _ChecklistRow({
    required this.text,
    required this.checked,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return GestureDetector(
      onTap: checked ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: isTablet ? 18.0 : 18.sp,
            height: isTablet ? 18.0 : 18.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: checked ? const Color(0xFF17C16F) : Colors.black26,
                width: 1.5,
              ),
              color: checked ? const Color(0xFFE9FBF2) : Colors.transparent,
            ),
            child: checked
                ? Icon(
                    Icons.check,
                    size: isTablet ? 12.0 : 12.sp,
                    color: const Color(0xFF17C16F),
                  )
                : null,
          ),
          SizedBox(width: isTablet ? 10.0 : 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 12.0 : 12.sp,
                color: Colors.black54,
              ),
            ),
          ),
          if (showArrow && !checked)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: isTablet ? 14.0 : 14.sp,
              color: Colors.black26,
            ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double thickness;

  const _DashedDivider({
    required this.color,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxWidth / (dashWidth + dashGap))
              .floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                child: Divider(
                  color: color,
                  thickness: thickness,
                  height: thickness,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _downloading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final String urlStr = widget.videoUrl;
    debugPrint('=== VideoPlayerScreen _initVideo: urlStr = $urlStr ===');
    if (urlStr.startsWith('http')) {
      setState(() {
        _downloading = true;
      });
      try {
        final tempDir = Directory.systemTemp;
        final String filename = 'video_${urlStr.hashCode}.mp4';
        final localFile = File('${tempDir.path}/$filename');

        if (!localFile.existsSync()) {
          final client = HttpClient();
          client.connectionTimeout = const Duration(seconds: 15);
          final request = await client.getUrl(Uri.parse(urlStr));
          final response = await request.close();
          if (response.statusCode == 200) {
            final IOSink sink = localFile.openWrite();
            await response.pipe(sink);
            await sink.close();
          } else {
            throw Exception(
              'Server returned status code ${response.statusCode}',
            );
          }
        }
        _controller = VideoPlayerController.file(localFile);
      } catch (e) {
        if (mounted) {
          setState(() {
            _downloading = false;
            _errorMessage = 'Failed to load video: $e';
          });
        }
        return;
      }
    } else {
      _controller = VideoPlayerController.file(File(urlStr));
    }

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _initialized = true;
          _downloading = false;
        });
        _controller!.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _errorMessage = 'Failed to initialize player: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _downloading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFFFF6FB6)),
                      SizedBox(height: 16.h),
                      Text(
                        'Buffering video...',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: isTablet ? 14.0 : 14.sp,
                        ),
                      ),
                    ],
                  )
                : _errorMessage != null
                ? Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontSize: isTablet ? 14.0 : 14.sp,
                      ),
                    ),
                  )
                : _initialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          if (_initialized &&
              _controller != null &&
              _errorMessage == null &&
              !_downloading)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 30.r,
                  child: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventCountdownWidget extends StatefulWidget {
  final DateTime startDate;
  final int durationDays;

  const _EventCountdownWidget({
    required this.startDate,
    required this.durationDays,
  });

  @override
  State<_EventCountdownWidget> createState() => _EventCountdownWidgetState();
}

class _EventCountdownWidgetState extends State<_EventCountdownWidget> {
  Timer? _timer;
  late DateTime _endDate;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _endDate = widget.startDate.add(Duration(days: widget.durationDays));
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  @override
  void didUpdateWidget(covariant _EventCountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.durationDays != widget.durationDays) {
      _endDate = widget.startDate.add(Duration(days: widget.durationDays));
      _updateCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final diff = _endDate.difference(now);
    if (mounted) {
      setState(() {
        if (diff.isNegative) {
          _days = 0;
          _hours = 0;
          _minutes = 0;
          _seconds = 0;
        } else {
          _days = diff.inDays;
          _hours = diff.inHours % 24;
          _minutes = diff.inMinutes % 60;
          _seconds = diff.inSeconds % 60;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF00C566), // Vibrant green
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 16.sp, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              'Live Event ${_days}D ${_hours}h ${_minutes}m ${_seconds}s',
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 13.0 : 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
