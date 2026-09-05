import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../constants/app_strings.dart';
import 'shared_preferences_helper.dart';

class ApiService extends GetConnect {
  // Define the base URL. The user can update this constant as needed.
  //static const String defaultBaseUrl = 'https://api.treatsislandvf.tech';
  static const String defaultBaseUrl = 'https://api.treatsislandgo.com';

  static String formatImageUrl(String? path) {
    if (path == null || path.isEmpty || path == 'null') return '';
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$defaultBaseUrl$cleanPath';
  }

  bool _isLoggingOut = false;

  @override
  void onInit() {
    httpClient.baseUrl = defaultBaseUrl;
    httpClient.timeout = const Duration(minutes: 5);

    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401) {
        final body = response.body;
        bool isTokenExpired = false;
        if (body != null) {
          if (body is Map) {
            if (body['code'] == 'token_not_valid' ||
                body['detail']?.toString().contains('token') == true) {
              isTokenExpired = true;
            }
          } else if (body.toString().contains('token_not_valid') ||
              body.toString().contains('Token is expired')) {
            isTokenExpired = true;
          }
        } else {
          isTokenExpired = true;
        }

        if (isTokenExpired && !_isLoggingOut) {
          _isLoggingOut = true;
          await SharedPreferencesHelper.clearAllData();
          Get.offAllNamed(AppStrings.loginRoute);
          Get.snackbar(
            'Session Expired',
            'Your session has expired. Please log in again.',
            snackPosition: SnackPosition.BOTTOM,
          );
          _isLoggingOut = false;
        }
      }
      return response;
    });

    super.onInit();
  }

  /// Sends a POST request to log in the user with email and password.
  Future<Response> login(String email, String password) {
    return post('/auth/login/', {'email': email, 'password': password});
  }

  /// Sends a POST request with Bearer token to register the device notification token.
  Future<Response> registerNotificationToken({
    required String authToken,
    required String token,
    required String platform,
    String? deviceName,
    String? deviceId,
    String? osVersion,
  }) {
    return post(
      '/notification/register-token/',
      {
        'token': token,
        'platform': platform,
        'deviceName': deviceName ?? '',
        'device_id': deviceId ?? '',
        'osVersion': osVersion ?? '',
      },
      headers: {'Authorization': 'Bearer $authToken'},
    );
  }

  /// Sends a POST request to register a user.
  Future<Response> register(
    String email,
    String password,
    String confirmPassword,
  ) {
    return post('/auth/register/', {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    });
  }

  /// Sends a POST request to send OTP code to the phone number.
  Future<Response> sendOtp(String phone) {
    return post('/auth/send-otp/', {'phone': phone});
  }

  /// Sends a POST request to verify the OTP code.
  Future<Response> verifyOtp(String phone, String otp) {
    return post('/auth/verify-otp/', {'phone': phone, 'otp': otp});
  }

  /// Sends a PUT request with Bearer token to update user profile.
  Future<Response> updateProfile({
    required String token,
    String? fullName,
    String? phone,
    String? email,
    String? imagePath,
  }) {
    final Map<String, dynamic> fields = {};
    if (fullName != null) fields['full_name'] = fullName;
    if (phone != null) fields['phone'] = phone;
    if (email != null) fields['email'] = email;

    if (imagePath != null && imagePath.isNotEmpty) {
      fields['image'] = MultipartFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
    }

    final formData = FormData(fields);
    return put(
      '/auth/profile/',
      formData,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a GET request with Bearer token to fetch user profile.
  Future<Response> getProfile(String token) {
    return get('/auth/profile/', headers: {'Authorization': 'Bearer $token'});
  }

  /// Sends a GET request to fetch Terms and Conditions.
  Future<Response> getTermsAndConditions() {
    return get('/auth/terms-and-condition/');
  }

  /// Sends a GET request to fetch Privacy Policy.
  Future<Response> getPrivacyPolicy() {
    return get('/auth/privacy-policy/');
  }

  /// Sends a GET request to fetch organization types.
  Future<Response> getOrganizationTypes() {
    return get('/event/organization-types/');
  }

  /// Sends a POST request with Bearer token to create a new event.
  Future<Response> createEvent({
    required String token,
    required String type,
    required String startDate,
    required int estimatedParticipants,
    required double minEstimatedEarning,
    required double maxEstimatedEarning,
    required String teamName,
  }) {
    return post(
      '/event/create/',
      {
        'type': type,
        'start_date': startDate,
        'estimated_participants': estimatedParticipants,
        'min_estimated_earning': minEstimatedEarning,
        'max_estimated_earning': maxEstimatedEarning,
        'team_name': teamName,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a GET request with Bearer token to fetch user's events.
  Future<Response> getMyEvents(String token) {
    return get(
      '/event/my-events/',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a GET request with Bearer token to fetch user's event history.
  Future<Response> getMyEventsHistory(String token) {
    return get(
      '/event/my-events/history/',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a POST request with Bearer token to join an event.
  Future<Response> joinEvent(String token, String code) {
    return post(
      '/event/join/',
      {'code': code},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a GET request with Bearer token to fetch fundraiser details.
  Future<Response> getFundraiser(String token, int eventId) {
    return get(
      '/event/$eventId/my-fundraiser/',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a PUT request with Bearer token to update fundraiser name.
  Future<Response> updateFundraiserName(
    String token,
    int fundraiserId,
    String name,
  ) {
    return put(
      '/event/fundraiser/$fundraiserId/name/',
      {'name': name},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a PUT request with Bearer token to update fundraiser goal.
  Future<Response> updateFundraiserGoal(
    String token,
    int fundraiserId,
    double goal,
  ) {
    return put(
      '/event/fundraiser/$fundraiserId/goal/',
      {'goal': goal},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a PUT request with Bearer token to update fundraiser media.
  Future<Response> updateFundraiserMedia({
    required String token,
    required int fundraiserId,
    String? imagePath,
    String? videoPath,
  }) {
    final Map<String, dynamic> fields = {};
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = io.File(imagePath);
      if (file.existsSync()) {
        fields['image'] = MultipartFile(
          file.readAsBytesSync(),
          filename: imagePath.split('/').last,
        );
      }
    }
    if (videoPath != null && videoPath.isNotEmpty) {
      final file = io.File(videoPath);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        fields['video'] = MultipartFile(
          bytes,
          filename: videoPath.split('/').last,
        );
      }
    }

    final formData = FormData(fields);
    final String url = '/event/fundraiser/$fundraiserId/media/';
    debugPrint('=== API REQUEST: PUT $url ===');
    debugPrint('Fields: ${fields.keys.toList()}');
    if (imagePath != null) debugPrint('imagePath: $imagePath');
    if (videoPath != null) debugPrint('videoPath: $videoPath');

    return put(url, formData, headers: {'Authorization': 'Bearer $token'}).then(
      (response) {
        debugPrint('=== API RESPONSE: PUT $url ===');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Status Text: ${response.statusText}');
        debugPrint('Response Body: ${response.body}');
        return response;
      },
    );
  }

  /// Sends a GET request with Bearer token to fetch fundraiser supporters.
  Future<Response> getFundraiserSupporters(String token, int fundraiserId) {
    return get(
      '/event/fundraiser/$fundraiserId/supporters/',
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a PUT request with Bearer token to update an event.
  Future<Response> updateEvent({
    required String token,
    required int eventId,
    String? type,
    String? startDate,
    int? estimatedParticipants,
    double? minEstimatedEarning,
    double? maxEstimatedEarning,
    String? name,
    String? payoutManager,
  }) {
    final Map<String, dynamic> body = {};
    if (type != null) body['type'] = type;
    if (startDate != null) body['start_date'] = startDate;
    if (estimatedParticipants != null) {
      body['estimated_participants'] = estimatedParticipants;
    }
    if (minEstimatedEarning != null) {
      body['min_estimated_earning'] = minEstimatedEarning;
    }
    if (maxEstimatedEarning != null) {
      body['max_estimated_earning'] = maxEstimatedEarning;
    }
    if (name != null) body['name'] = name;
    if (payoutManager != null) body['payout_manager'] = payoutManager;

    final String base = httpClient.baseUrl ?? defaultBaseUrl;
    final String cleanBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final String fullUrl = '$cleanBase/event/$eventId/update/';
    debugPrint('=== API_SERVICE UPDATE EVENT REQUEST ===');
    debugPrint('URL: $fullUrl');
    debugPrint('Body: $body');
    debugPrint('=======================================');

    return put(
      '/event/$eventId/update/',
      body,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a PUT request with Bearer token to update fundraiser description.
  Future<Response> updateFundraiserDescription(
    String token,
    int fundraiserId,
    String description,
  ) {
    return put(
      '/event/fundraiser/$fundraiserId/description/',
      {'description': description},
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  /// Sends a POST request with Bearer token to extend an event.
  Future<Response> extendEvent({required String token, required int eventId}) {
    final String url = '/event/$eventId/extend/';
    debugPrint('=== API REQUEST: POST $url ===');
    debugPrint('Event ID: $eventId');
    debugPrint('Authorization token: $token');

    return post(
      url,
      {},
      headers: {'Authorization': 'Bearer $token'},
    ).then((response) {
      debugPrint('=== API RESPONSE: POST $url ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Status Text: ${response.statusText}');
      debugPrint('Headers: ${response.headers}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('================================');
      return response;
    });
  }
}
