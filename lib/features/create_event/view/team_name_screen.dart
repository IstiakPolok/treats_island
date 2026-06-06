import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/primary_button.dart';
import '../controller/schedule_event_controller.dart';
import 'participate_screen.dart';

class TeamNameScreen extends StatefulWidget {
  final ScheduleEventController controller;

  const TeamNameScreen({super.key, required this.controller});

  @override
  State<TeamNameScreen> createState() => _TeamNameScreenState();
}

class _TeamNameScreenState extends State<TeamNameScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.controller.teamName.value,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                        'Team Name',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'WHAT IS THE NAME\nOF YOUR TEAM?',

                        style: GoogleFonts.antonSc(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.normal,
                          height: 1.1,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: const Color(0xFFA1A1A1),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Team name',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.black26,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 140.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 18.h,
                    ),
                    child: PrimaryButton(
                      text: 'Next',
                      onPressed: () {
                        widget.controller.teamName.value = _nameController.text
                            .trim();
                        Get.to(
                          () =>
                              ParticipateScreen(controller: widget.controller),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
