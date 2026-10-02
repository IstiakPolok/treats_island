import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../models/stripe_connect_status_model.dart';
import '../view/stripe_in_app_browser_screen.dart';

class StripeConnectController extends GetxController with WidgetsBindingObserver {
  final ApiService _apiService =
      Get.isRegistered<ApiService>() ? Get.find<ApiService>() : Get.put(ApiService());

  final Rx<StripeConnectStatusModel?> status = Rx<StripeConnectStatusModel?>(null);
  final RxBool isLoadingStatus = false.obs;
  final RxBool isOnboardingLoading = false.obs;
  final RxBool isDashboardLoading = false.obs;
  final RxBool isRetrying = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchConnectStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Whenever the user returns to the app from external browser or system, refresh status
      fetchConnectStatus();
    }
  }

  /// Fetches real-time payout status from GET /event/connect/status/
  Future<void> fetchConnectStatus() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) return;

    isLoadingStatus.value = true;
    try {
      final response = await _apiService.getConnectStatus(token);
      isLoadingStatus.value = false;

      if (response.status.isOk && response.body != null && response.body is Map) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(response.body);
        status.value = StripeConnectStatusModel.fromJson(data);
      } else {
        // Fallback to initial state so UI doesn't break if backend endpoint returns 404
        status.value ??= StripeConnectStatusModel.initial();
      }
    } catch (e) {
      isLoadingStatus.value = false;
      status.value ??= StripeConnectStatusModel.initial();
      debugPrint('Error fetching Stripe Connect status: $e');
    }
  }

  /// Triggers Stripe onboarding via POST /event/connect/banking/ or /event/connect/onboard/ and opens the in-app browser
  Future<bool> startOnboarding({
    String returnUrl = 'https://treatsislandgo.com/payout/return',
    String refreshUrl = 'https://treatsislandgo.com/payout/refresh',
  }) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to connect your bank account.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isOnboardingLoading.value = true;
    try {
      final response = await _apiService.createConnectOnboardUrl(
        token,
        returnUrl: returnUrl,
        refreshUrl: refreshUrl,
      );
      isOnboardingLoading.value = false;

      if (response.status.isOk && response.body != null && response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        final String? onboardingUrl =
            body['onboarding_url']?.toString() ??
            body['banking_url']?.toString() ??
            body['url']?.toString() ??
            body['stripe_url']?.toString() ??
            body['link']?.toString();

        if (onboardingUrl != null && onboardingUrl.isNotEmpty) {
          return await _openBrowserUrl(onboardingUrl, isDashboard: false);
        }
      }

      // Handle 404 (Endpoint not yet deployed on server)
      if (response.statusCode == 404) {
        return await _showBackendNotReadyDialog(
          title: 'Backend Endpoint Pending',
          message:
              'The /event/connect/banking/ endpoint is not yet live on the server.\n\nWould you like to test the In-App Browser flow using the sample Stripe URL?',
          sampleUrl:
              'https://connect.stripe.com/setup/e/acct_1UIK2TAbS2etFrSE/LZYYLH8HfwXD',
          isDashboard: false,
        );
      }

      final String errorMsg = _cleanErrorMessage(
        response.body,
        'Failed to generate Stripe onboarding link.',
      );
      Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      isOnboardingLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Opens Stripe Express dashboard via POST /event/connect/dashboard/
  Future<void> openDashboard() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to view your payout dashboard.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isDashboardLoading.value = true;
    try {
      final response = await _apiService.getConnectDashboardUrl(token);
      isDashboardLoading.value = false;

      if (response.status.isOk && response.body != null && response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        final String? dashboardUrl =
            body['dashboard_url']?.toString() ??
            body['url']?.toString() ??
            body['login_link']?.toString() ??
            body['stripe_url']?.toString() ??
            body['link']?.toString();

        if (dashboardUrl != null && dashboardUrl.isNotEmpty) {
          await _openBrowserUrl(dashboardUrl, isDashboard: true);
          return;
        }
      }

      if (response.statusCode == 404) {
        await _showBackendNotReadyDialog(
          title: 'Dashboard Endpoint Pending',
          message:
              'The /event/connect/dashboard/ endpoint is not yet live on the server.\n\nWould you like to test the In-App Dashboard flow using the sample Stripe URL?',
          sampleUrl:
              'https://connect.stripe.com/express/acct_1UIK2TAbS2etFrSE/7tifHrT95PiN',
          isDashboard: true,
        );
        return;
      }

      final String errorMsg = _cleanErrorMessage(
        response.body,
        'Failed to open Stripe dashboard.',
      );
      Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      isDashboardLoading.value = false;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Opens a URL using native In-App Browser Screen with automatic return_url interception
  Future<bool> _openBrowserUrl(String url, {required bool isDashboard}) async {
    dynamic result;
    try {
      result = await Get.to<dynamic>(
        () => StripeInAppBrowserScreen(
          initialUrl: url,
          title: isDashboard ? 'Stripe Payout Dashboard' : 'Stripe Bank Connection',
        ),
      );
    } catch (e) {
      debugPrint('StripeInAppBrowserScreen error: $e, falling back to launchUrl');
      try {
        final uri = Uri.parse(url);
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppBrowserView,
        );
        if (!launched) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      } catch (e2) {
        Get.snackbar('Error', 'Could not open browser: $e2');
        return false;
      }
    }

    // When the browser closes or returns to the app, refresh status automatically
    await fetchConnectStatus();

    // If Stripe webhook or sync needs a moment, check again after short delay
    if (status.value != null &&
        !status.value!.payoutsEnabled &&
        !status.value!.detailsSubmitted) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        fetchConnectStatus();
      });
    }

    if (!isDashboard && (status.value?.payoutsEnabled ?? false)) {
      Get.snackbar(
        'Payouts Active',
        'Your bank account was connected successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.15),
        colorText: Colors.black,
      );
      return true;
    } else if (!isDashboard && (status.value?.detailsSubmitted ?? false)) {
      Get.snackbar(
        'Verification In Progress',
        'Stripe is reviewing your bank account details.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withValues(alpha: 0.15),
        colorText: Colors.black,
      );
      return true;
    }
    return result == true;
  }

  Future<bool> _showBackendNotReadyDialog({
    required String title,
    required String message,
    required String sampleUrl,
    required bool isDashboard,
  }) async {
    bool? shouldTest = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFFF6FB6)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6FB6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Test In-App Browser',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldTest == true) {
      return await _openBrowserUrl(sampleUrl, isDashboard: isDashboard);
    }
    return false;
  }

  /// Claims / retries pending payouts via POST /event/connect/retry-pending/
  Future<void> retryPendingPayouts() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) return;

    isRetrying.value = true;
    try {
      final response = await _apiService.retryPendingPayouts(token);
      isRetrying.value = false;

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Pending earnings transfer initiated!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.15),
          colorText: Colors.black,
        );
        await fetchConnectStatus();
      } else {
        String errorMsg = 'Failed to retry pending payouts.';
        if (response.statusCode == 404) {
          errorMsg =
              'The /event/connect/retry-pending/ endpoint is pending backend deployment.';
        } else {
          errorMsg = _cleanErrorMessage(response.body, errorMsg);
        }
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isRetrying.value = false;
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Extracts and cleans error messages, stripping Stripe request ID prefixes like "Request req_xxx: "
  String _cleanErrorMessage(dynamic body, String defaultMsg) {
    if (body == null) return defaultMsg;
    String raw = '';
    if (body is Map) {
      if (body.containsKey('error')) {
        final err = body['error'];
        raw = err is Map ? (err['message'] ?? err.toString()) : err.toString();
      } else if (body.containsKey('detail')) {
        raw = body['detail'].toString();
      } else if (body.containsKey('message')) {
        raw = body['message'].toString();
      } else if (body.isNotEmpty) {
        final firstVal = body.values.first;
        if (firstVal is List && firstVal.isNotEmpty) {
          raw = firstVal.first.toString();
        } else {
          raw = firstVal.toString();
        }
      }
    } else if (body is String) {
      raw = body;
    }

    if (raw.trim().isEmpty) return defaultMsg;

    // Strip Stripe request ID prefix like "Request req_PoJ1dftsdzpjc7: "
    raw = raw
        .replaceFirst(RegExp(r'^Request\s+[^:]+:\s*', caseSensitive: false), '')
        .trim();

    return raw.isNotEmpty ? raw : defaultMsg;
  }
}
