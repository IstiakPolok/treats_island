import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';
import '../../otp/view/event_code_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeStateData _homeState = const _HomeStateData();
  Timer? _startTimer;
  Timer? _timeTimer;
  String _userName = 'Jhon';
  String _currentDateString = '';
  String _currentTimeString = '';

  Map<String, dynamic>? _eventData;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
    _loadHomeState();
    _fetchProfileData();
    _fetchMyEvents();
  }

  Future<void> _fetchMyEvents() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('=== FETCH MY EVENTS: NO ACCESS TOKEN FOUND ===');
      return;
    }

    debugPrint('=== FETCH MY EVENTS START ===');
    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getMyEvents(token);

      debugPrint('=== FETCH MY EVENTS RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.status.isOk &&
          response.body != null &&
          response.body is List) {
        final List events = response.body;
        if (events.isNotEmpty) {
          final latestEvent = events.last;
          final isStarted = latestEvent['is_active'] == true;
          if (mounted) {
            setState(() {
              _eventData = Map<String, dynamic>.from(latestEvent);
              _homeState = _homeState.copyWith(
                eventCreated: true,
                started: isStarted,
              );
            });
          }
        }
      }
    } catch (e) {
      debugPrint('=== FETCH MY EVENTS EXCEPTION ===');
      debugPrint('Error: $e');
    }
  }

  Map<String, dynamic>? _getMyParticipant() {
    if (_eventData == null || _eventData!['participants'] == null) return null;
    final participants = _eventData!['participants'] as List;
    for (final p in participants) {
      if (p is Map && p['email'] == _userEmail) {
        return Map<String, dynamic>.from(p);
      }
    }
    if (participants.isNotEmpty && participants.first is Map) {
      return Map<String, dynamic>.from(participants.first);
    }
    return null;
  }

  String _getRemainingTime(String? endDateStr) {
    if (endDateStr == null) return '0 Day 0 Hours 0 Min';
    final endDate = DateTime.tryParse(endDateStr);
    if (endDate == null) return '0 Day 0 Hours 0 Min';
    final now = DateTime.now().toUtc();
    final difference = endDate.difference(now);
    if (difference.isNegative) return '0 Day 0 Hours 0 Min';
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    return '$days Day $hours Hours $minutes Min';
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _timeTimer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, MMMM d').format(now);
    final String formattedTime = DateFormat('h:mm:ss a').format(now);
    if (mounted) {
      setState(() {
        _currentDateString = formattedDate;
        _currentTimeString = formattedTime;
      });
    }
  }

  Future<void> _fetchProfileData() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null && token.isNotEmpty) {
      try {
        final apiService = Get.isRegistered<ApiService>()
            ? Get.find<ApiService>()
            : Get.put(ApiService());
        final response = await apiService.getProfile(token);
        if (response.status.isOk &&
            response.body != null &&
            response.body is Map) {
          final fullName = response.body['full_name']?.toString() ?? '';
          if (fullName.isNotEmpty) {
            await SharedPreferencesHelper.saveName(fullName);
            if (mounted) {
              setState(() {
                _userName = fullName;
              });
            }
          }
          final email = response.body['email']?.toString() ?? '';
          if (email.isNotEmpty) {
            await SharedPreferencesHelper.saveEmail(email);
            if (mounted) {
              setState(() {
                _userEmail = email;
              });
            }
          }
        }
      } catch (e) {
        // Handle gracefully/ignore background error
      }
    }
  }

  Future<void> _loadHomeState() async {
    final name = await SharedPreferencesHelper.getName();
    if (name.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userName = name;
        });
      }
    }
    final email = await SharedPreferencesHelper.getEmail();
    if (email.isNotEmpty) {
      if (mounted) {
        setState(() {
          _userEmail = email;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showCreated = _homeState.eventCreated || _homeState.shopCreated;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 650.0 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24.0 : 24.w,
                vertical: isTablet ? 16.0 : 16.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HELLO,',
                              style: GoogleFonts.antonSc(
                                fontSize: isTablet ? 38.0 : 48.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A2E),
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: isTablet ? 4.0 : 4.h),
                            Text(
                              _userName,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 24.0 : 32.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isTablet ? 12.0 : 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppAssets.splashLogo,
                            width: isTablet ? 48.0 : 48.w,
                            height: isTablet ? 48.0 : 48.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: isTablet ? 8.0 : 8.h),
                          Text(
                            _currentDateString,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: isTablet ? 2.0 : 2.h),
                          Text(
                            _currentTimeString,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 11.0 : 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24.0 : 24.h),
                  Text(
                    'MY EVENT',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 16.0 : 18.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF262626),
                    ),
                  ),
                  SizedBox(height: isTablet ? 10.0 : 10.h),
                  showCreated
                      ? _EventStatusCard(
                          eventData: _eventData,
                          started: _homeState.started,
                          onTap: () {
                            final controller =
                                Get.isRegistered<ScheduleEventController>()
                                ? Get.find<ScheduleEventController>()
                                : Get.put(ScheduleEventController());
                            Get.to(
                              () => EventOverviewScreen(
                                controller: controller,
                                showShopTab: _homeState.shopCreated,
                              ),
                            );
                          },
                        )
                      : _EventCard(
                          title: 'START A FUNDRAISER',
                          subtitle:
                              'Launch your fundraiser campaign in under 90 seconds',
                          assetPath: 'assets/images/unsplash_lhTF57zrDRs.png',
                          onTap: () => Get.toNamed(AppStrings.launchEventRoute),
                        ),
                  if (_eventData?['status']?.toString().toLowerCase() ==
                      'ongoing') ...[
                    SizedBox(height: isTablet ? 16.0 : 16.h),
                    Builder(
                      builder: (context) {
                        final remaining = _getRemainingTime(
                          _eventData?['end_date']?.toString(),
                        );
                        final participant = _getMyParticipant();
                        final name =
                            participant?['full_name']?.toString() ?? _userName;
                        final double goal =
                            double.tryParse(
                              participant?['shop_goal']?.toString() ?? '',
                            ) ??
                            0.0;
                        final double achieved =
                            double.tryParse(
                              participant?['shop_achieved']?.toString() ?? '',
                            ) ??
                            0.0;
                        return _FundraisingGoalCard(
                          remainingTime: remaining,
                          displayName: name,
                          goal: goal,
                          achieved: achieved,
                        );
                      },
                    ),
                  ],
                  if (!showCreated) ...[
                    SizedBox(height: isTablet ? 16.0 : 16.h),
                    _PinkActionCard(
                      title: 'ENTER EVENT CODE',
                      onTap: () => Get.to(() => const EventCodeScreen()),
                    ),
                  ],
                  SizedBox(height: isTablet ? 24.0 : 24.h),
                  Text(
                    'GET STARTED IN MINUTES',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12.0 : 12.h),
                  SizedBox(
                    height: isTablet ? 210.0 : 210.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        const _MiniVideoCard(
                          title: 'Launch Your\nPop-Up Store',
                          subtitle:
                              'Set up your personalized candy\nstorefront in just a few taps.',
                          duration: '1:23',
                          assetPath:
                              'assets/placeholder/homescreengetstarted1.png',
                        ),
                        SizedBox(width: isTablet ? 14.0 : 14.w),
                        const _MiniVideoCard(
                          title: 'Share Your Store',
                          subtitle:
                              'Send your unique fund link\nthrough text, email, or social.',
                          duration: '0:58',
                          assetPath:
                              'assets/placeholder/homescreengetstarted2.png',
                        ),
                        SizedBox(width: isTablet ? 14.0 : 14.w),
                        const _MiniVideoCard(
                          title: 'Share Your Store',
                          subtitle:
                              'Send your unique fund link\nthrough text, email, or social.',
                          duration: '0:58',
                          assetPath:
                              'assets/placeholder/homescreengetstarted3.png',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isTablet ? 40.0 : 70.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeStateData {
  final bool eventCreated;
  final bool shopCreated;
  final int createdAtMillis;
  final bool started;

  const _HomeStateData({
    this.eventCreated = false,
    this.shopCreated = false,
    this.createdAtMillis = 0,
    this.started = false,
  });

  _HomeStateData copyWith({
    bool? eventCreated,
    bool? shopCreated,
    int? createdAtMillis,
    bool? started,
  }) {
    return _HomeStateData(
      eventCreated: eventCreated ?? this.eventCreated,
      shopCreated: shopCreated ?? this.shopCreated,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      started: started ?? this.started,
    );
  }
}

class _EventStatusCard extends StatelessWidget {
  final Map<String, dynamic>? eventData;
  final bool started;
  final VoidCallback? onTap;

  const _EventStatusCard({this.eventData, required this.started, this.onTap});

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
                    // ── Gradient Overlay for cover tags readability ──────────
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 50.h,
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

class _EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final VoidCallback? onTap;

  const _EventCard({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 24.0 : 24.r),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 16.0 : 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.antonSc(
                  fontSize: isTablet ? 24.0 : 28.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: isTablet ? 6.0 : 6.h),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 13.0 : 14.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isTablet ? 18.0 : 18.h),
              _ArrowButton(
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinkActionCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _PinkActionCard({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isTablet ? 160.0 : 160.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6DDE8),
          borderRadius: BorderRadius.circular(isTablet ? 26.0 : 26.r),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/pinkeventcard.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20.0 : 20.w,
                vertical: isTablet ? 18.0 : 18.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.antonSc(
                      fontSize: isTablet ? 24.0 : 28.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  _ArrowButton(
                    backgroundColor: AppColors.primary,
                    iconColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniVideoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final String assetPath;

  const _MiniVideoCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isTablet ? 22.0 : 22.r),
      child: SizedBox(
        width: isTablet ? 210.0 : 210.w,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(assetPath, fit: BoxFit.cover)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              left: isTablet ? 12.0 : 12.w,
              top: isTablet ? 12.0 : 12.h,
              child: Container(
                width: isTablet ? 34.0 : 34.w,
                height: isTablet ? 34.0 : 34.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded),
              ),
            ),
            Positioned(
              right: isTablet ? 12.0 : 12.w,
              top: isTablet ? 12.0 : 12.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 8.0 : 8.w,
                  vertical: isTablet ? 4.0 : 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(isTablet ? 12.0 : 12.r),
                ),
                child: Text(
                  duration,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 11.0 : 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: isTablet ? 12.0 : 12.w,
              right: isTablet ? 12.0 : 12.w,
              bottom: isTablet ? 14.0 : 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 13.0 : 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: isTablet ? 6.0 : 6.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 10.0 : 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundraisingGoalCard extends StatelessWidget {
  final String remainingTime;
  final String displayName;
  final double goal;
  final double achieved;

  const _FundraisingGoalCard({
    required this.remainingTime,
    required this.displayName,
    required this.goal,
    required this.achieved,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final double factor = goal > 0 ? (achieved / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF6DDE8),
        borderRadius: BorderRadius.circular(isTablet ? 26.0 : 26.r),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(isTablet ? 26.0 : 26.r),
                bottomRight: Radius.circular(isTablet ? 26.0 : 26.r),
              ),
              child: Image.asset(
                'assets/images/eventpink.png',
                width: isTablet ? 110.0 : 110.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 20.0 : 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12.0 : 12.w,
                    vertical: isTablet ? 8.0 : 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8CBE1),
                    borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: isTablet ? 14.0 : 14.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                      SizedBox(width: isTablet ? 6.0 : 6.w),
                      Text(
                        remainingTime,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 24.0 : 24.h),
                Row(
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: isTablet ? 26.0 : 28.sp,
                      color: const Color(0xFF1A1A2E),
                    ),
                    SizedBox(width: isTablet ? 8.0 : 8.w),
                    Text(
                      displayName.toUpperCase(),
                      style: GoogleFonts.antonSc(
                        fontSize: isTablet ? 22.0 : 24.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 24.0 : 24.h),
                Text(
                  'Your Fundraising Goal',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 15.0 : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF262626).withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: isTablet ? 10.0 : 10.h),
                Stack(
                  children: [
                    Container(
                      height: isTablet ? 8.0 : 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isTablet ? 8.0 : 8.r,
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: factor,
                      child: Container(
                        height: isTablet ? 8.0 : 8.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 8.0 : 8.r,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 10.0 : 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${achieved.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 17.0 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '\$${goal.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 17.0 : 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const _ArrowButton({required this.backgroundColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Container(
      width: isTablet ? 40.0 : 40.w,
      height: isTablet ? 40.0 : 40.w,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Icon(
          Icons.arrow_outward_rounded,
          color: iconColor,
          size: isTablet ? 24.0 : 24.sp,
        ),
      ),
    );
  }
}
