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
  final List<String> _codeDigits = List.filled(6, '');
  int _currentIndex = 0;
  String _errorMessage = 'The code you entered is incorrect.';
  bool _hasError = false;
  bool _isLoading = false;

  bool get _isComplete => _codeDigits.every((digit) => digit.isNotEmpty);

  void _onKeyTap(String value) {
    if (_currentIndex < 6) {
      setState(() {
        _codeDigits[_currentIndex] = value;
        _currentIndex++;
        _hasError = false;
      });
      print(
        '🔧 [EventCodeScreen] Key tapped: $value, current code: ${_codeDigits.join()}',
      );
    }
  }

  void _onBackspace() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _codeDigits[_currentIndex] = '';
        _hasError = false;
      });
      print(
        '🔧 [EventCodeScreen] Backspace tapped, current code: ${_codeDigits.join()}',
      );
    }
  }

  Future<void> _handleContinue() async {
    final enteredCode = _codeDigits.join();
    print(
      '🔧 [EventCodeScreen] _handleContinue invoked with code: $enteredCode',
    );

    if (!_isComplete) {
      print('⚠️ [EventCodeScreen] Code incomplete');
      setState(() {
        _errorMessage = 'The code you entered is incomplete.';
        _hasError = true;
      });
      return;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    print('🔧 [EventCodeScreen] Access Token: $token');

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

      print(
        '🔧 [EventCodeScreen] Sending joinEvent API request for code: $enteredCode',
      );
      final response = await apiService.joinEvent(token, enteredCode);
      print(
        '🔧 [EventCodeScreen] joinEvent Status Code: ${response.statusCode}',
      );
      print('🔧 [EventCodeScreen] joinEvent Response Body: ${response.body}');

      if (response.status.isOk) {
        final controller = Get.isRegistered<ScheduleEventController>()
            ? Get.find<ScheduleEventController>()
            : Get.put(ScheduleEventController());

        await controller.fetchMyEvents();

        setState(() {
          _isLoading = false;
        });

        Get.off(
          () => EventOverviewScreen(controller: controller, showShopTab: true),
        );
      } else {
        String extractedMsg = 'The code you entered is incorrect.';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('error')) {
            extractedMsg = bodyMap['error'].toString();
          } else if (bodyMap.containsKey('detail')) {
            extractedMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            extractedMsg = bodyMap.values.first.toString();
          }
        }

        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = extractedMsg;
        });
      }
    } catch (e) {
      print('❌ [EventCodeScreen] Exception during joinEvent: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'An unexpected error occurred.';
      });
    }
  }

  Widget _codeCircle(int index, bool isTablet) {
    final String val = _codeDigits[index];
    final bool isSelected = index == _currentIndex && _currentIndex < 6;

    return Container(
      width: isTablet ? 46.0 : 46.w,
      height: isTablet ? 46.0 : 46.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _hasError
              ? const Color(0xFFFF6B6B)
              : isSelected
              ? const Color(0xFFFF6FB6)
              : const Color(0xFFE0E0E0),
          width: isSelected || _hasError ? 2.0 : 1.5,
        ),
        color: val.isNotEmpty ? const Color(0xFFFFEAF4) : Colors.transparent,
      ),
      child: Center(
        child: Text(
          val,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 18.0 : 18.sp,
            fontWeight: FontWeight.w600,
            color: _hasError
                ? const Color(0xFFFF6B6B)
                : const Color(0xFF1A1A2E),
          ),
        ),
      ),
    );
  }

  Widget _buildKey(String label, bool isTablet, {VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 4.0 : 3.w),
        child: Material(
          color: const Color(0xFFF5F5F9),
          borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
          child: InkWell(
            onTap: onTap ?? () => _onKeyTap(label),
            borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
            child: Container(
              height: isTablet ? 48.0 : 46.h,
              alignment: Alignment.center,
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18.0 : 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomKeyboard(bool isTablet) {
    const numberRow = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    const row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    const row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    const row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Column(
      children: [
        // Numbers Row
        Row(children: [for (final key in numberRow) _buildKey(key, isTablet)]),
        SizedBox(height: isTablet ? 4.0 : 4.h),

        // QWERTY Row 1
        Row(children: [for (final key in row1) _buildKey(key, isTablet)]),
        SizedBox(height: isTablet ? 4.0 : 4.h),

        // QWERTY Row 2 (with side padding for stagger)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 12.0 : 10.w),
          child: Row(
            children: [for (final key in row2) _buildKey(key, isTablet)],
          ),
        ),
        SizedBox(height: isTablet ? 4.0 : 4.h),

        // QWERTY Row 3 (with Backspace)
        Row(
          children: [
            SizedBox(width: isTablet ? 16.0 : 14.w),
            for (final key in row3) _buildKey(key, isTablet),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 4.0 : 3.w),
                child: Material(
                  color: const Color(0xFFFFEAF4),
                  borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
                  child: InkWell(
                    onTap: _onBackspace,
                    borderRadius: BorderRadius.circular(isTablet ? 10.0 : 10.r),
                    child: Container(
                      height: isTablet ? 48.0 : 46.h,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.backspace_outlined,
                        size: isTablet ? 20.0 : 20.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: isTablet ? 16.0 : 14.w),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = _hasError
        ? const Color(0xFFFF3B30)
        : const Color(0xFFFF6FB6);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 550.0 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: isTablet
                  ? const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0)
                  : EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                          fontSize: isTablet ? 16.0 : 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 20.0 : 30.h),
                  Center(
                    child: Text(
                      'ENTER ON EVENT CODE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.antonSc(
                        fontSize: isTablet ? 28.0 : 28.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 8.0 : 8.h),
                  Center(
                    child: Text(
                      'The event code is provide by the\n'
                      'organizer of your fundraiser',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 13.0 : 13.sp,
                        color: Colors.black45,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20.0 : 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 6; i++) ...[
                        _codeCircle(i, isTablet),
                        if (i < 5) SizedBox(width: isTablet ? 8.0 : 8.w),
                      ],
                    ],
                  ),
                  if (_hasError) ...[
                    SizedBox(height: isTablet ? 12.0 : 12.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 14.0 : 14.w,
                          vertical: isTablet ? 6.0 : 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            isTablet ? 20.0 : 20.r,
                          ),
                          border: Border.all(color: const Color(0xFFFF6B6B)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: isTablet ? 14.0 : 14.sp,
                              color: const Color(0xFFFF6B6B),
                            ),
                            SizedBox(width: isTablet ? 6.0 : 6.w),
                            Text(
                              'Oh no! $_errorMessage',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 10.5 : 10.5.sp,
                                color: const Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: isTablet ? 24.0 : 24.h),
                  _buildCustomKeyboard(isTablet),
                  SizedBox(height: isTablet ? 24.0 : 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 54.0 : 54.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            isTablet ? 30.0 : 30.r,
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: isTablet ? 20.0 : 20.sp,
                              height: isTablet ? 20.0 : 20.sp,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _hasError ? 'Try again?' : 'Continue',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 16.0 : 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20.0 : 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
