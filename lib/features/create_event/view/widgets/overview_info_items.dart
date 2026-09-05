import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoMini extends StatelessWidget {
  final String title;
  final String value;

  const InfoMini({super.key, required this.title, required this.value});

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

class InfoMiniDate extends StatelessWidget {
  final String title;
  final String value;

  const InfoMiniDate({super.key, required this.title, required this.value});

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

class DetailsRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const DetailsRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

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
            ?trailing,
          ],
        ),
      ],
    );
  }
}

class ChecklistRow extends StatelessWidget {
  final String text;
  final bool checked;
  final bool showArrow;
  final VoidCallback? onTap;

  const ChecklistRow({
    super.key,
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

class DashedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double thickness;

  const DashedDivider({
    super.key,
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
          final dashCount =
              (constraints.maxWidth / (dashWidth + dashGap)).floor();
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
