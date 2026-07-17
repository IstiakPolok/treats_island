import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';

class StoreNoteScreen extends StatefulWidget {
  const StoreNoteScreen({super.key});

  @override
  State<StoreNoteScreen> createState() => _StoreNoteScreenState();
}

class _StoreNoteScreenState extends State<StoreNoteScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  final ApiService _apiService = Get.isRegistered<ApiService>()
      ? Get.find<ApiService>()
      : Get.put(ApiService());

  late final ScheduleEventController _eventController;

  @override
  void initState() {
    super.initState();
    _eventController = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final descVal = _eventController.fundraiserDetails['description'];
    if (descVal != null) {
      _controller.text = descVal.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveDescription() async {
    final fundraiserId = _eventController.fundraiserDetails['id'];
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

    setState(() {
      _isLoading = true;
    });

    try {
      final desc = _controller.text.trim();
      final response = await _apiService.updateFundraiserDescription(
        token,
        int.parse(fundraiserId.toString()),
        desc,
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map;
        if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
          _eventController.fundraiserDetails.value = Map<String, dynamic>.from(
            body['fundraiser'],
          );
        } else {
          _eventController.fundraiserDetails['description'] = desc;
          _eventController.fundraiserDetails.refresh();
        }

        Get.back(result: true);
        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Description updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        String errorMsg = 'Failed to update description';
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
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
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
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEAF4),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFFFC9E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 14.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Get Inspiration',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6FB6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'STORE NOTE',
                style: GoogleFonts.antonSc(
                  fontSize: 26.sp,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'This will appear on your pop-up store',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: _controller,
                maxLines: 5,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: const Color(0xFF1A1A2E),
                ),
                decoration: InputDecoration(
                  hintText: "What's the goal of this fundraiser?",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.black38,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFEDEDF2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6FB6)),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6FB6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
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
