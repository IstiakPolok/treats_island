import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/api_service.dart';

class HomeEventStatusCard extends StatelessWidget {
  final Map<String, dynamic>? eventData;
  final bool started;
  final VoidCallback? onTap;

  const HomeEventStatusCard({
    super.key,
    this.eventData,
    required this.started,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    String dateLabel = '';
    IconData dateIcon = Icons.calendar_today_outlined;
    final String status = eventData?['status']?.toString().toLowerCase() ?? '';
    final bool isOngoing = status == 'ongoing';

    if (eventData != null && eventData!['end_date'] != null && isOngoing) {
      dateIcon = Icons.access_time_rounded;
      final endDate = DateTime.tryParse(eventData!['end_date'].toString());
      if (endDate != null) {
        final now = DateTime.now().toUtc();
        final diff = endDate.difference(now);
        if (diff.isNegative) {
          dateLabel = 'Live Event 0D 0h 0m 0s';
        } else {
          final days = diff.inDays;
          final hours = diff.inHours % 24;
          final minutes = diff.inMinutes % 60;
          final seconds = diff.inSeconds % 60;
          dateLabel = 'Live Event ${days}D ${hours}h ${minutes}m ${seconds}s';
        }
      }
    } else if (eventData != null && eventData!['start_date'] != null) {
      final parsedDate = DateTime.tryParse(eventData!['start_date'].toString());
      if (parsedDate != null) {
        final duration =
            int.tryParse(eventData!['duration']?.toString() ?? '0') ?? 0;
        dateLabel = started
            ? '$duration Day To Go'
            : 'Start At ${DateFormat('MMM d, yyyy').format(parsedDate.toLocal())}';
      }
    }

    final String eventName = eventData?['name']?.toString().toUpperCase() ?? '';
    final int estimatedParticipants =
        int.tryParse(eventData?['estimated_participants']?.toString() ?? '0') ??
        0;
    final List participants = eventData?['participants'] as List? ?? [];
    final String participantsText =
        '${participants.length}/$estimatedParticipants';

    final String? imgPath = eventData?['creator']?['image']?.toString();
    final String imageUrl =
        (imgPath != null && imgPath.isNotEmpty && imgPath != 'null')
        ? ApiService.formatImageUrl(imgPath)
        : 'https://cdn.vectorstock.com/i/500p/28/59/flat-style-male-avatar-person-icon-vector-59492859.jpg';

    final double coverHeight = isTablet ? 140.0 : 150.h;
    final double avatarSize = isTablet ? 76.0 : 76.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 18.0 : 18.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isTablet ? 18.0 : 18.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: coverHeight + (avatarSize / 1.5),
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ── Cover Image ──────────────────────────────────────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: coverHeight,
                      child: Image.asset(
                        'assets/images/popupstorebg.PNG',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // ── Gradient Overlay ─────────────────────────────────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: isTablet ? 50.0 : 50.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ── Status/Time Tag (Top Left) ───────────────────────────
                    Positioned(
                      left: isTablet ? 12.0 : 12.w,
                      top: isTablet ? 12.0 : 12.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10.0 : 10.w,
                          vertical: isTablet ? 4.0 : 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOngoing
                              ? const Color(0xFF00CD59)
                              : (started
                                    ? const Color(0xFF19B44C)
                                    : Colors.black.withValues(alpha: 0.45)),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16.0 : 16.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              dateIcon,
                              size: isTablet ? 12.0 : 11.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: isTablet ? 4.0 : 4.w),
                            Text(
                              dateLabel,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 10.0 : 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ── Participants Tag (Top Right) ─────────────────────────
                    Positioned(
                      right: isTablet ? 12.0 : 12.w,
                      top: isTablet ? 12.0 : 12.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 10.0 : 10.w,
                          vertical: isTablet ? 4.0 : 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(
                            isTablet ? 16.0 : 16.r,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group_outlined,
                              size: isTablet ? 13.0 : 12.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: isTablet ? 4.0 : 4.w),
                            Text(
                              participantsText,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 10.0 : 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ── Overlapping Profile Avatar ────────────────────────────
                    Positioned(
                      left: isTablet ? 16.0 : 16.w,
                      top: coverHeight - (avatarSize / 2),
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFFF6FB6),
                            width: isTablet ? 2.5 : 2.5.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: const Color(0xFFFFEAF4),
                                  child: Icon(
                                    Icons.person,
                                    color: const Color(0xFFFF6FB6),
                                    size: avatarSize * 0.5,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    // ── Text Content Right of Avatar ─────────────────────────
                    Positioned(
                      left:
                          (isTablet ? 16.0 : 16.w) +
                          avatarSize +
                          (isTablet ? 12.0 : 12.w),
                      top: coverHeight + (isTablet ? 4.0 : 4.h),
                      right: isTablet ? 16.0 : 16.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.antonSc(
                              fontSize: isTablet ? 16.0 : 18.sp,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: isTablet ? 2.0 : 2.h),
                          Text(
                            isOngoing
                                ? 'Ongoing Fundraiser Campaign'
                                : 'Upcoming Fundraiser Campaign',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 11.0 : 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: isTablet ? 2.0 : 2.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isTablet ? 12.0 : 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
