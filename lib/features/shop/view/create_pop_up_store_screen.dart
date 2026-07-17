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
import '../../create_event/view/event_overview_screen.dart';
import 'display_name_screen.dart';
import 'fundraising_goal_screen.dart';
import 'store_note_screen.dart';

class CreatePopUpStoreScreen extends StatelessWidget {
  const CreatePopUpStoreScreen({super.key});

  Future<void> _pickAndUploadMedia(
    BuildContext context, {
    required bool isVideo,
  }) async {
    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final fundraiserId = controller.fundraiserDetails['id'];
    if (fundraiserId == null) {
      Get.snackbar(
        'Error',
        'Fundraiser details not found.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'Authentication required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    try {
      if (isVideo) {
        pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      } else {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick media: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pickedFile == null) return;

    if (isVideo) {
      // Validate file format
      final String path = pickedFile.path.toLowerCase();
      final List<String> supportedExtensions = [
        '.mp4',
        '.mov',
        '.3gp',
        '.avi',
        '.mkv',
      ];
      final bool isSupported = supportedExtensions.any(
        (ext) => path.endsWith(ext),
      );
      if (!isSupported) {
        Get.snackbar(
          'Invalid Format',
          'Only MP4, MOV, AVI, 3GP, and MKV video formats are supported.',
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
      final VideoPlayerController tempController = VideoPlayerController.file(
        file,
      );
      try {
        await tempController.initialize();
        final duration = tempController.value.duration;
        await tempController.dispose();
        if (duration.inSeconds > 15) {
          Get.snackbar(
            'Video Too Long',
            'The selected video is ${duration.inSeconds} seconds. Maximum allowed duration is 15 seconds.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withAlpha(26),
            colorText: Colors.black,
          );
          return;
        }
      } catch (e) {
        await tempController.dispose();
        Get.snackbar(
          'Validation Error',
          'Failed to validate video duration: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(26),
          colorText: Colors.black,
        );
        return;
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
        imagePath: isVideo ? null : pickedFile.path,
        videoPath: isVideo ? pickedFile.path : null,
      );

      Get.back(); // Dismiss the loading dialog

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map;
        if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
          controller.fundraiserDetails.value = Map<String, dynamic>.from(
            body['fundraiser'],
          );
        }
        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Media uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        String errorMsg = 'Failed to upload media';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
                            controller.fundraiserDetails['name']?.toString() ??
                            '';
                        return Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        );
                      }),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
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
                        onTap: () =>
                            _pickAndUploadMedia(context, isVideo: true),
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: 18.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                          controller.fundraiserDetails['name']?.toString() ??
                          '';
                      return _InfoRow(
                        title: 'Display Name',
                        value: name,
                        onTap: () => Get.to(() => const DisplayNameScreen()),
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
              SizedBox(height: 18.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms and Conditions *',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'By signing up, you agree to our\n'
                          'Terms and Conditions and Privacy Policy.',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: Colors.black54,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.off(
                      () => EventOverviewScreen(
                        controller: controller,
                        showShopTab: true,
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
                    'Create My Pop-Up Store',
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
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
                      Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 48,
                            color: Color(0xFFFF6FB6),
                          ),
                        ),
                      ),
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
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Tap to change',
                            style: GoogleFonts.poppins(
                              fontSize: 9.5.sp,
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
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
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
                              fontSize: 10.sp,
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

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  if (value.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
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
