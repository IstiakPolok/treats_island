import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/schedule_event_controller.dart';
import '../../utils/share_helper.dart';
import 'overview_card.dart';
import 'overview_info_items.dart';

class EventDetailsCard extends StatelessWidget {
  final ScheduleEventController controller;
  final String organizerName;

  const EventDetailsCard({
    super.key,
    required this.controller,
    required this.organizerName,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Column(
      children: [
        OverviewCard(
          title: 'Event Details',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final Map<String, dynamic>? eventData =
                    controller.createdEvent['event'] as Map<String, dynamic>?;
                final code =
                    eventData?['code'] ??
                    controller.createdEvent['code'] ??
                    'No Code Found';

                return GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code.toString()));
                    Get.snackbar(
                      'Copied',
                      'Event code copied to clipboard!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black.withAlpha(26),
                      colorText: Colors.black,
                    );
                  },
                  child: DetailsRow(
                    label: 'EVENT CODE',
                    value: code.toString(),
                    trailing: Icon(
                      Icons.copy_rounded,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                );
              }),
              const DashedDivider(color: Color(0xFFEDEDF2)),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoMini(
                      title: 'START DATE',
                      value: DateFormat(
                        'EEEE, MMMM dd, yyyy',
                      ).format(controller.startDate.value),
                    ),
                    InfoMiniDate(
                      title: 'START TIME',
                      value: controller.formattedStartTime,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoMini(
                      title: 'END DATE',
                      value: DateFormat(
                        'EEEE, MMMM dd, yyyy',
                      ).format(controller.endDate),
                    ),
                    InfoMiniDate(
                      title: 'END TIME',
                      value: controller.formattedEndTime,
                    ),
                  ],
                ),
              ),
              const DashedDivider(color: Color(0xFFEDEDF2)),
              Row(
                children: [
                  Expanded(
                    child: InfoMini(
                      title: 'Organizer',
                      value: organizerName,
                    ),
                  ),
                  Builder(
                    builder: (btnContext) => SizedBox(
                      height: 36.h,
                      child: ElevatedButton(
                        onPressed: () {
                          final Map<String, dynamic>? eventData =
                              controller.createdEvent['event']
                                  as Map<String, dynamic>?;
                          final code =
                              eventData?['code'] ??
                              controller.createdEvent['code'] ??
                              '';

                          DateTime? startDateTime;
                          DateTime? endDateTime;
                          if (eventData?['start_date'] != null) {
                            startDateTime = DateTime.tryParse(
                              eventData!['start_date'].toString(),
                            )?.toLocal();
                          }
                          if (eventData?['end_date'] != null) {
                            endDateTime = DateTime.tryParse(
                              eventData!['end_date'].toString(),
                            )?.toLocal();
                          }

                          final String startD = startDateTime != null
                              ? DateFormat('MM/dd/yy').format(startDateTime)
                              : '___/___/26';
                          final String startT = startDateTime != null
                              ? DateFormat(
                                  'h:mm a',
                                ).format(startDateTime).toLowerCase()
                              : '9:00 am';
                          final String endD = endDateTime != null
                              ? DateFormat('MM/dd/yy').format(endDateTime)
                              : '___/___/26';
                          final String endT = endDateTime != null
                              ? DateFormat(
                                  'h:mm a',
                                ).format(endDateTime).toLowerCase()
                              : '9:00 am';

                          final String inviteLink =
                              'https://treatsislandcandy.store/join-event?je=$code';

                          final String shareText =
                              'Hello Team - I set up a virtual fundraiser with Treats Island Candy! It is 100% contactless. We get to keep 50% of total profit and Treat Island Candy will ship the product directly to our buyers. Each of us will create a Pop-Up Store selling this specialized candy! The prices range from \$15 to \$25 per container and you won\'t find these premium products in general stores. Our fundraising window begins on $startD at $startT and goes until $endD, at $endT. Before the fundraiser begins:\n\n'
                              'Click on the link $inviteLink to JOIN THE EVENT\n\n'
                              'Confirm the Event Code $code.   Download the APP.\n\n'
                              'Create your personalized Pop-Up Store';

                          final box =
                              btnContext.findRenderObject() as RenderBox?;
                          ShareHelper.shareTextAndImage(
                            shareText,
                            box != null
                                ? (box.localToGlobal(Offset.zero) & box.size)
                                : null,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Share Event',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 12.0 : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: () async {
            final String? shareLink =
                controller.fundraiserDetails['share_link']?.toString();
            if (shareLink != null && shareLink.isNotEmpty) {
              final Uri url = Uri.parse(shareLink);
              try {
                if (!await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                )) {
                  Get.snackbar(
                    'Error',
                    'Could not launch $shareLink',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black.withAlpha(26),
                    colorText: Colors.black,
                  );
                }
              } catch (e) {
                debugPrint('Launch URL Exception: $e');
              }
            } else {
              Get.snackbar(
                'Info',
                'Share link is not available yet',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black.withAlpha(26),
                colorText: Colors.black,
              );
            }
          },
          borderRadius: BorderRadius.circular(20.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              'assets/images/imagebutton.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
