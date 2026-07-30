import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../create_event/controller/schedule_event_controller.dart';

class SupportersScreen extends StatefulWidget {
  const SupportersScreen({super.key});

  @override
  State<SupportersScreen> createState() => _SupportersScreenState();
}

class _SupportersScreenState extends State<SupportersScreen> {
  final ApiService _apiService = Get.isRegistered<ApiService>()
      ? Get.find<ApiService>()
      : Get.put(ApiService());

  late final ScheduleEventController _eventController;
  List<dynamic> _supportersList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _eventController = Get.isRegistered<ScheduleEventController>()
        ? Get.find<ScheduleEventController>()
        : Get.put(ScheduleEventController());
    _fetchSupporters();
  }

  Future<void> _fetchSupporters() async {
    final fundraiserId = _eventController.fundraiserDetails['id'];
    if (fundraiserId == null) {
      setState(() {
        _error = 'Fundraiser details not found.';
        _isLoading = false;
      });
      return;
    }

    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _error = 'Authentication required.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getFundraiserSupporters(
        token,
        int.parse(fundraiserId.toString()),
      );

      if (response.status.isOk && response.body != null) {
        setState(() {
          _supportersList = response.body is List ? response.body : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load supporters.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 650.0 : double.infinity,
            ),
            child: Column(
              children: [
                // Custom Header Row
                Padding(
                  padding: isTablet
                      ? const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        )
                      : EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          size: isTablet ? 24.0 : 24.sp,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Supporters',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18.0 : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 48.0 : 48.w),
                    ],
                  ),
                ),
                // Supporters List or Loader/Error
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6FB6),
                          ),
                        )
                      : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 14.0 : 14.sp,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: isTablet ? 12.0 : 12.h),
                              ElevatedButton(
                                onPressed: _fetchSupporters,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6FB6),
                                ),
                                child: Text(
                                  'Retry',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _supportersList.isEmpty
                      ? Center(
                          child: Text(
                            'No supporters yet.',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 14.0 : 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchSupporters,
                          color: const Color(0xFFFF6FB6),
                          child: ListView.separated(
                            padding: isTablet
                                ? const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  )
                                : EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                    vertical: 12.h,
                                  ),
                            itemCount: _supportersList.length,
                            separatorBuilder: (context, index) => Divider(
                              height: isTablet ? 24.0 : 24.h,
                              thickness: 1,
                              color: Colors.grey.shade100,
                            ),
                            itemBuilder: (context, index) {
                              final supporter =
                                  _supportersList[index]
                                      as Map<String, dynamic>;
                              final name =
                                  supporter['name']?.toString() ?? 'Anonymous';
                              final email =
                                  supporter['email']?.toString() ?? '';
                              final rawImg = supporter['image']?.toString();
                              final String avatarUrl =
                                  ApiService.formatImageUrl(rawImg);
                              final amountVal =
                                  supporter['total_purchased_amount'];
                              final double amount = amountVal != null
                                  ? double.tryParse(amountVal.toString()) ?? 0.0
                                  : 0.0;

                              final double avatarSize = isTablet ? 48.0 : 48.w;

                              return Row(
                                children: [
                                  // Avatar with fallback and loading state
                                  ClipOval(
                                    child: avatarUrl.isNotEmpty
                                        ? Image.network(
                                            avatarUrl,
                                            width: avatarSize,
                                            height: avatarSize,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: avatarSize,
                                                    height: avatarSize,
                                                    color: const Color(
                                                      0xFFF1F1F5,
                                                    ),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black26,
                                                      size: isTablet
                                                          ? 24.0
                                                          : 24.sp,
                                                    ),
                                                  );
                                                },
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    width: avatarSize,
                                                    height: avatarSize,
                                                    color: const Color(
                                                      0xFFF1F1F5,
                                                    ),
                                                    child: Center(
                                                      child: SizedBox(
                                                        width: isTablet
                                                            ? 18.0
                                                            : 18.w,
                                                        height: isTablet
                                                            ? 18.0
                                                            : 18.w,
                                                        child: const CircularProgressIndicator(
                                                          strokeWidth: 1.5,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(Colors.black26),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            width: avatarSize,
                                            height: avatarSize,
                                            color: const Color(0xFFF1F1F5),
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.black26,
                                              size: isTablet ? 24.0 : 24.sp,
                                            ),
                                          ),
                                  ),
                                  SizedBox(width: isTablet ? 16.0 : 16.w),
                                  // Name and Email
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: GoogleFonts.poppins(
                                            fontSize: isTablet ? 14.0 : 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF1A1A2E),
                                          ),
                                        ),
                                        if (email.isNotEmpty) ...[
                                          SizedBox(
                                            height: isTablet ? 2.0 : 2.h,
                                          ),
                                          Text(
                                            email,
                                            style: GoogleFonts.poppins(
                                              fontSize: isTablet ? 11.0 : 11.sp,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  // Amount Raised
                                  Text(
                                    '\$${amount.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 13.0 : 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
