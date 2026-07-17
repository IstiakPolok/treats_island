import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../controller/schedule_event_controller.dart';

class LaurelWreathPainter extends CustomPainter {
  final Color color;
  LaurelWreathPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5.w
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;

    // Draw left arc branch
    final leftPath = Path();
    leftPath.addArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2.3, // starting angle
      1.7, // sweep angle
    );
    canvas.drawPath(leftPath, paint);

    // Draw right arc branch
    final rightPath = Path();
    rightPath.addArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -0.8, // starting angle
      1.7, // sweep angle
    );
    canvas.drawPath(rightPath, paint);

    // Draw leaf pairs along the arcs
    void drawLeaf(double x, double y, double angle) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, 0), width: 6.w, height: 3.h),
        leafPaint,
      );
      canvas.restore();
    }

    // Left branch leaves
    drawLeaf(cx - r * 0.9, cy + r * 0.3, -0.5);
    drawLeaf(cx - r * 0.98, cy - r * 0.1, 0.2);
    drawLeaf(cx - r * 0.85, cy - r * 0.5, 0.8);
    drawLeaf(cx - r * 0.6, cy - r * 0.8, 1.2);

    // Right branch leaves
    drawLeaf(cx + r * 0.9, cy + r * 0.3, 0.5);
    drawLeaf(cx + r * 0.98, cy - r * 0.1, -0.2);
    drawLeaf(cx + r * 0.85, cy - r * 0.5, -0.8);
    drawLeaf(cx + r * 0.6, cy - r * 0.8, -1.2);
  }

  @override
  bool shouldRepaint(covariant LaurelWreathPainter oldDelegate) =>
      oldDelegate.color != color;
}

class LeaderboardScreen extends StatelessWidget {
  final ScheduleEventController controller;

  const LeaderboardScreen({super.key, required this.controller});

