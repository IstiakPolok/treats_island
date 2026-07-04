import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controller/schedule_event_controller.dart';
import 'schedule_event_screen.dart';

class ParticipateScreen extends StatefulWidget {
  final ScheduleEventController controller;

  const ParticipateScreen({super.key, required this.controller});

  @override
  State<ParticipateScreen> createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends State<ParticipateScreen> {
  late final TextEditingController _rangeController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _rangeController = TextEditingController(
      text: widget.controller.estimatedEarningsRange,
    );
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (_rangeController.text.trim().isEmpty) {
          setState(() {
            final display = widget.controller.estimatedEarningsRange;
            _rangeController.text = display;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _rangeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Participate',
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'HOW MANY SELLERS\nDO YOU EXPECT\nTO PARTICIPATE?',
                      style: GoogleFonts.antonSc(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.normal,
                        height: 1.3,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: const Color(0xFFE7E7EC)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ESTIMATED EARNINGS',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black38,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Obx(() {
                            final display =
                                widget.controller.estimatedEarningsRange;
                            if (!_focusNode.hasFocus &&
                                widget
                                    .controller
                                    .earningsOverride
                                    .value
                                    .isEmpty &&
                                _rangeController.text != display) {
                              _rangeController.text = display;
                              _rangeController.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(offset: display.length),
                                  );
                            }
                            return TextField(
                              controller: _rangeController,
                              focusNode: _focusNode,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A2E),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: widget.controller.setEarningsOverride,
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Row(
                      children: [
                        Expanded(
                          child: _OptionPill(
                            label: 'Just me',
                            value: 1,
                            controller: widget.controller,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _OptionPill(
                            label: '5',
                            value: 5,
                            controller: widget.controller,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _OptionPill(
                            label: '10',
                            value: 10,
                            controller: widget.controller,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: _OptionPill(
                            label: '20',
                            value: 20,
                            controller: widget.controller,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _OptionPill(
                            label: '30',
                            value: 30,
                            controller: widget.controller,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _OptionPill(
                            label: '50',
                            value: 50,
                            controller: widget.controller,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _OptionPill(
                      label: '51+',
                      value: 51,
                      controller: widget.controller,
                      fullWidth: true,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              child: PrimaryButton(
                text: 'Save',
                onPressed: () => Get.to(() => ScheduleEventScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionPill extends StatelessWidget {
  final String label;
  final int value;
  final bool fullWidth;
  final ScheduleEventController controller;

  const _OptionPill({
    required this.label,
    required this.value,
    required this.controller,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.sellerCount.value == value;
      return GestureDetector(
        onTap: () => controller.setSellerCount(value),
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFC1DE) : Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5AA5) : Colors.black12,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFFFF5AA5) : Colors.black38,
            ),
          ),
        ),
      );
    });
  }
}
