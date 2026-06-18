import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';

class DisplayNameScreen extends StatefulWidget {
  const DisplayNameScreen({super.key});

  @override
  State<DisplayNameScreen> createState() => _DisplayNameScreenState();
}

class _DisplayNameScreenState extends State<DisplayNameScreen> {
  late final TextEditingController _nameController;
  final ApiService _apiService = Get.isRegistered<ApiService>()
      ? Get.find<ApiService>()
      : Get.put(ApiService());

  late final ScheduleEventController _eventController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _eventController = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());

    final currentName =
        _eventController.fundraiserDetails['name']?.toString() ?? '';
    _nameController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter a name.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

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
      // Debug prints
      print(
        '🔧 API call: updateFundraiserName, fundraiserId: $fundraiserId, name: $name',
      );
      print('🔧 Token: $token');
      final response = await _apiService.updateFundraiserName(
        token,
        int.parse(fundraiserId.toString()),
        name,
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map;
        if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
          _eventController.fundraiserDetails.value = Map<String, dynamic>.from(
            body['fundraiser'],
          );
        } else {
          // Fallback update if structure is different
          _eventController.fundraiserDetails['name'] = name;
          _eventController.fundraiserDetails.refresh();
        }

        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Name updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        String errorMsg = 'Failed to update name';
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
              SizedBox(height: 24.h),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.antonSc(
                    fontSize: 28.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                  children: const [
                    TextSpan(text: 'enter '),
                    TextSpan(
                      text: 'the name of\nyour pop-up store? ',
                      style: TextStyle(color: Color(0xFFFF6FB6)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Full name',
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
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveName,
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
            ],
          ),
        ),
      ),
    );
  }
}
