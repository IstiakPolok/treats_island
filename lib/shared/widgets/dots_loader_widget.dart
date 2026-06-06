import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Bouncing three-dots loader shown at the bottom of the splash screen.
/// Each dot animates with a staggered vertical bounce.
class DotsLoaderWidget extends StatefulWidget {
  const DotsLoaderWidget({
    super.key,
    this.dotColor = AppColors.loaderColor,
    this.dotCount = 3,
    this.dotSize = 9.0,
    this.spacing = 8.0,
  });

  final Color dotColor;
  final int dotCount;
  final double dotSize;
  final double spacing;

  @override
  State<DotsLoaderWidget> createState() => _DotsLoaderWidgetState();
}

class _DotsLoaderWidgetState extends State<DotsLoaderWidget>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.dotCount, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((ctrl) {
      return Tween<double>(begin: 0, end: -14).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
    }).toList();

    // Start each dot with a staggered delay.
    for (int i = 0; i < widget.dotCount; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (i) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: AnimatedBuilder(
            animation: _animations[i],
            builder: (context, _) {
              return Transform.translate(
                offset: Offset(0, _animations[i].value),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.dotColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
