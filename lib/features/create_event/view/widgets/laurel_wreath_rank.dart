import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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

class LaurelWreathRank extends StatelessWidget {
  final int rank;
  final Color color;

  const LaurelWreathRank({
    super.key,
    required this.rank,
    this.color = const Color(0xFFFFA800),
  });

  @override
  Widget build(BuildContext context) {
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
}
