import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class HomeController extends GetxController {
  final RxString userName = 'Jhon'.obs;
  final RxString userEmail = ''.obs;
  final RxString currentDateString = ''.obs;
  final RxString currentTimeString = ''.obs;

  final Rx<Map<String, dynamic>?> eventData = Rx<Map<String, dynamic>?>(null);
  final RxBool eventCreated = false.obs;
  final RxBool shopCreated = false.obs;
  final RxBool started = false.obs;

  Timer? _timeTimer;

  bool get showCreated => eventCreated.value || shopCreated.value;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
    loadHomeState();
    fetchProfileData();
    fetchMyEvents();
  }

  @override
  void onClose() {
    _timeTimer?.cancel();
    super.onClose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    currentDateString.value = DateFormat('EEEE, MMMM d').format(now);
    currentTimeString.value = DateFormat('h:mm:ss a').format(now);
  }

  Future<void> loadHomeState() async {
    final name = await SharedPreferencesHelper.getName();
    if (name.isNotEmpty) {
      userName.value = name;
    }
    final email = await SharedPreferencesHelper.getEmail();
    if (email.isNotEmpty) {
      userEmail.value = email;
    }
  }

  Future<void> fetchProfileData() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token != null && token.isNotEmpty) {
      try {
        final apiService = Get.isRegistered<ApiService>()
            ? Get.find<ApiService>()
            : Get.put(ApiService());
        final response = await apiService.getProfile(token);
        if (response.status.isOk &&
            response.body != null &&
            response.body is Map) {
          final fullName = response.body['full_name']?.toString() ?? '';
          if (fullName.isNotEmpty) {
            await SharedPreferencesHelper.saveName(fullName);
            userName.value = fullName;
          }
          final email = response.body['email']?.toString() ?? '';
          if (email.isNotEmpty) {
            await SharedPreferencesHelper.saveEmail(email);
            userEmail.value = email;
          }
        }
      } catch (e) {
        debugPrint('HomeController fetchProfileData error: $e');
      }
    }
  }

  Future<void> fetchMyEvents() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('=== FETCH MY EVENTS: NO ACCESS TOKEN FOUND ===');
      return;
    }

    debugPrint('=== FETCH MY EVENTS START ===');
    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getMyEvents(token);

      debugPrint('=== FETCH MY EVENTS RESPONSE ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.status.isOk &&
          response.body != null &&
          response.body is List) {
        final List events = response.body;
        if (events.isNotEmpty) {
          final latestEvent = events.last;
          final isStarted = latestEvent['is_active'] == true;
          eventData.value = Map<String, dynamic>.from(latestEvent);
          eventCreated.value = true;
          started.value = isStarted;
        }
      }
    } catch (e) {
      debugPrint('=== FETCH MY EVENTS EXCEPTION ===');
      debugPrint('Error: $e');
    }
  }

  Map<String, dynamic>? getMyParticipant() {
    if (eventData.value == null || eventData.value!['participants'] == null) {
      return null;
    }
    final participants = eventData.value!['participants'] as List;
    for (final p in participants) {
      if (p is Map && p['email'] == userEmail.value) {
        return Map<String, dynamic>.from(p);
      }
    }
    if (participants.isNotEmpty && participants.first is Map) {
      return Map<String, dynamic>.from(participants.first);
    }
    return null;
  }

  String getRemainingTime(String? endDateStr) {
    if (endDateStr == null) return '0 Day 0 Hours 0 Min';
    final endDate = DateTime.tryParse(endDateStr);
    if (endDate == null) return '0 Day 0 Hours 0 Min';
    final now = DateTime.now().toUtc();
    final difference = endDate.difference(now);
    if (difference.isNegative) return '0 Day 0 Hours 0 Min';
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    return '$days Day $hours Hours $minutes Min';
  }
}
