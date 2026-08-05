import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final bool isEmbedded;
  const PrivacyPolicyScreen({super.key, this.isEmbedded = false});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  String _policyText = '';

  @override
  void initState() {
    super.initState();
    _fetchPrivacyPolicy();
  }

  Future<void> _fetchPrivacyPolicy() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getPrivacyPolicy();

      if (response.status.isOk && response.body != null) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(response.body);
        final String rawDescription = data['description']?.toString() ?? '';
        setState(() {
          _policyText = _parseHtmlString(rawDescription);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load Privacy Policy. (Code: ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred while loading. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _parseHtmlString(String html) {
    String result = html;

    // Replace HTML line breaks with newlines
    result = result.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Replace paragraph tags
    result = result.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n');
    result = result.replaceAll(RegExp(r'<p>', caseSensitive: false), '');

    // Strip other HTML tags
    result = result.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode HTML entities
    result = result
        .replaceAll('&amp;#39;', "'")
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;quot;', '"')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;amp;', '&')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ');

    // Normalize newlines
    result = result.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Clean up excessive consecutive newlines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return result.trim();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !widget.isEmbedded,
        leading: widget.isEmbedded
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: const Color(0xFF1A1A2E),
                  size: isTablet ? 20.0 : 20.sp,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16.0 : 16.sp,
          ),
        ),
        centerTitle: !widget.isEmbedded,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 650.0 : double.infinity,
          ),
          child: _buildBody(isTablet),
        ),
      ),
    );
  }

  Widget _buildBody(bool isTablet) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6FB6)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 48.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _fetchPrivacyPolicy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6FB6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20.0 : 20.w,
        vertical: isTablet ? 16.0 : 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 20.0 : 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          SizedBox(height: isTablet ? 8.0 : 8.h),
          Text(
            'Last Updated: August 2026',
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 12.0 : 12.sp,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: isTablet ? 20.0 : 20.h),
          Text(
            _policyText,
            style: GoogleFonts.poppins(
              fontSize: isTablet ? 13.0 : 13.sp,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
          SizedBox(height: isTablet ? 30.0 : 30.h),
        ],
      ),
    );
  }
}
