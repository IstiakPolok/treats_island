import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

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
                              fontSize: 22.sp,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Your Virtual Pop-Up Store',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
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
    final String shareLink = fundraiser['share_link']?.toString() ?? '';
    final String shopName = fundraiser['name']?.toString() ?? 'My Shop';

    // Construct shop image URL
    var shopImageUrl = '';
    if (fundraiser['image'] != null &&
        fundraiser['image'].toString().isNotEmpty) {
      final img = fundraiser['image'].toString();
      shopImageUrl = img.startsWith('/')
          ? '${ApiService.defaultBaseUrl}$img'
          : img;
    }

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
            top: 24.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
          ),
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
              SizedBox(height: 20.h),
              Text(
                'Share Your Pop-Up Store',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 20.h),
              // Shop image & name card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FB),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFEAEAEE)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: shopImageUrl.isNotEmpty
                          ? Image.network(
                              shopImageUrl,
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    'assets/placeholder/homescreengetstarted1.png',
                                    width: 60.w,
                                    height: 60.w,
                                    fit: BoxFit.cover,
                                  ),
                            )
                          : Image.asset(
                              'assets/placeholder/homescreengetstarted1.png',
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shopName,
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Support my fundraising campaign!',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
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
                        shareLink.isNotEmpty ? shareLink : 'No link available',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: shareLink.isNotEmpty
                        ? () {
                            Clipboard.setData(ClipboardData(text: shareLink));
                            Get.snackbar(
                              'Copied',
                              'Link copied to clipboard!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black.withAlpha(26),
                              colorText: Colors.black,
                            );
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A2E),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(Icons.copy, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopActionRow(Map<String, dynamic>? fundraiser) {
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          achievedText,
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6FB6),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: fundraiser != null
                          ? () => _showShareBottomSheet(context, fundraiser)
                          : null,
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
                            fontSize: 14.sp,
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
                            fontSize: 13.sp,
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black45,
                            ),
                          ),
                          TextSpan(
                            text: goalText,
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
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
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                    ),
                    if (isOngoing)
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Text(
                          'Achieved',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
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
                        fontSize: 18.sp,
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
                            fontSize: 18.sp,
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6FB6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Share Link',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
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
        ? (imgPath.startsWith('/')
              ? ApiService.defaultBaseUrl + imgPath
              : imgPath)
        : 'https://cdn.vectorstock.com/i/500p/28/59/flat-style-male-avatar-person-icon-vector-59492859.jpg';

    final String? videoUrl =
        (vidPath != null && vidPath.isNotEmpty && vidPath != 'null')
        ? (vidPath.startsWith('/')
              ? ApiService.defaultBaseUrl + vidPath
              : vidPath)
        : null;

    return [
      GestureDetector(
        onTap: () {
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
                  fit: BoxFit.cover,
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
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 20.r,
                        child: Icon(
                          Icons.play_arrow,
                          size: 32.sp,
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
        onTap: () => Get.to(() => const StoreNoteScreen()),
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
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
                        fontSize: 15.sp,
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
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Total sale',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
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
                          fontSize: 12.sp,
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
                  fontSize: 15.sp,
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
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFF6FB6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (sortedParticipants.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'No participants yet',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
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
                final String avatarUrl = imageSubpath.startsWith('http')
                    ? imageSubpath
                    : '${ApiService.defaultBaseUrl}$imageSubpath';
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
                      fontSize: 16.sp,
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
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF6FB6),
                              ),
                            ),
                            TextSpan(
                              text: 'of ${finalGoal.toStringAsFixed(0)} goal',
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
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
                          fontSize: 13.sp,
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
                          fontSize: 16.sp,
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
                  fontSize: 13.sp,
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
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$supporters supporters',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
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
                        fontSize: 12.sp,
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
                  final String imageUrl =
                      (imageRelPath != null && imageRelPath.isNotEmpty)
                      ? (imageRelPath.startsWith('http')
                            ? imageRelPath
                            : '${ApiService.defaultBaseUrl}$imageRelPath')
                      : '';

                  return Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
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
                            fontSize: 14.sp,
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
                        fontSize: 12.sp,
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
      _Card(
        title: 'Payout Manger',
        badge: 'Secure & Simple',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify yourself and select how to receive\n'
              'the event earnings.',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
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
                        fontSize: 12.sp,
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
        ),
      ),
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
                  'ZVT AYF';

              return _DetailsRow(
                label: 'EVENT CODE',
                value: code.toString(),
                trailing: Icon(
                  Icons.copy_rounded,
                  size: 16.sp,
                  color: AppColors.primary,
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
                  width: 125.w,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: () {},
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
                        fontSize: 12.sp,
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
        onTap: () {},
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
                        fontSize: 18.sp,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter event name',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
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
                    fontSize: 13.sp,
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
                              fontSize: 13.sp,
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
                    fontSize: 13.sp,
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
                              fontSize: 14.sp,
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
                    fontSize: 13.sp,
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
                              fontSize: 14.sp,
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
                                fontSize: 15.sp,
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
                  fontSize: 20.sp,
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
                  fontSize: 11.sp,
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
                          fontSize: 16.sp,
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
    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final List participants = eventData?['participants'] as List? ?? [];
    final bool isTeamInvited = participants.length > 1;

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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Lets get your event set up for success.',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 18.h),
              _ChecklistRow(text: 'Create a fundraise event', checked: true),
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
                checked: false,
                showArrow: true,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const VerificationRequiredScreen());
                },
              ),
              SizedBox(height: 12.h),
              _ChecklistRow(
                text: 'Create your shop',
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

    final String dynamicTeamName =
        eventData?['name']?.toString() ?? 'Treats Island';
    final String startLabel = startDateTime != null
        ? DateFormat('MMM d').format(startDateTime)
        : 'May 8';
    final String endLabel = endDateTime != null
        ? DateFormat('MMM d').format(endDateTime)
        : 'May 12';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (context) {
        return SizedBox(
          height: 400.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 16.h,
              bottom: 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                        fontSize: 16.sp,
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
                    fontSize: 18.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Hi Team! Our $dynamicTeamName Fundraiser Starts $startLabel '
                  'And Ends $endLabel. We\'re Selling Delicious '
                  'Candy And Earning 50% Of Each Sale.\n\n'
                  'Visit Our Fundraising Page To Learn More How To '
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'https://www.Treats Island Fundraise.com/Design/',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: () {},
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
                        fontSize: 14.sp,
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
                    Image.asset(
                      'assets/icons/logos_facebook.png',
                      width: 26.sp,
                      height: 26.sp,
                    ),
                    Image.asset(
                      'assets/icons/logos_messenger.png',
                      width: 26.sp,
                      height: 26.sp,
                    ),
                    Image.asset(
                      'assets/icons/logos_whatsapp-icon.png',
                      width: 26.sp,
                      height: 26.sp,
                    ),
                    Image.asset(
                      'assets/icons/boxicons_message-detail-filled.png',
                      width: 26.sp,
                      height: 26.sp,
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
    if (token == null || token.isEmpty) return null;

    final Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    final int? eventId =
        eventData?['id'] as int? ??
        widget.controller.createdEvent['id'] as int?;
    if (eventId == null) return null;

    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getFundraiser(token, eventId);
      if (response.status.isOk &&
          response.body != null &&
          response.body is Map) {
        final Map<String, dynamic> result = Map<String, dynamic>.from(
          response.body,
        );
        widget.controller.fundraiserDetails.value = result;
        return result;
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 18.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E2FF),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26.r),
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
                    Obx(() {
                      final Map<String, dynamic>? eventData =
                          widget.controller.createdEvent['event']
                              as Map<String, dynamic>?;
                      final String status =
                          eventData?['status']?.toString() ?? '';
                      final bool isOngoing = status.toLowerCase() == 'ongoing';

                      if (isOngoing) {
                        // Calculate detailed countdown timer
                        int days = 0;
                        int hours = 0;
                        int minutes = 0;
                        int seconds = 0;
                        if (eventData?['start_date'] != null &&
                            eventData?['duration'] != null) {
                          final parsedStart = DateTime.tryParse(
                            eventData!['start_date'].toString(),
                          );
                          final durationDays =
                              int.tryParse(eventData['duration'].toString()) ??
                              5;
                          if (parsedStart != null) {
                            final end = parsedStart.add(
                              Duration(days: durationDays),
                            );
                            final now = DateTime.now();
                            final diff = end.difference(now);
                            if (!diff.isNegative) {
                              days = diff.inDays;
                              hours = diff.inHours % 24;
                              minutes = diff.inMinutes % 60;
                              seconds = diff.inSeconds % 60;
                            }
                          }
                        }

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C566), // Vibrant green
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Live Event ${days}D ${hours}h ${minutes}m ${seconds}s',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Text(
                        _isShopSelected ? 'Shop' : 'Event',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      );
                    }),
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
                                      Text(
                                        'Edit Event',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isOngoing
                                              ? Colors.grey
                                              : const Color(0xFF1A1A2E),
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
                                      Text(
                                        'Start Event Now',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isOngoing
                                              ? Colors.grey
                                              : const Color(0xFF1A1A2E),
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
                                      Text(
                                        'Extend 3 Days More',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: isUpcoming
                                              ? Colors.grey
                                              : const Color(0xFF1A1A2E),
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
                                fontSize: 12.sp,
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Text(
                                  dynamicTeamName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              dateRangeStr,
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    InkWell(
                      onTap: _showChecklistSheet,
                      borderRadius: BorderRadius.circular(18.r),
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.black,
                        child: Stack(
                          children: [
                            Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/icons/checklist.png',
                                ),
                                width: 20.w,
                                height: 20.w,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 10.w,
                                height: 10.w,
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
                SizedBox(height: 16.h),
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
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: _isShopSelected
                                    ? Colors.black12
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14.sp,
                                  color: _isShopSelected
                                      ? Colors.black45
                                      : Colors.white,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Event',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
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
                      SizedBox(width: 8.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isShopSelected = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: _isShopSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: _isShopSelected
                                    ? Colors.transparent
                                    : Colors.black12,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storefront_outlined,
                                  size: 14.sp,
                                  color: _isShopSelected
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Store',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _isShopSelected
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.all(20.w),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _getFundraiserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final fundraiser = snapshot.data;
                  final String? name = fundraiser?['name']?.toString();
                  final bool hasName =
                      name != null && name.trim().isNotEmpty && name != 'null';

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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
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
          SizedBox(height: 12.h),
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10.sp,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black38,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(width: 6.w),
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
    return GestureDetector(
      onTap: checked ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 18.sp,
            height: 18.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: checked ? const Color(0xFF17C16F) : Colors.black26,
                width: 1.5,
              ),
              color: checked ? const Color(0xFFE9FBF2) : Colors.transparent,
            ),
            child: checked
                ? Icon(Icons.check, size: 12.sp, color: const Color(0xFF17C16F))
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.black54,
              ),
            ),
          ),
          if (showArrow && !checked)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
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
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _initialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
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
          if (_initialized)
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  radius: 30.r,
                  child: Icon(
                    _controller.value.isPlaying
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
