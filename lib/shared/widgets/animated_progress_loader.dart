import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Reusable animated progress loader bar.
/// Accepts a [progress] value from 0.0 to 1.0.
class AnimatedProgressLoader extends StatelessWidget {
  const AnimatedProgressLoader({
    super.key,
    required this.progress,
    this.width = 180,
    this.height = 6,
    this.backgroundColor = AppColors.loaderTrack,
    this.foregroundColor = AppColors.loaderColor,
    this.borderRadius = 100,
  });

  final double progress;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: height,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      ),
    );
  }
}
