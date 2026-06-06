// import 'package:flutter/material.dart';

// /// Reusable app logo widget with a smooth fade + scale entrance animation.
// /// Pass [imagePath] from [AppAssets] — no hardcoded paths inside widgets.
// class AppLogoWidget extends StatefulWidget {
//   const AppLogoWidget({
//     super.key,
//     required this.imagePath,
//     this.size = 160,
//   });

//   final String imagePath;
//   final double size;

//   @override
//   State<AppLogoWidget> createState() => _AppLogoWidgetState();
// }

// class _AppLogoWidgetState extends State<AppLogoWidget>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _fadeAnim;
//   late final Animation<double> _scaleAnim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );

//     _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.7)),
//     );

//     _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
//       CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
//     );

//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _ctrl,
//       builder: (_, child) {
//         return FadeTransition(
//           opacity: _fadeAnim,
//           child: ScaleTransition(
//             scale: _scaleAnim,
//             child: child,
//           ),
//         );
//       },
//       child: Image.asset(
//         widget.imagePath,
//         width: widget.size,
//         height: widget.size,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) {
//           // Fallback placeholder while image hasn't been added yet.
//           return _buildPlaceholder();
//         },
//       ),
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       width: widget.size,
//       height: widget.size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         gradient: const RadialGradient(
//           colors: [Color(0xFFFF69B4), Color(0xFFE91E8C)],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFE91E8C).withValues(alpha: 0.35),
//             blurRadius: 30,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: const Center(
//         child: Text(
//           'TI',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 42,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }
