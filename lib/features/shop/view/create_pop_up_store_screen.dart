import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';
import 'display_name_screen.dart';
import 'fundraising_goal_screen.dart';
import 'shop_created_success_screen.dart';
import 'store_note_screen.dart';
import 'widgets/circular_photo_adjust_screen.dart';
import '../../create_event/view/widgets/video_player_screen.dart';

class CreatePopUpStoreScreen extends StatelessWidget {
  const CreatePopUpStoreScreen({super.key});

  Future<void> _pickAndUploadMedia(
    BuildContext context, {
    required bool isVideo,
  }) async {
    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'Authentication required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    dynamic fundraiserId = controller.fundraiserDetails['id'];
    if (fundraiserId == null) {
      final currentEventId =
          controller.createdEvent['event']?['id'] ??
          controller.createdEvent['id'];
      if (currentEventId != null) {
        try {
          final apiService = Get.isRegistered<ApiService>()
              ? Get.find<ApiService>()
              : Get.put(ApiService());
          final res = await apiService.getFundraiser(
            token,
            int.parse(currentEventId.toString()),
          );
          if (res.status.isOk && res.body is Map) {
            controller.fundraiserDetails.assignAll(
              Map<String, dynamic>.from(res.body),
            );
            fundraiserId = controller.fundraiserDetails['id'];
          }
        } catch (_) {}
      }
    }

    if (fundraiserId == null) {
      Get.snackbar(
        'Error',
        'Fundraiser details not found.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!context.mounted) return;

    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    try {
      if (isVideo) {
        pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      } else {
        // Show option sheet: Choose from gallery or take photo
        final ImageSource? source = await showModalBottomSheet<ImageSource>(
          context: context,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          builder: (sheetContext) => SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Upload Store Photo',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'You will be able to zoom and center it in the circular preview',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEAF4),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.photo_library_rounded,
                        color: const Color(0xFFFF6FB6),
                        size: 22.sp,
                      ),
                    ),
                    title: Text(
                      'Choose from Gallery',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    onTap: () =>
                        Navigator.pop(sheetContext, ImageSource.gallery),
                  ),
                  // ListTile(

                  //     padding: EdgeInsets.all(8.w),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFFFEAF4),
                  //       borderRadius: BorderRadius.circular(10.r),
                  //     ),
                  //     child: Icon(
                  //       Icons.camera_alt_rounded,
                  //       color: const Color(0xFFFF6FB6),
                  //       size: 22.sp,
                  //     ),
                  //   ),
                  //   title: Text(
                  //     'Take a Photo',
                  //     style: GoogleFonts.poppins(
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w500,
                  //       color: const Color(0xFF1A1A2E),
                  //     ),
                  //   ),
                  //   onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
                  // ),
                ],
              ),
            ),
          ),
        );

        if (source == null) return;
        pickedFile = await picker.pickImage(source: source);
      }
    } catch (e) {
      debugPrint('Error picking media: $e');
      String errorMessage = 'Failed to pick media: $e';
      final String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('camera_access_denied') ||
          errorStr.contains('permission')) {
        errorMessage =
            'Camera access was denied. Please enable camera permissions in device Settings.';
      } else if (errorStr.contains('not available') ||
          errorStr.contains('no_available_camera')) {
        errorMessage =
            'Camera is not available on this device (e.g. simulator). Please choose from the gallery.';
      }
      Get.snackbar(
        'Camera Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.black,
      );
      return;
    }

    if (pickedFile == null) return;

    // If it's a photo, open the circular adjuster screen so the user can zoom in/out,
    // pan, rotate, and center it precisely for the circular share sheet & avatars.
    String uploadImagePath = pickedFile.path;
    if (!isVideo) {
      final String shopName =
          controller.fundraiserDetails['name']?.toString() ?? 'My Store';

      final String? adjustedPath = await Get.to<String?>(
        () => CircularPhotoAdjustScreen(
          imageFile: File(pickedFile!.path),
          shopName: shopName,
        ),
        transition: Transition.cupertino,
      );

      // If user cancelled or closed adjustment screen, do not proceed with upload
      if (adjustedPath == null) {
        return;
      }
      uploadImagePath = adjustedPath;
    }

    if (isVideo) {
      // Validate file format
      final String path = pickedFile.path.toLowerCase();
      final List<String> supportedExtensions = [
        '.mp4',
        '.mov',
        '.qt',
        '.m4v',
        '.3gp',
        '.avi',
        '.mkv',
        '.webm',
      ];
      final bool isSupported = supportedExtensions.any(
        (ext) => path.endsWith(ext),
      );
      if (!isSupported) {
        Get.snackbar(
          'Invalid Format',
          'Only MP4, MOV, M4V, AVI, 3GP, and MKV video formats are supported.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.black,
        );
        return;
      }

      // Validate file size (20MB limit)
      final file = File(pickedFile.path);
      final int fileSizeInBytes = await file.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 20) {
        Get.snackbar(
          'File Too Large',
          'The selected video is ${fileSizeInMB.toStringAsFixed(1)} MB. Maximum allowed size is 20 MB.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.black,
        );
        return;
      }

      // Validate video duration (15 seconds limit)
      try {
        final VideoPlayerController tempController = VideoPlayerController.file(
          file,
        );
        try {
          await tempController.initialize();
          final duration = tempController.value.duration;
          // Allow leeway for 15s clips (up to 15.99s)
          if (duration.inMilliseconds > 15999) {
            Get.snackbar(
              'Video Too Long',
              'The selected video is ${duration.inSeconds} seconds. Maximum allowed duration is 15 seconds.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withAlpha(26),
              colorText: Colors.black,
            );
            return;
          }
        } finally {
          await tempController.dispose().catchError((_) {});
        }
      } catch (e) {
        debugPrint(
          'Warning: Could not verify video duration locally via VideoPlayerController: $e',
        );
        // Do not abort if local player initialization failed (e.g. simulator codec limitation)
      }
    }

    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFFF6FB6)),
                SizedBox(height: 16),
                Text('Uploading media...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());

      final response = await apiService.updateFundraiserMedia(
        token: token,
        fundraiserId: int.parse(fundraiserId.toString()),
        imagePath: isVideo ? null : uploadImagePath,
        videoPath: isVideo ? pickedFile.path : null,
      );

      Get.back(); // Dismiss the loading dialog

      if (response.status.isOk && response.body != null) {
        if (response.body is Map) {
          final body = response.body as Map;
          if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
            controller.fundraiserDetails.value = Map<String, dynamic>.from(
              body['fundraiser'],
            );
          } else {
            controller.fundraiserDetails.addAll(
              Map<String, dynamic>.from(body),
            );
          }
          controller.fundraiserDetails.refresh();
          Get.snackbar(
            'Success',
            body['message']?.toString() ?? 'Media uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          controller.fundraiserDetails.refresh();
          Get.snackbar(
            'Success',
            'Media uploaded successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        String errorMsg = 'Failed to upload media';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.containsKey('video')) {
            final vError = bodyMap['video'];
            errorMsg = vError is List ? vError.join(', ') : vError.toString();
          } else if (bodyMap.containsKey('image')) {
            final iError = bodyMap['image'];
            errorMsg = iError is List ? iError.join(', ') : iError.toString();
          } else if (bodyMap.isNotEmpty) {
            final firstVal = bodyMap.values.first;
            errorMsg = firstVal is List
                ? firstVal.join(', ')
                : firstVal.toString();
          }
        } else if (response.statusText != null &&
            response.statusText!.isNotEmpty) {
          errorMsg = response.statusText!;
        } else if (response.statusCode != null) {
          errorMsg = 'Upload failed with status code ${response.statusCode}';
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.back(); // Dismiss the loading dialog
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showVideoOptions(BuildContext context, String videoUrl) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.h,
            horizontal: isTablet ? 30.0 : 20.w,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Store Video',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAF4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.play_circle_outline_rounded,
                    color: const Color(0xFFFF6FB6),
                    size: 22.sp,
                  ),
                ),
                title: Text(
                  'Watch Video',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Get.to(() => VideoPlayerScreen(videoUrl: videoUrl));
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAF4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.replay_rounded,
                    color: const Color(0xFFFF6FB6),
                    size: 22.sp,
                  ),
                ),
                title: Text(
                  'Change Video',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickAndUploadMedia(context, isVideo: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

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
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0)
                  : EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: Center(
                          child: Obx(() {
                            final String name =
                                controller.fundraiserDetails['name']
                                    ?.toString() ??
                                '';
                            return Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 16.0 : 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E),
                              ),
                            );
                          }),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Obx(() {
                    String? imageVal = controller.fundraiserDetails['image']
                        ?.toString();
                    if (imageVal != null && imageVal.startsWith('/')) {
                      imageVal = ApiService.defaultBaseUrl + imageVal;
                    }

                    String? videoVal = controller.fundraiserDetails['video']
                        ?.toString();
                    if (videoVal != null && videoVal.startsWith('/')) {
                      videoVal = ApiService.defaultBaseUrl + videoVal;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: _UploadCard(
                            title: 'Your Store Photo',
                            subtitle:
                                'Upload your skills or pitch\n'
                                'to your supporters.',
                            buttonText: 'Add Photo',
                            mediaUrl: imageVal,
                            isVideo: false,
                            onTap: () =>
                                _pickAndUploadMedia(context, isVideo: false),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _UploadCard(
                            title: 'Your Store Video',
                            subtitle:
                                'Upload your skills or pitch\n'
                                'to your supporters.',
                            buttonText: 'Add video',
                            mediaUrl: videoVal,
                            isVideo: true,
                            onTap: () {
                              if (videoVal != null && videoVal.isNotEmpty) {
                                _showVideoOptions(context, videoVal);
                              } else {
                                _pickAndUploadMedia(context, isVideo: true);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: 18.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Obx(() {
                          final String name =
                              controller.fundraiserDetails['name']
                                  ?.toString() ??
                              '';
                          return _InfoRow(
                            title: 'Pop-Up Store Name',
                            value: name,
                            onTap: () =>
                                Get.to(() => const DisplayNameScreen()),
                          );
                        }),
                        Divider(height: 20.h, color: const Color(0xFFEDEDF2)),
                        Obx(() {
                          final String desc =
                              controller.fundraiserDetails['description']
                                  ?.toString() ??
                              '';
                          return _InfoRow(
                            title: 'Fundraiser description',
                            value: desc,
                            onTap: () => Get.to(() => const StoreNoteScreen()),
                          );
                        }),
                        Divider(height: 20.h, color: const Color(0xFFEDEDF2)),
                        Obx(() {
                          final goalVal = controller.fundraiserDetails['goal'];
                          final double? parsedGoal = goalVal != null
                              ? double.tryParse(goalVal.toString())
                              : null;
                          final String goalText = parsedGoal != null
                              ? '\$${parsedGoal.toInt()}'
                              : '';
                          return _InfoRow(
                            title: 'Fundraising Goal',
                            value: goalText,
                            onTap: () =>
                                Get.to(() => const FundraisingGoalScreen()),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.off(
                          () => ShopCreatedSuccessScreen(
                            scheduleController: controller,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6FB6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 15.0 : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String? mediaUrl;
  final bool isVideo;
  final VoidCallback onTap;

  const _UploadCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.mediaUrl,
    required this.isVideo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFEDEDF2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: mediaUrl != null && mediaUrl!.isNotEmpty
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!isVideo)
                      Image.network(
                        mediaUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.black38,
                            ),
                          );
                        },
                      )
                    else
                      _VideoThumbnailWidget(videoUrl: mediaUrl!),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 12.w,
                      right: 12.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isVideo ? 'Your Video' : 'Your Photo',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 12.0 : 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isVideo
                                ? 'Tap to view or change'
                                : 'Tap to change or adjust photo',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 9.5 : 9.5.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isVideo
                              ? Icons.videocam_outlined
                              : Icons.image_outlined,
                          size: 28.sp,
                          color: Colors.black45,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 9.0 : 9.sp,
                            color: Colors.black45,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            buttonText,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 10.0 : 10.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  const _VideoThumbnailWidget({required this.videoUrl});

  @override
  State<_VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<_VideoThumbnailWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initThumbnail();
  }

  @override
  void didUpdateWidget(covariant _VideoThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _disposeController();
      _isInitialized = false;
      _hasError = false;
      _initThumbnail();
    }
  }

  bool _isDisposed = false;

  void _disposeController() {
    final c = _controller;
    _controller = null;
    c?.dispose().catchError((_) {});
  }

  Future<void> _initThumbnail() async {
    final String url = widget.videoUrl.trim();
    if (url.isEmpty) return;

    try {
      String cleanUrl = url;
      if (cleanUrl.startsWith('file://')) {
        cleanUrl = cleanUrl.replaceFirst('file://', '');
      }

      File localFile;
      if (cleanUrl.startsWith('http')) {
        final tempDir = Directory.systemTemp;
        final String filename = 'video_${cleanUrl.hashCode}.mp4';
        localFile = File('${tempDir.path}/$filename');

        if (!localFile.existsSync() || await localFile.length() == 0) {
          final client = HttpClient();
          client.connectionTimeout = const Duration(seconds: 15);
          final request = await client.getUrl(Uri.parse(cleanUrl));
          final response = await request.close();
          if (response.statusCode == 200) {
            final IOSink sink = localFile.openWrite();
            await response.pipe(sink);
            await sink.close();
          } else {
            throw Exception(
              'Server returned status code ${response.statusCode}',
            );
          }
        }
      } else {
        localFile = File(cleanUrl);
      }

      if (_isDisposed) return;
      if (!localFile.existsSync()) {
        throw Exception('Video file does not exist at ${localFile.path}');
      }

      final controller = VideoPlayerController.file(localFile);
      _controller = controller;
      await controller.initialize();
      if (!_isDisposed && mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading video thumbnail: $e');
      if (!_isDisposed && mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized && _controller != null) {
      final size = _controller!.value.size;
      return Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: size.width > 0 ? size.width : 160,
              height: size.height > 0 ? size.height : 160,
              child: VideoPlayer(_controller!),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                size: 32,
                color: Color(0xFFFF6FB6),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: _hasError
            ? const Icon(
                Icons.play_circle_fill,
                size: 48,
                color: Color(0xFFFF6FB6),
              )
            : const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6FB6)),
                ),
              ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 12.0 : 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 11.0 : 11.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18.sp, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
