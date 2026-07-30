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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 500.0 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                    vertical: isTablet ? 10.0 : 10.h,
                  ),
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
                              fontSize: isTablet ? 18.0 : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 40.0 : 40.w),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 20.0 : 20.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: isTablet ? 40.0 : 40.h),
                        Text(
                          'WHAT IS THE NAME\nOF YOUR OF ORGANIZATION ?',
                          style: GoogleFonts.antonSc(
                            fontSize: isTablet ? 36.0 : 36.sp,
                            fontWeight: FontWeight.normal,
                            height: 1.1,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: isTablet ? 28.0 : 28.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 18.0 : 18.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              isTablet ? 30.0 : 30.r,
                            ),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: TextField(
                            controller: _nameController,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 15.0 : 15.sp,
                              color: const Color(0xFFA1A1A1),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Team name',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: isTablet ? 15.0 : 15.sp,
                                color: Colors.black26,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isTablet ? 14.0 : 14.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20.0 : 20.w,
                    vertical: isTablet ? 18.0 : 18.h,
                  ),
                  child: PrimaryButton(
                    text: 'Next',
                    onPressed: () {
                      widget.controller.teamName.value =
                          _nameController.text.trim();
                      Get.to(
                        () => ParticipateScreen(controller: widget.controller),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
