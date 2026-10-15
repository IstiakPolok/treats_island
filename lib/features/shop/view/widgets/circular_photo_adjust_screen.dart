import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

/// Interactive circular image adjustment screen.
/// Allows zooming in/out, panning, rotating, and centering a photo
/// inside a circular aperture so it renders perfectly in circular avatars
/// such as [SharePopupStoreSheet].
class CircularPhotoAdjustScreen extends StatefulWidget {
  final File imageFile;
  final String shopName;

  const CircularPhotoAdjustScreen({
    super.key,
    required this.imageFile,
    this.shopName = 'My Pop-Up Store',
  });

  @override
  State<CircularPhotoAdjustScreen> createState() =>
      _CircularPhotoAdjustScreenState();
}

class _CircularPhotoAdjustScreenState extends State<CircularPhotoAdjustScreen> {
  final GlobalKey _repaintKey = GlobalKey();

  Offset _offset = Offset.zero;
  Offset _baseOffset = Offset.zero;
  Offset _focalPoint = Offset.zero;

  double _scale = 1.0;
  double _baseScale = 1.0;
  double _coverScale = 1.0;
  double _maxScale = 4.0;

  int _rotationQuarterTurns = 0;
  Color _selectedBgColor = Colors.white;

  bool _isSaving = false;

  final List<Color> _bgColorOptions = [
    Colors.white,
    const Color(0xFFFFEAF4),
    const Color(0xFF1A1A2E),
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    _loadImageDimensions();
  }

  Future<void> _loadImageDimensions() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      final decoded = await decodeImageFromList(bytes);
      if (!mounted) return;

      final double w = decoded.width.toDouble();
      final double h = decoded.height.toDouble();

      double cover = 1.0;
      if (w > 0 && h > 0) {
        if (w > h) {
          cover = w / h;
        } else {
          cover = h / w;
        }
      }

