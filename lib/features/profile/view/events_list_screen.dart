import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';

class EventsListScreen extends StatefulWidget {
  final bool isEmbedded;
  const EventsListScreen({super.key, this.isEmbedded = false});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  int _selectedTab = 0; // 0 = Active, 1 = History
  bool _isLoading = true;
  List<dynamic> _activeEvents = [];
  List<dynamic> _historyEvents = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Authentication token not found. Please log in again.';
        });
        return;
      }

      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());

      // Fetch active events
      final activeResponse = await apiService.getMyEvents(token);
      // Fetch history events
      final historyResponse = await apiService.getMyEventsHistory(token);

      if (activeResponse.status.isOk && historyResponse.status.isOk) {
        setState(() {
          _activeEvents = activeResponse.body is List
              ? activeResponse.body
              : [];
          _historyEvents = historyResponse.body is List
              ? historyResponse.body
              : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load events from server.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  String _formatDateRange(String startStr, String endStr) {
    try {
      final start = DateTime.parse(startStr).toLocal();
      final end = DateTime.parse(endStr).toLocal();
      final formatter = DateFormat('MMM dd, yyyy');
      return '${formatter.format(start)} - ${formatter.format(end)}';
    } catch (_) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsToShow = _selectedTab == 0 ? _activeEvents : _historyEvents;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600.0 : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20.0 : 20.w,
                vertical: isTablet ? 12.0 : 12.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      if (!widget.isEmbedded)
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                          color: const Color(0xFF1A1A2E),
                        ),
                      Expanded(
                        child: Align(
                          alignment: widget.isEmbedded
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: Text(
                            'Events',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18.0 : 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                      ),
                      if (!widget.isEmbedded)
                        SizedBox(width: isTablet ? 40.0 : 40.w),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16.0 : 16.h),

                  // Custom Tab/Segment Selector
                  Row(
                    children: [
                      _buildTabButton('Active Events', 0, isTablet),
                      SizedBox(width: isTablet ? 12.0 : 12.w),
                      _buildTabButton('History', 1, isTablet),
                    ],
                  ),
                  SizedBox(height: isTablet ? 20.0 : 20.h),

                  // Content Area
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A1A2E),
                            ),
                          )
                        : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: isTablet ? 48.0 : 48.sp,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(height: isTablet ? 12.0 : 12.h),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 14.0 : 14.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 16.0 : 16.h),
                                ElevatedButton(
                                  onPressed: _fetchEvents,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A1A2E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        isTablet ? 20.0 : 20.r,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 12.0 : 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : eventsToShow.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_note_outlined,
                                  size: isTablet ? 64.0 : 64.sp,
                                  color: Colors.black12,
                                ),
                                SizedBox(height: isTablet ? 12.0 : 12.h),
                                Text(
                                  _selectedTab == 0
                                      ? 'No active events found.'
                                      : 'No history events found.',
                                  style: GoogleFonts.poppins(
                                    fontSize: isTablet ? 14.0 : 14.sp,
                                    color: Colors.black38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchEvents,
                            color: const Color(0xFF1A1A2E),
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: eventsToShow.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: isTablet ? 12.0 : 12.h),
                              itemBuilder: (context, index) {
                                final event = eventsToShow[index];
                                final creator =
                                    event['creator'] as Map<String, dynamic>?;
                                var imagePath = '';
                                if (creator != null &&
                                    creator['image'] != null &&
                                    creator['image'].toString().isNotEmpty) {
                                  final img = creator['image'].toString();
                                  imagePath = img.startsWith('/')
                                      ? '${ApiService.defaultBaseUrl}$img'
                                      : img;
                                }

                                return _EventItem(
                                  imagePath: imagePath,
                                  title:
                                      event['name']?.toString() ?? 'Unnamed Event',
                                  date: _formatDateRange(
                                    event['start_date']?.toString() ?? '',
                                    event['end_date']?.toString() ?? '',
                                  ),
                                  status: event['status']?.toString() ?? 'Active',
                                  totalAchieved:
                                      double.tryParse(
                                        event['total_achieved']?.toString() ?? '0',
                                      ) ??
                                      0.0,
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
      ),
    );
  }

  Widget _buildTabButton(String title, int index, bool isTablet) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 18.0 : 18.w,
          vertical: isTablet ? 8.0 : 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A2E) : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(isTablet ? 20.0 : 20.r),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTablet ? 12.0 : 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String status;
  final double totalAchieved;

  const _EventItem({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.status,
    required this.totalAchieved,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Container(
      padding: EdgeInsets.all(isTablet ? 12.0 : 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16.0 : 16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEDEDF2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(isTablet ? 12.0 : 12.r),
            child: imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    width: isTablet ? 54.0 : 54.w,
                    height: isTablet ? 54.0 : 54.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/placeholder/homescreengetstarted1.png',
                      width: isTablet ? 54.0 : 54.w,
                      height: isTablet ? 54.0 : 54.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/placeholder/homescreengetstarted1.png',
                    width: isTablet ? 54.0 : 54.w,
                    height: isTablet ? 54.0 : 54.w,
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(width: isTablet ? 12.0 : 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 8.0 : 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8.0 : 8.w,
                        vertical: isTablet ? 3.0 : 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: status.toLowerCase() == 'completed'
                            ? const Color(0xFFE8F5E9)
                            : status.toLowerCase() == 'upcoming'
                            ? const Color(0xFFE3F2FD)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(isTablet ? 12.0 : 12.r),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 9.0 : 9.sp,
                          fontWeight: FontWeight.w600,
                          color: status.toLowerCase() == 'completed'
                              ? const Color(0xFF2E7D32)
                              : status.toLowerCase() == 'upcoming'
                              ? const Color(0xFF1565C0)
                              : const Color(0xFFEF6C00),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 6.0 : 6.h),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 10.5 : 10.5.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: isTablet ? 4.0 : 4.h),
                Text(
                  'Total Achieved: \$${totalAchieved.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 11.0 : 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
