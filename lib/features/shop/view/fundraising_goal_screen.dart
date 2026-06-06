import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';

class FundraisingGoalScreen extends StatefulWidget {
  const FundraisingGoalScreen({super.key});

  @override
  State<FundraisingGoalScreen> createState() => _FundraisingGoalScreenState();
}

class _FundraisingGoalScreenState extends State<FundraisingGoalScreen> {
  int _goal = 500;
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

    final goalVal = _eventController.fundraiserDetails['goal'];
    if (goalVal != null) {
      final double? parsedGoal = double.tryParse(goalVal.toString());
      if (parsedGoal != null) {
        _goal = parsedGoal.toInt();
      }
    }
  }

  void _updateGoal(int delta) {
    setState(() {
      _goal = (_goal + delta).clamp(0, 100000);
    });
  }

  Future<void> _saveGoal() async {
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
      final response = await _apiService.updateFundraiserGoal(
        token,
        int.parse(fundraiserId.toString()),
        _goal.toDouble(),
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map;
        if (body.containsKey('fundraiser') && body['fundraiser'] is Map) {
          _eventController.fundraiserDetails.value =
              Map<String, dynamic>.from(body['fundraiser']);
        } else {
          _eventController.fundraiserDetails['goal'] = _goal.toDouble().toString();
          _eventController.fundraiserDetails.refresh();
        }

        Get.snackbar(
          'Success',
          body['message']?.toString() ?? 'Goal updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        String errorMsg = 'Failed to update goal';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
        );
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
              Text(
                'FUNDRAISING GOAL',
                style: GoogleFonts.antonSc(
                  fontSize: 28.sp,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Set a goal based on how much you need or want\n'
                'to sell. You give 50% of what you sell.',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.black45,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoalButton(
                    icon: Icons.remove,
                    onTap: () => _updateGoal(-100),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    r'$' + _goal.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  _GoalButton(
                    icon: Icons.add,
                    onTap: () => _updateGoal(100),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveGoal,
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

class _GoalButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GoalButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
