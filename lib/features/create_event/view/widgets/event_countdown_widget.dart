import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCountdownWidget extends StatefulWidget {
  final DateTime startDate;
  final int durationDays;

  const EventCountdownWidget({
    super.key,
    required this.startDate,
    required this.durationDays,
  });

  @override
  State<EventCountdownWidget> createState() => _EventCountdownWidgetState();
}

class _EventCountdownWidgetState extends State<EventCountdownWidget> {
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
  void didUpdateWidget(covariant EventCountdownWidget oldWidget) {
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
