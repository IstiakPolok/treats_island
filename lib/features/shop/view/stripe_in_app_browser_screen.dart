import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeInAppBrowserScreen extends StatefulWidget {
  final String initialUrl;
  final String title;

  const StripeInAppBrowserScreen({
    super.key,
    required this.initialUrl,
    this.title = 'Stripe Payout Setup',
  });

  @override
  State<StripeInAppBrowserScreen> createState() =>
      _StripeInAppBrowserScreenState();
}

class _StripeInAppBrowserScreenState extends State<StripeInAppBrowserScreen> {
  WebViewController? _controller;
  int _progress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasPopped = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _checkForReturnUrl(String url) {
    if (_hasPopped) return;
    if (_isReturnUrl(url)) {
      _hasPopped = true;
      debugPrint('=== STRIPE RETURN URL DETECTED: $url ===');
      debugPrint('Returning to Treats Island app and refreshing payout status...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop(true);
        } else {
          Get.back(result: true);
        }
      });
    } else if (_isRefreshUrl(url)) {
      _hasPopped = true;
      debugPrint('=== STRIPE REFRESH URL DETECTED: $url ===');
      debugPrint('Returning to Treats Island app...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop(false);
        } else {
          Get.back(result: false);
        }
      });
    }
  }

  bool _isReturnUrl(String url) {
    try {
      final decoded = Uri.decodeFull(url).toLowerCase();
      return decoded.contains('treatsislandgo.com/payout/return') ||
          decoded.contains('/payout/return') ||
          decoded.contains('treatsisland://payout/return') ||
          decoded.contains('treatsislandgo://payout/return') ||
          decoded.contains('treatsisland://return');
    } catch (_) {
      final lower = url.toLowerCase();
      return lower.contains('treatsislandgo.com/payout/return') ||
          lower.contains('/payout/return');
    }
  }

  bool _isRefreshUrl(String url) {
    try {
      final decoded = Uri.decodeFull(url).toLowerCase();
      return decoded.contains('treatsislandgo.com/payout/refresh') ||
          decoded.contains('/payout/refresh') ||
          decoded.contains('treatsisland://payout/refresh') ||
          decoded.contains('treatsislandgo://payout/refresh') ||
          decoded.contains('treatsisland://refresh');
    } catch (_) {
      final lower = url.toLowerCase();
      return lower.contains('treatsislandgo.com/payout/refresh') ||
          lower.contains('/payout/refresh');
    }
  }

  void _initWebView() {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _progress = progress;
                  _isLoading = progress < 100;
                });
              }
            },
            onPageStarted: (String url) {
              debugPrint('=== STRIPE WEBVIEW STARTED: $url ===');
              _checkForReturnUrl(url);
            },
            onPageFinished: (String url) {
              debugPrint('=== STRIPE WEBVIEW FINISHED: $url ===');
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              _checkForReturnUrl(url);
            },
            onUrlChange: (UrlChange change) {
              final url = change.url;
              if (url != null) {
                debugPrint('=== STRIPE WEBVIEW URL CHANGE: $url ===');
                _checkForReturnUrl(url);
              }
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint(
                '=== STRIPE WEBVIEW ERROR: ${error.errorCode} - ${error.description} ===',
              );
              if (error.isForMainFrame ?? true) {
                if (mounted) {
                  setState(() {
                    _hasError = true;
                    _errorMessage = error.description;
                  });
                }
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              debugPrint('=== STRIPE NAVIGATION REQUEST: ${request.url} ===');
              if (_isReturnUrl(request.url) || _isRefreshUrl(request.url)) {
                _checkForReturnUrl(request.url);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        );

      controller.loadRequest(Uri.parse(widget.initialUrl));
      setState(() {
        _controller = controller;
      });
    } catch (e) {
      debugPrint('WebView initialization error: $e');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _openExternalFallback() async {
    try {
      await launchUrl(
        Uri.parse(widget.initialUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not open browser: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A1A2E)),
          onPressed: () => Get.back(result: false),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: isTablet ? 14.0 : 14.sp,
                color: const Color(0xFF2E7D32),
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 15.0 : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2.0),
                child: LinearProgressIndicator(
                  value: _progress > 0 ? _progress / 100.0 : null,
                  backgroundColor: const Color(0xFFF1F1F5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF6FB6),
                  ),
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (_controller != null && !_hasError)
              WebViewWidget(controller: _controller!)
            else
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_browser_rounded,
                        size: 52.sp,
                        color: const Color(0xFFFF6FB6),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        'Complete in Browser',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 17.0 : 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _errorMessage.isNotEmpty
                            ? 'Browser notice: $_errorMessage\n\nPlease complete verification in your browser.'
                            : 'Open Stripe verification in your browser. When finished, return to the app to view your updated status.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12.5 : 12.5.sp,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 22.h),
                      ElevatedButton.icon(
                        onPressed: _openExternalFallback,
                        icon: const Icon(Icons.launch, color: Colors.white),
                        label: Text(
                          'Open Stripe Setup',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6FB6),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text(
                          "I've completed setup",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_isLoading && _controller != null && !_hasError)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.6),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6FB6),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
