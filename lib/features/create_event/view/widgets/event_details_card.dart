import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../controller/schedule_event_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'overview_card.dart';
import 'overview_info_items.dart';
import '../../../../core/utils/date_time_utils.dart';

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
              Obx(() {
                final Map<String, dynamic>? eventData =
                    (controller.createdEvent['event']
                        as Map<String, dynamic>?) ??
                    (controller.createdEvent.isNotEmpty
                        ? controller.createdEvent
                        : null);

                final startDateTime =
                    DateTimeUtils.parseToLocal(eventData?['start_date']) ??
                    controller.startDate.value;

                final durationDays = eventData?['duration'] != null
                    ? (int.tryParse(eventData!['duration'].toString()) ??
                        controller.durationDays.value)
                    : controller.durationDays.value;

                final endDateTime =
                    DateTimeUtils.parseToLocal(eventData?['end_date']) ??
                    startDateTime.add(Duration(days: durationDays));

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoMini(
                          title: 'START DATE',
                          value: DateTimeUtils.formatLocalDate(startDateTime),
                        ),
                        InfoMiniDate(
                          title: 'START TIME',
                          value: DateTimeUtils.formatLocalTime(
                            startDateTime,
                            withTimezone: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoMini(
                          title: 'END DATE',
                          value: DateTimeUtils.formatLocalDate(endDateTime),
                        ),
                        InfoMiniDate(
                          title: 'END TIME',
                          value: DateTimeUtils.formatLocalTime(
                            endDateTime,
                            withTimezone: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
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
                              (controller.createdEvent['event']
                                  as Map<String, dynamic>?) ??
                              (controller.createdEvent.isNotEmpty
                                  ? controller.createdEvent
                                  : null);
                          final code =
                              eventData?['code'] ??
                              controller.createdEvent['code'] ??
                              '';

                          final startDateTime =
                              DateTimeUtils.parseToLocal(eventData?['start_date']) ??
                              controller.startDate.value;
                          final endDateTime =
                              DateTimeUtils.parseToLocal(eventData?['end_date']) ??
                              controller.endDate;

                          final String startD =
                              DateFormat('MM/dd/yy').format(startDateTime);
                          final String startT = DateTimeUtils.formatLocalTime(
                            startDateTime,
                            withTimezone: true,
                          );
                          final String endD =
                              DateFormat('MM/dd/yy').format(endDateTime);
                          final String endT = DateTimeUtils.formatLocalTime(
                            endDateTime,
                            withTimezone: true,
                          );

                          final String inviteLink =
                              'https://treatsislandcandy.store/join-event?je=$code';

                          final String shareText =
                              'Hello Team - I set up a virtual fundraiser with Treats Island GO! It is 100% contactless. We get to keep 50% of total profit and Treat Island GO will ship the product directly to our buyers. Each of us will create a Pop-Up Store selling this specialized candy! The prices range from \$15 to \$25 per container and you won\'t find these premium products in general stores. Our fundraising window begins on $startD at $startT and goes until $endD, at $endT. Before the fundraiser begins:\n\n'
                              'First, copy the Event Code $code.\n\n'
                              'After downloading the app, JOIN THE EVENT  and Create your personalized Pop-Up Store!\n\n'
                              'Now, Download the app HERE!\n$inviteLink';

                          final box =
                              btnContext.findRenderObject() as RenderBox?;
                          SharePlus.instance.share(
                            ShareParams(
                              text: shareText,
                              title: 'Treats Island Event Invitation',
                              subject: 'Treats Island Event Invitation',
                              sharePositionOrigin: box != null
                                  ? (box.localToGlobal(Offset.zero) & box.size)
                                  : null,
                            ),
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
