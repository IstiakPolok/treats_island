import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class DateTimeScreen extends StatefulWidget {
  final DateTime initialDateTime;
  final int durationDays;

  const DateTimeScreen({
    super.key,
    required this.initialDateTime,
    required this.durationDays,
  });

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  late DateTime _selectedDateTime;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_selectedDateTime.isBefore(today)) {
      _selectedDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        widget.initialDateTime.hour,
        widget.initialDateTime.minute,
      );
    }
    _visibleMonth = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      1,
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  bool _isPrevMonthDisabled() {
    final now = DateTime.now();
    final minMonth = DateTime(now.year, now.month, 1);
    final prevMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
    return prevMonth.isBefore(minMonth);
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = _formatTime(_selectedDateTime);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500.0 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                    vertical: isTablet ? 10.0 : 10.h,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Date and time',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18.0 : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 40.0 : 40.w),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                  ),
                  child: Text(
                    '${widget.durationDays}-day fundraising\nwindow',
                    style: GoogleFonts.antonSc(
                      fontSize: isTablet ? 36.0 : 36.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.1,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 10.0 : 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                  ),
                  child: Text(
                    'Choose Your Start Date',
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 14.0 : 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 16.0 : 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 12.0 : 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 18.0 : 18.r,
                      ),
                      border: Border.all(color: const Color(0xFFE7E7EC)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatMonthYear(_visibleMonth),
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 14.0 : 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _isPrevMonthDisabled()
                                      ? null
                                      : () => _changeMonth(-1),
                                  icon: const Icon(Icons.chevron_left),
                                  color: _isPrevMonthDisabled()
                                      ? Colors.black26
                                      : const Color(0xFF1A1A2E),
                                  iconSize: isTablet ? 20.0 : 20.sp,
                                ),
                                IconButton(
                                  onPressed: () => _changeMonth(1),
                                  icon: const Icon(Icons.chevron_right),
                                  color: const Color(0xFF1A1A2E),
                                  iconSize: isTablet ? 20.0 : 20.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 6.0 : 6.h),
                        _buildCalendarGrid(isTablet),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 18.0 : 18.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 16.0 : 16.w,
                      vertical: isTablet ? 12.0 : 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 30.0 : 30.r,
                      ),
                      border: Border.all(color: const Color(0xFFE7E7EC)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start time',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 14.0 : 14.sp,
                            color: Colors.black38,
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 16.0 : 16.w,
                              vertical: isTablet ? 8.0 : 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F7),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 20.0 : 20.r,
                              ),
                            ),
                            child: Text(
                              timeLabel,
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
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                    vertical: isTablet ? 18.0 : 18.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56.0 : 56.h,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_selectedDateTime),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 30.0 : 30.r,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 16.0 : 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildCalendarGrid(bool isTablet) {
    final days = _daysForMonth(_visibleMonth);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: isTablet ? 6.0 : 6.h,
        crossAxisSpacing: 0,
        childAspectRatio: 1.2,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isCurrentMonth =
            day.month == _visibleMonth.month && day.year == _visibleMonth.year;
        final isSelected = _isSameDate(day, _selectedDateTime);
        final isInRange = _isInSelectedRange(day);
        final isPast = day.isBefore(today);

        final rangeColor = const Color(0xFFECECEF);
        final selectedColor = const Color(0xFFFF5AA5);

        final isRangeStart = isInRange && _isSameDate(day, _rangeStart);
        final isRangeEnd = isInRange && _isSameDate(day, _rangeEnd);

        BorderRadius? rangeRadius;
        if (isRangeStart || isRangeEnd) {
          rangeRadius = BorderRadius.horizontal(
            left: Radius.circular(isRangeStart ? (isTablet ? 14.0 : 14.r) : 0),
            right: Radius.circular(isRangeEnd ? (isTablet ? 14.0 : 14.r) : 0),
          );
        }

        return GestureDetector(
          onTap: isPast
              ? null
              : () {
                  _setSelectedDate(day);
                },
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isInRange)
                Container(
                  width: double.infinity,
                  height: isTablet ? 28.0 : 28.h,
                  decoration: BoxDecoration(
                    color: rangeColor,
                    borderRadius: rangeRadius,
                  ),
                ),
              if (isSelected)
                Container(
                  width: isTablet ? 30.0 : 30.w,
                  height: isTablet ? 30.0 : 30.w,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                '${day.day}',
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 14.0 : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isPast
                      ? Colors.black12
                      : isCurrentMonth
                      ? const Color(0xFF1A1A2E)
                      : Colors.black26,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<DateTime> _daysForMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingDays = firstDay.weekday - 1;
    final totalCells = leadingDays + daysInMonth;
    final trailingDays = (7 - (totalCells % 7)) % 7;

    final start = firstDay.subtract(Duration(days: leadingDays));
    final total = totalCells + trailingDays;

    return List.generate(total, (index) => start.add(Duration(days: index)));
  }

  void _setSelectedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isBefore(today)) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
      _visibleMonth = DateTime(date.year, date.month, 1);
    });
  }

  void _changeMonth(int delta) {
    final now = DateTime.now();
    final targetMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + delta,
      1,
    );
    final minMonth = DateTime(now.year, now.month, 1);
    if (targetMonth.isBefore(minMonth)) {
      return;
    }
    setState(() {
      _visibleMonth = targetMonth;
    });
  }

  DateTime get _rangeStart => DateTime(
    _selectedDateTime.year,
    _selectedDateTime.month,
    _selectedDateTime.day,
  );

  DateTime get _rangeEnd =>
      _rangeStart.add(Duration(days: widget.durationDays - 1));

  bool _isInSelectedRange(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return !day.isBefore(_rangeStart) && !day.isAfter(_rangeEnd);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
