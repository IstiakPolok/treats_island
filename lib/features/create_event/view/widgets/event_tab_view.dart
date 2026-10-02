import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/schedule_event_controller.dart';
import 'event_details_card.dart';
import 'event_payout_manager_card.dart';
import 'event_team_card.dart';
import 'fundraise_summary_card.dart';

class EventTabView extends StatelessWidget {
  final ScheduleEventController controller;
  final String organizerName;
  final VoidCallback onInviteSellerTap;

  const EventTabView({
    super.key,
    required this.controller,
    required this.organizerName,
    required this.onInviteSellerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final Map<String, dynamic>? eventData =
              controller.createdEvent['event'] as Map<String, dynamic>?;
          final String status = eventData?['status']?.toString() ?? '';
          final bool isOngoing = status.toLowerCase() == 'ongoing';
          if (isOngoing) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FundraiseSummaryCard(controller: controller),
                SizedBox(height: 16.h),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
        EventTeamCard(
          controller: controller,
          onInviteSellerTap: onInviteSellerTap,
        ),
        Obx(() {
          final Map<String, dynamic> rawMap = controller.createdEvent;
          final Map<String, dynamic>? eventData = rawMap['event'] is Map
              ? rawMap['event'] as Map<String, dynamic>
              : null;
          final dynamic isMineValue =
              eventData?['is_mine'] ??
              rawMap['is_mine'] ??
              eventData?['is_creator'] ??
              rawMap['is_creator'];
          final bool isMine = isMineValue != null
              ? (isMineValue == true ||
                  isMineValue.toString().toLowerCase() == 'true')
              : true;

          if (!isMine) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              EventPayoutManagerCard(controller: controller),
            ],
          );
        }),
        SizedBox(height: 16.h),
        EventDetailsCard(
          controller: controller,
          organizerName: organizerName,
        ),
      ],
    );
  }
}