      setState(() {
        _coverScale = cover;
        _maxScale = math.max(4.0, cover * 2.5);
        _scale = cover; // Default to fill the circle
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _scale = 1.0;
        });
      }
    }
  }

  void _resetToCover() {
    setState(() {
      _scale = _coverScale;
      _offset = Offset.zero;
      _rotationQuarterTurns = 0;
    });
  }

  void _resetToShowAll() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
      _rotationQuarterTurns = 0;
    });
  }

  void _centerOnly() {
    setState(() {
      _offset = Offset.zero;
    });
  }

  void _rotateClockwise() {
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    });
  }

  Future<void> _saveAndReturnCropped() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      // Ensure the current frame has finished rendering
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Render boundary could not be initialized.');
      }

      // Render high resolution square (pixelRatio 3.0 gives ~900x900 from 300x300)
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Failed to encode image to PNG.');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final String croppedPath =
          '${tempDir.path}/cropped_store_photo_${DateTime.now().millisecondsSinceEpoch}.png';

      final File file = File(croppedPath);
      await file.writeAsBytes(pngBytes, flush: true);

      Get.back(result: croppedPath);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        Get.snackbar(
          'Adjustment Error',
          'Failed to save cropped image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.15),
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double cropSize = math.min(screenWidth - 48.0, isTablet ? 360.0 : 310.0);

    return Scaffold(
      backgroundColor: const Color(0xFF141424),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopBar(),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        'Pinch to zoom, drag to center your store photo',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.0 : 12.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Circular Crop Box Area
                      Center(
                        child: SizedBox(
                          width: cropSize,
                          height: cropSize,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // 1. RepaintBoundary containing the transformed photo
                              RepaintBoundary(
                                key: _repaintKey,
                                child: ClipRect(
                                  child: Container(
                                    width: cropSize,
                                    height: cropSize,
                                    color: _selectedBgColor,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..translateByDouble(
                                          _offset.dx,
                                          _offset.dy,
                                          0.0,
                                          1.0,
                                        )
                                        ..scaleByDouble(
                                          _scale,
                                          _scale,
                                          1.0,
                                          1.0,
                                        )
                                        ..rotateZ(
                                          _rotationQuarterTurns *
                                              (math.pi / 2),
                                        ),
                                      child: Center(
                                        child: Image.file(
                                          widget.imageFile,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // 2. Gesture detector on top to capture drag & pinch
                              Positioned.fill(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onScaleStart: (details) {
                                    _baseScale = _scale;
                                    _baseOffset = _offset;
                                    _focalPoint = details.localFocalPoint;
                                  },
                                  onScaleUpdate: (details) {
                                    setState(() {
                                      _scale = (_baseScale * details.scale)
                                          .clamp(0.25, _maxScale);
                                      _offset =
                                          _baseOffset +
                                          (details.localFocalPoint -
                                              _focalPoint);
                                    });
                                  },
                                ),
                              ),

                              // 3. Dark circular cutout overlay with guide lines & pink ring
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: CustomPaint(
                                    painter: _CircleOverlayPainter(
                                      borderColor: const Color(0xFFFF6FB6),
                                      borderWidth: 3.0,
                                      maskColor: const Color(
                                        0xFF141424,
                                      ).withValues(alpha: 0.82),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Quick Action Presets
                      _buildPresetActions(),

                      SizedBox(height: 14.h),

                      // Zoom Slider & Controls
                      _buildZoomSlider(),

                      SizedBox(height: 14.h),

                      // Background Color Selector (for zoomed out images)
                      _buildBgColorSelector(),

                      SizedBox(height: 18.h),

                      // Live "Share Sheet Preview" Card
                      _buildLiveShareSheetPreview(cropSize),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(result: null),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            tooltip: 'Cancel',
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adjust Store Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Circular Avatar Preview',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: const Color(0xFFFF6FB6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isSaving ? null : _saveAndReturnCropped,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6FB6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: _isSaving
                ? SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded, size: 16),
                      SizedBox(width: 4.w),
                      Text(
                        'Done',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetActions() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildActionChip(
          icon: Icons.fullscreen_rounded,
          label: 'Fill Circle',
          onTap: _resetToCover,
        ),
        _buildActionChip(
          icon: Icons.fit_screen_rounded,
          label: 'Fit Whole Image',
          onTap: _resetToShowAll,
        ),
        _buildActionChip(
          icon: Icons.filter_center_focus_rounded,
          label: 'Center',
          onTap: _centerOnly,
        ),
        _buildActionChip(
          icon: Icons.rotate_right_rounded,
          label: 'Rotate 90°',
          onTap: _rotateClockwise,
        ),
      ],
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF232338),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14.sp, color: const Color(0xFFFF6FB6)),
              SizedBox(width: 5.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomSlider() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.zoom_in_rounded,
                    size: 16.sp,
                    color: const Color(0xFFFF6FB6),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Zoom Level',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                '${(_scale * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6FB6),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = (_scale - 0.15).clamp(0.25, _maxScale);
                  });
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white70,
                ),
                iconSize: 20.sp,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFFF6FB6),
                    inactiveTrackColor: Colors.white12,
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 14,
                    ),
                  ),
                  child: Slider(
                    value: _scale.clamp(0.25, _maxScale),
                    min: 0.25,
                    max: _maxScale,
                    onChanged: (val) {
                      setState(() => _scale = val);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _scale = (_scale + 0.15).clamp(0.25, _maxScale);
                  });
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white70,
                ),
                iconSize: 20.sp,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBgColorSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Text(
            'Circle Background:',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const Spacer(),
          ..._bgColorOptions.map((c) {
            final bool isSelected = _selectedBgColor == c;
            return GestureDetector(
              onTap: () => setState(() => _selectedBgColor = c),
              child: Container(
                margin: EdgeInsets.only(left: 8.w),
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF6FB6)
                        : Colors.white24,
                    width: isSelected ? 2.5 : 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFFF6FB6).withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 14.sp,
                        color: c == Colors.white ? Colors.black : Colors.white,
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLiveShareSheetPreview(double cropSize) {
    const double miniAvatarSize = 58.0;
    final double scaleRatio = miniAvatarSize / cropSize;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFFF6FB6).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview_rounded,
                size: 16.sp,
                color: const Color(0xFFFF6FB6),
              ),
              SizedBox(width: 6.w),
              Text(
                'Live Store Sheet Preview',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6FB6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'REAL-TIME',
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFF6FB6),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Mini simulation of SharePopupStoreSheet header
          Container(
            height: 90.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: const Color(0xFF2A2A42),
            ),
            child: Stack(
              children: [
                // Top Cover Banner
                Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C2046), Color(0xFF482862)],
                    ),
                  ),
                ),
                // Overlapping Circular Avatar (Matching share_popup_store_sheet.dart exactly)
                Positioned(
                  left: 14.w,
                  top: 48.h - (miniAvatarSize / 2),
                  child: Container(
                    width: miniAvatarSize,
                    height: miniAvatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        color: _selectedBgColor,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translateByDouble(
                              _offset.dx * scaleRatio,
                              _offset.dy * scaleRatio,
                              0.0,
                              1.0,
                            )
                            ..scaleByDouble(_scale, _scale, 1.0, 1.0)
                            ..rotateZ(
                              _rotationQuarterTurns * (math.pi / 2),
                            ),
                          child: Center(
                            child: Image.file(
                              widget.imageFile,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Store Title next to avatar
                Positioned(
                  left: 14.w + miniAvatarSize + 10.w,
                  top: 52.h,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shopName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Pop-Up Store',
                        style: GoogleFonts.poppins(
                          fontSize: 9.5.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that darkens the outer area, draws subtle rule-of-thirds
/// guide lines inside the circle, and outlines the circle with brand color.
class _CircleOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color maskColor;

  _CircleOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.maskColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // 1. Semi-transparent mask covering corners outside circle
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    final Path maskPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      circlePath,
    );

    final Paint maskPaint = Paint()
      ..color = maskColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(maskPath, maskPaint);

    // 2. Subtle rule-of-thirds grid inside the circle to aid centering
    final Paint gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double oneThird = size.width / 3;
    final double twoThirds = size.width * 2 / 3;

    canvas.save();
    canvas.clipPath(circlePath);
    // Vertical grid lines
    canvas.drawLine(
      Offset(oneThird, 0),
      Offset(oneThird, size.height),
      gridPaint,
    );
    canvas.drawLine(
      Offset(twoThirds, 0),
      Offset(twoThirds, size.height),
      gridPaint,
    );
    // Horizontal grid lines
    canvas.drawLine(
      Offset(0, oneThird),
      Offset(size.width, oneThird),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, twoThirds),
      Offset(size.width, twoThirds),
      gridPaint,
    );
    canvas.restore();

    // 3. Circular border
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CircleOverlayPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.maskColor != maskColor;
  }
}
