import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';
import '../../create_event/view/event_overview_screen.dart';

class EventCodeScreen extends StatefulWidget {
  const EventCodeScreen({super.key});

  @override
  State<EventCodeScreen> createState() => _EventCodeScreenState();
}

class _EventCodeScreenState extends State<EventCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _hasError = false;
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool get _isComplete => _controllers.every((controller) {
        return controller.text.trim().isNotEmpty;
      });

  Future<void> _handleContinue() async {
    if (!_isComplete) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    final enteredCode = _controllers.map((controller) => controller.text.trim()).join();
    
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to join an event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      
      final response = await apiService.joinEvent(token, enteredCode);
      
      if (response.status.isOk) {
        final controller = Get.isRegistered<ScheduleEventController>()
            ? Get.find<ScheduleEventController>()
            : Get.put(ScheduleEventController());
        
        await controller.fetchMyEvents();

        setState(() {
          _isLoading = false;
        });

        Get.off(
          () => EventOverviewScreen(
            controller: controller,
            showShopTab: true,
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        String errorMsg = 'Failed to join event. Please check the code.';
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
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _codeCircle(int index) {
    return Container(
      width: 46.w,
      height: 46.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _hasError ? const Color(0xFFFF6B6B) : const Color(0xFFFF6FB6),
          width: 1.5,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: _hasError ? const Color(0xFFFF6B6B) : const Color(0xFF1A1A2E),
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < _focusNodes.length - 1) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _hasError ? const Color(0xFFFF3B30) : const Color(0xFFFF6FB6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    'Back',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 90.h),
              Center(
                child: Text(
                  'ENTER ON EVENT CODE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.antonSc(
                    fontSize: 28.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  'The event code is provide by the\n'
                  'organizer of your fundraiser',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _codeCircle(0),
                  SizedBox(width: 10.w),
                  _codeCircle(1),
                  SizedBox(width: 10.w),
                  _codeCircle(2),
                  SizedBox(width: 10.w),
                  _codeCircle(3),
                  SizedBox(width: 10.w),
                  _codeCircle(4),
                  SizedBox(width: 10.w),
                  _codeCircle(5),
                ],
              ),
              if (_hasError) ...[
                SizedBox(height: 16.h),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFFF6B6B)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14.sp,
                          color: const Color(0xFFFF6B6B),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Oh no! The code you entered is incorrect.',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5.sp,
                            color: const Color(0xFFFF6B6B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _hasError ? 'Try again?' : 'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
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