  Widget _buildWreathRank(int rank) {
    final color = const Color(0xFFFFA800);
    return SizedBox(
      width: 38.w,
      height: 38.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(38.w, 38.w),
            painter: LaurelWreathPainter(color: color),
          ),
          Text(
            '$rank',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showShopDetailsSheet(
    BuildContext context, {
    required String name,
    required double amount,
    required String avatarUrl,
    int supporters = 10,
    double? goal,
  }) {
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
  }

  Widget _buildTopRankCard({
    required BuildContext context,
    required dynamic rank,
    required String name,
    required double amount,
    required String avatarUrl,
    int supporters = 0,
    double? goal,
  }) {
    return GestureDetector(
      onTap: () => _showShopDetailsSheet(
        context,
        name: name,
        amount: amount,
        avatarUrl: avatarUrl,
        supporters: supporters,
        goal: goal,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // Rank Indicator on Left
            SizedBox(
              width: 54.w,
              child: Center(
                child: rank is int
                    ? _buildWreathRank(rank)
                    : Text(
                        '$rank',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 4.w),
            // Capsule Container
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FB),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
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
                            '\$${amount.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Supporter Avatar
                    ClipOval(
                      child: Image.network(
                        avatarUrl,
                        width: 42.w,
                        height: 42.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 42.w,
                            height: 42.w,
                            color: const Color(0xFFE5E5E5),
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
                            width: 42.w,
                            height: 42.w,
                            color: const Color(0xFFE5E5E5),
                            child: Center(
                              child: SizedBox(
                                width: 14.w,
                                height: 14.w,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllStoreItem({
    required BuildContext context,
    required int rank,
    required String name,
    required int supporters,
    required double amount,
    required String avatarUrl,
    double? goal,
  }) {
    return GestureDetector(
      onTap: () => _showShopDetailsSheet(
        context,
        name: name,
        amount: amount,
        avatarUrl: avatarUrl,
        supporters: supporters,
        goal: goal,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // Rank Number
            SizedBox(
              width: 32.w,
              child: Text(
                '$rank',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Avatar
            ClipOval(
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
            // Name and Supporters
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
            // Amount
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SharedPreferencesHelper.getEmail(),
      builder: (context, userEmailSnapshot) {
        final localEmail = userEmailSnapshot.data ?? '';

        final Map<String, dynamic>? eventData =
            controller.createdEvent['event'] as Map<String, dynamic>?;
        final List participants = eventData?['participants'] as List? ?? [];

        // Sort participants by achieved amount descending
        final List sortedParticipants = List.from(participants);
        sortedParticipants.sort((a, b) {
          final double achievedA =
              double.tryParse(a['shop_achieved']?.toString() ?? '0') ?? 0.0;
          final double achievedB =
              double.tryParse(b['shop_achieved']?.toString() ?? '0') ?? 0.0;
          return achievedB.compareTo(achievedA);
        });

        // Extract ME info if present
        final meObj =
            sortedParticipants.firstWhereOrNull((e) {
              final pEmail = e['email']?.toString() ?? '';
              return pEmail.isNotEmpty &&
                  pEmail.toLowerCase() == localEmail.toLowerCase();
            }) ??
            sortedParticipants.firstWhereOrNull(
              (e) => e['is_mine'] == true || e['is_creator'] == true,
            );

        final int meRank = meObj != null
            ? sortedParticipants.indexOf(meObj) + 1
            : 1;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Custom Header Row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Leader Board',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.info_outline,
                          size: 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    children: [
                      if (sortedParticipants.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.h),
                          child: Center(
                            child: Text(
                              'No participants registered yet',
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        // Top 3 Leader Cards
                        if (sortedParticipants.isNotEmpty)
                          _buildTopRankCard(
                            context: context,
                            rank: 1,
                            name:
                                sortedParticipants[0]['full_name']
                                    ?.toString() ??
                                'Unnamed',
                            amount:
                                double.tryParse(
                                  sortedParticipants[0]['shop_achieved']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0.0,
                            avatarUrl: ApiService.formatImageUrl(
                              sortedParticipants[0]['image']?.toString(),
                            ),
                            supporters: int.tryParse(
                                  sortedParticipants[0]['total_supporters']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0,
                            goal: double.tryParse(
                              sortedParticipants[0]['shop_goal']?.toString() ??
                                  '0',
                            ),
                          ),
                        if (sortedParticipants.length > 1)
                          _buildTopRankCard(
                            context: context,
                            rank: 2,
                            name:
                                sortedParticipants[1]['full_name']
                                    ?.toString() ??
                                'Unnamed',
                            amount:
                                double.tryParse(
                                  sortedParticipants[1]['shop_achieved']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0.0,
                            avatarUrl: ApiService.formatImageUrl(
                              sortedParticipants[1]['image']?.toString(),
                            ),
                            supporters: int.tryParse(
                                  sortedParticipants[1]['total_supporters']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0,
                            goal: double.tryParse(
                              sortedParticipants[1]['shop_goal']?.toString() ??
                                  '0',
                            ),
                          ),
                        if (sortedParticipants.length > 2)
                          _buildTopRankCard(
                            context: context,
                            rank: 3,
                            name:
                                sortedParticipants[2]['full_name']
                                    ?.toString() ??
                                'Unnamed',
                            amount:
                                double.tryParse(
                                  sortedParticipants[2]['shop_achieved']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0.0,
                            avatarUrl: ApiService.formatImageUrl(
                              sortedParticipants[2]['image']?.toString(),
                            ),
                            supporters: int.tryParse(
                                  sortedParticipants[2]['total_supporters']
                                          ?.toString() ??
                                      '0',
                                ) ??
                                0,
                            goal: double.tryParse(
                              sortedParticipants[2]['shop_goal']?.toString() ??
                                  '0',
                            ),
                          ),

                        // Visual Break Dots
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCDCE0),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ME Card
                        _buildTopRankCard(
                          context: context,
                          rank: meObj != null ? meRank : 1,
                          name: meObj != null
                              ? (meObj['full_name']?.toString() ?? 'ME')
                              : 'ME',
                          amount: meObj != null
                              ? (double.tryParse(
                                      meObj['shop_achieved']?.toString() ?? '0',
                                    ) ??
                                    0.0)
                              : 0.0,
                          avatarUrl:
                              (meObj != null &&
                                      meObj['image'] != null &&
                                      meObj['image'].toString().isNotEmpty)
                                  ? ApiService.formatImageUrl(
                                      meObj['image'].toString(),
                                    )
                                  : 'https://i.pravatar.cc/150?img=33',
                          supporters: meObj != null
                              ? (int.tryParse(
                                      meObj['total_supporters']?.toString() ??
                                          '0',
                                    ) ??
                                    0)
                              : 0,
                          goal: meObj != null
                              ? double.tryParse(
                                  meObj['shop_goal']?.toString() ?? '0',
                                )
                              : 1200,
                        ),

                        SizedBox(height: 32.h),
                        // All Store List Header
                        Text(
                          'All store',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // All Store List (show all stores, including top 3)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sortedParticipants.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 20.h,
                            color: Colors.grey.shade100,
                            thickness: 1.h,
                          ),
                          itemBuilder: (context, index) {
                            final p =
                                sortedParticipants[index]
                                    as Map<String, dynamic>;
                            final String pName =
                                p['full_name']?.toString() ?? 'Unnamed';
                            final String img = p['image']?.toString() ?? '';
                            final String pAvatar = ApiService.formatImageUrl(img);
                            final double pAmount =
                                double.tryParse(
                                  p['shop_achieved']?.toString() ?? '0',
                                ) ??
                                0.0;
                            final double pGoal =
                                double.tryParse(
                                  p['shop_goal']?.toString() ?? '0',
                                ) ??
                                0.0;
                            final int pSupporters =
                                int.tryParse(
                                      p['total_supporters']?.toString() ?? '0',
                                    ) ??
                                0;
                            return _buildAllStoreItem(
                              context: context,
                              rank: index + 1,
                              name: pName,
                              supporters: pSupporters,
                              amount: pAmount,
                              avatarUrl: pAvatar,
                              goal: pGoal,
                            );
                          },
                        ),
                      ],
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
