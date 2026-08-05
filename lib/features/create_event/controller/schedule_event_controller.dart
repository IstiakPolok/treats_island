import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class ScheduleEventController extends GetxController {
  final RxInt durationDays = 5.obs;
  final ApiService _apiService = Get.put(ApiService());
  final RxList<String> categories = <String>[].obs;
  final RxList<Map<String, dynamic>> categoryObjects =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString organizerName = "".obs;
  final RxMap<String, dynamic> createdEvent = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> fundraiserDetails = <String, dynamic>{}.obs;
  final RxBool isTermsAccepted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    _loadOrganizerName();
    fetchMyEvents();
  }

  Future<void> _loadOrganizerName() async {
    try {
      final name = await SharedPreferencesHelper.getName();
      if (name.isNotEmpty) {
        organizerName.value = name;
      }
    } catch (_) {}
  }

  Future<void> fetchMyEvents() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _apiService.getMyEvents(token);
      isLoading.value = false;
      if (response.status.isOk &&
          response.body != null &&
          response.body is List) {
        final List eventsList = response.body;
        if (eventsList.isNotEmpty) {
          final latestEvent = eventsList.last;
          createdEvent.value = {
            'event': Map<String, dynamic>.from(latestEvent),
          };

          final eventData = createdEvent['event'];
          if (eventData != null) {
            teamName.value = eventData['name']?.toString() ?? teamName.value;
            if (eventData['start_date'] != null) {
              final parsedStart = DateTime.tryParse(
                eventData['start_date'].toString(),
              );
              if (parsedStart != null) {
                startDate.value = parsedStart.toLocal();
              }
            }
            if (eventData['duration'] != null) {
              final parsedDur = int.tryParse(eventData['duration'].toString());
              if (parsedDur != null) {
                durationDays.value = parsedDur;
              }
            }
            if (eventData['estimated_participants'] != null) {
              final parsedPart = int.tryParse(
                eventData['estimated_participants'].toString(),
              );
              if (parsedPart != null) {
                sellerCount.value = parsedPart;
              }
            }
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _apiService.getOrganizationTypes();
      if (response.status.isOk &&
          response.body != null &&
          response.body is List) {
        final List typesList = response.body;
        categoryObjects.value = List<Map<String, dynamic>>.from(typesList);
        categories.value = typesList
            .map((type) => type['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .toList();
      }
    } catch (e) {
      // Graceful fallback
    }
  }

  String get selectedCategorySlug {
    final name = organization.value;
    final match = categoryObjects.firstWhere(
      (element) => element['name'] == name,
      orElse: () => <String, dynamic>{},
    );
    if (match.containsKey('slug')) {
      return match['slug']?.toString() ?? '';
    }
    // Fallback: slugify the name
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  // Default start date: current date/time
  final Rx<DateTime> startDate = DateTime.now().obs;

  final RxString organization = "Select an Organization Type".obs;
  final RxString teamName = "".obs;
  final RxString teamLocation = "".obs;
  final RxInt sellerCount = 10.obs;
  final RxString earningsOverride = "".obs;

  final RxBool agreeToTerms = false.obs;

  // Computed properties
  DateTime get endDate =>
      startDate.value.add(Duration(days: durationDays.value));

  String get formattedStartDate => DateFormat('MMM dd').format(startDate.value);
  String get formattedStartTime => DateFormat('h:mm a').format(startDate.value);

  String get formattedEndDate => DateFormat('MMM dd').format(endDate);
  String get formattedEndTime => DateFormat('h:mm a').format(endDate);

  void setDuration(int days) {
    durationDays.value = days;
  }

  void setSellerCount(int count) {
    sellerCount.value = count;
    earningsOverride.value = '';
  }

  void setEarningsOverride(String value) {
    earningsOverride.value = value.trim();
  }

  String get estimatedEarningsRange {
    if (earningsOverride.value.isNotEmpty) {
      return earningsOverride.value;
    }
    final min = sellerCount.value * 40;
    final max = sellerCount.value * 440;
    final maxLabel = sellerCount.value >= 51 ? '+' : '';
    return '\$${_formatNumber(min)} - \$${_formatNumber(max)}$maxLabel';
  }

  String _formatNumber(int value) {
    final buffer = StringBuffer();
    final text = value.toString();
    for (var i = 0; i < text.length; i++) {
      final indexFromEnd = text.length - i;
      buffer.write(text[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      startDate.value = DateTime(
        picked.year,
        picked.month,
        picked.day,
        startDate.value.hour,
        startDate.value.minute,
      );
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startDate.value),
    );
    if (picked != null) {
      startDate.value = DateTime(
        startDate.value.year,
        startDate.value.month,
        startDate.value.day,
        picked.hour,
        picked.minute,
      );
    }
  }

  void toggleTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  Future<bool> scheduleEvent() async {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Required',
        'Please agree to the Terms and Conditions to schedule the event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (organization.value.isEmpty ||
        organization.value == "Select an Organization Type") {
      Get.snackbar(
        'Required',
        'Please select an Organization Type to schedule the event.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(26),
        colorText: Colors.red,
      );
      return false;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to schedule an event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isLoading.value = true;
    try {
      final String formattedDateStr = startDate.value
          .toUtc()
          .toIso8601String()
          .replaceAll(RegExp(r'\.\d+'), '');
      final int participants = sellerCount.value;
      final double minEarning = (participants * 40).toDouble();
      final double maxEarning = (participants * 440).toDouble();
      final String finalTeamName = teamName.value.isEmpty
          ? "My Team"
          : teamName.value;

      print("DEBUG: Sending Event Creation Payload:");
      print("  - URL: ${ApiService.defaultBaseUrl}/event/create/");
      print("  - Authorization token: $token");
      print("  - type: $selectedCategorySlug");
      print("  - start_date: $formattedDateStr");
      print("  - estimated_participants: $participants");
      print("  - min_estimated_earning: $minEarning");
      print("  - max_estimated_earning: $maxEarning");
      print("  - team_name: $finalTeamName");

      final response = await _apiService.createEvent(
        token: token,
        type: selectedCategorySlug,
        startDate: formattedDateStr,
        estimatedParticipants: participants,
        minEstimatedEarning: minEarning,
        maxEstimatedEarning: maxEarning,
        teamName: finalTeamName,
      );

      print("DEBUG: Received Event Creation Response:");
      print("  - Status Code: ${response.statusCode}");
      print("  - Body: ${response.body}");
      print("  - Status Text: ${response.statusText}");

      isLoading.value = false;

      if (response.status.isOk && response.body != null) {
        if (response.body is Map) {
          createdEvent.value = Map<String, dynamic>.from(response.body);
        } else {
          createdEvent.value = <String, dynamic>{};
        }
        return true;
      } else {
        String errorMsg = 'Failed to create event. Please try again.';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      print("DEBUG: Event Creation Exception: $e");
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  final RxBool isUpdating = false.obs;

  /// Updates an event via the PUT API and refreshes createdEvent.
  Future<bool> updateEvent({
    required int eventId,
    String? typeSlug,
    String? startDateIso,
    int? estimatedParticipants,
    double? minEstimatedEarning,
    double? maxEstimatedEarning,
    String? name,
    String? payoutManager,
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to update the event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isUpdating.value = true;
    try {
      debugPrint('=== UPDATE EVENT API REQUEST ===');
      debugPrint('Event ID: $eventId');
      debugPrint('Type Slug: $typeSlug');
      debugPrint('Start Date ISO: $startDateIso');
      debugPrint('Estimated Participants: $estimatedParticipants');
      debugPrint('Min Estimated Earning: $minEstimatedEarning');
      debugPrint('Max Estimated Earning: $maxEstimatedEarning');
      debugPrint('Name: $name');
      debugPrint('Payout Manager: $payoutManager');
      debugPrint('================================');

      final response = await _apiService.updateEvent(
        token: token,
        eventId: eventId,
        type: typeSlug,
        startDate: startDateIso,
        estimatedParticipants: estimatedParticipants,
        minEstimatedEarning: minEstimatedEarning,
        maxEstimatedEarning: maxEstimatedEarning,
        name: name,
        payoutManager: payoutManager,
      );
      isUpdating.value = false;

      debugPrint('=== UPDATE EVENT API RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Body: ${response.body}');
      debugPrint('=================================');

      if (response.status.isOk &&
          response.body != null &&
          response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        if (body.containsKey('event') && body['event'] is Map) {
          createdEvent.value = {
            'event': Map<String, dynamic>.from(body['event']),
          };
          createdEvent.refresh();
          // Also sync local state
          final eventData = createdEvent['event'] as Map<String, dynamic>;
          teamName.value = eventData['name']?.toString() ?? teamName.value;
          if (eventData['start_date'] != null) {
            final parsed = DateTime.tryParse(
              eventData['start_date'].toString(),
            );
            if (parsed != null) startDate.value = parsed.toLocal();
          }
          if (eventData['estimated_participants'] != null) {
            final parsed = int.tryParse(
              eventData['estimated_participants'].toString(),
            );
            if (parsed != null) sellerCount.value = parsed;
          }
        }
        Get.snackbar(
          'Success',
          'Event updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black.withAlpha(26),
          colorText: Colors.black,
        );
        return true;
      } else {
        String errorMsg = 'Failed to update event. Please try again.';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      isUpdating.value = false;
      debugPrint('=== UPDATE EVENT API EXCEPTION ===');
      debugPrint('Exception: $e');
      debugPrint('==================================');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Extends the event duration by 3 days.
  Future<bool> extendEvent({required int eventId}) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to extend the event.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isUpdating.value = true;
    try {
      final response = await _apiService.extendEvent(
        token: token,
        eventId: eventId,
      );
      isUpdating.value = false;

      if (response.status.isOk && response.body != null) {
        final Map<String, dynamic> body = Map<String, dynamic>.from(
          response.body,
        );
        if (body.containsKey('message')) {
          Get.snackbar(
            'Success',
            body['message'].toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withAlpha(26),
            colorText: Colors.black,
          );
        } else {
          Get.snackbar(
            'Success',
            'Event extended successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withAlpha(26),
            colorText: Colors.black,
          );
        }
        return true;
      } else {
        String errorMsg = 'Failed to extend event. Please try again.';
        if (response.body != null && response.body is Map) {
          final bodyMap = response.body as Map;
          if (bodyMap.containsKey('detail')) {
            errorMsg = bodyMap['detail'].toString();
          } else if (bodyMap.isNotEmpty) {
            errorMsg = bodyMap.values.first.toString();
          }
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      isUpdating.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
