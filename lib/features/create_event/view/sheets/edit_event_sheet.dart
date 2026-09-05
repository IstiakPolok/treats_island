import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/schedule_event_controller.dart';

class EditEventSheet {
  static void show(BuildContext context, ScheduleEventController controller) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final Map<String, dynamic>? eventData =
        controller.createdEvent['event'] as Map<String, dynamic>?;
    final int eventId = eventData?['id'] as int? ?? 0;

    // Pre-fill local state
    final nameCtrl = TextEditingController(
      text: eventData?['name']?.toString() ?? '',
    );

    // Determine the currently selected type name from categoryObjects
    final int? currentTypeId = eventData?['type'] is int
        ? eventData!['type'] as int
        : int.tryParse(eventData?['type']?.toString() ?? '');
    String currentTypeName =
        controller.categoryObjects
            .where((e) => e['id'] == currentTypeId)
            .map((e) => e['name']?.toString() ?? '')
            .firstOrNull ??
        '';
    final selectedType = currentTypeName.obs;

    // Start date
    DateTime? currentStart;
    if (eventData?['start_date'] != null) {
      currentStart = DateTime.tryParse(
        eventData!['start_date'].toString(),
      )?.toLocal();
    }
    currentStart ??= controller.startDate.value;
    final selectedDate = currentStart.obs;

    // Estimated participants
    final List<int?> participantOptions = [null, 5, 10, 20, 30, 50, 51];
    final int? currentParticipants = eventData?['estimated_participants'] is int
        ? eventData!['estimated_participants'] as int
        : int.tryParse(eventData?['estimated_participants']?.toString() ?? '');
    final selectedParticipants = currentParticipants.obs;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 16.h,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(sheetContext),
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'Edit Event',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 18.0 : 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Event Name
                Text(
                  'Event Name',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: nameCtrl,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 14.0 : 14.sp,
                    color: const Color(0xFF1A1A2E),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter event name',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: isTablet ? 14.0 : 14.sp,
                      color: Colors.black38,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Organization Type
                Text(
                  'Organization Type',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(() {
                  final cats = controller.categories;
                  return Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: cats.map((cat) {
                      final isSelected = selectedType.value == cat;
                      return GestureDetector(
                        onTap: () => selectedType.value = cat,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A1A2E)
                                : const Color(0xFFF1F1F5),
                            borderRadius: BorderRadius.circular(22.r),
                            border: isSelected
                                ? null
                                : Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF525252),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 20.h),

                // Start Date
                Text(
                  'Start Date',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: sheetContext,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 3),
                        ),
                      );
                      if (picked != null) {
                        selectedDate.value = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          selectedDate.value.hour,
                          selectedDate.value.minute,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(selectedDate.value),
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 14.0 : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 18.sp,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Estimated Participants
                Text(
                  'Estimated Participants',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 13.0 : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 2.4,
                    children: participantOptions.map((opt) {
                      final isSelected = selectedParticipants.value == opt;
                      final label = opt == null
                          ? 'Just me'
                          : opt == 51
                          ? '51+'
                          : '$opt';
                      return GestureDetector(
                        onTap: () => selectedParticipants.value = opt,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFE53A1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFE53A1)
                                  : const Color(0xFFE0E0E0),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 14.0 : 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 28.h),

                // Save Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: controller.isUpdating.value
                          ? null
                          : () async {
                              // Resolve type slug from name
                              final typeName = selectedType.value;
                              String? typeSlug;
                              if (typeName.isNotEmpty) {
                                final match = controller.categoryObjects
                                    .where((e) => e['name'] == typeName)
                                    .firstOrNull;
                                if (match != null) {
                                  typeSlug = match['slug']?.toString();
                                }
                                typeSlug ??= typeName
                                    .toLowerCase()
                                    .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
                                    .replaceAll(RegExp(r'\s+'), '-');
                              }

                              final startIso = selectedDate.value
                                  .toUtc()
                                  .toIso8601String()
                                  .replaceAll(RegExp(r'\.\d+'), '');

                              final int? participants =
                                  selectedParticipants.value;
                              final double? minE = participants != null
                                  ? (participants * 40).toDouble()
                                  : null;
                              final double? maxE = participants != null
                                  ? (participants * 440).toDouble()
                                  : null;

                              final success = await controller.updateEvent(
                                eventId: eventId,
                                name: nameCtrl.text.trim().isEmpty
                                    ? null
                                    : nameCtrl.text.trim(),
                                typeSlug: typeSlug,
                                startDateIso: startIso,
                                estimatedParticipants: participants,
                                minEstimatedEarning: minE,
                                maxEstimatedEarning: maxE,
                              );

                              if (success && sheetContext.mounted) {
                                Navigator.pop(sheetContext);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A2E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isUpdating.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 15.0 : 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
