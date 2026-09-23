import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../controller/schedule_event_controller.dart';

class LeaderboardShopDetailsSheet {
  static void show(
    BuildContext context, {
    required String name,
    required double amount,
    required String avatarUrl,
    int supporters = 10,
    double? goal,
    Map<String, dynamic>? participant,
    String? shareLink,
    int? fundraiserId,
    List<dynamic>? supportersList,
    ScheduleEventController? controller,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (sheetContext) {
        return _LeaderboardShopDetailsContent(
          name: name,
          amount: amount,
          avatarUrl: avatarUrl,
          supporters: supporters,
          goal: goal,
          participant: participant,
          shareLink: shareLink,
          fundraiserId: fundraiserId,
          initialSupportersList: supportersList,
          controller: controller,
        );
      },
    );
  }
}

class _LeaderboardShopDetailsContent extends StatefulWidget {
  final String name;
  final double amount;
  final String avatarUrl;
  final int supporters;
  final double? goal;
  final Map<String, dynamic>? participant;
  final String? shareLink;
  final int? fundraiserId;
  final List<dynamic>? initialSupportersList;
  final ScheduleEventController? controller;

  const _LeaderboardShopDetailsContent({
    required this.name,
    required this.amount,
    required this.avatarUrl,
    required this.supporters,
    this.goal,
    this.participant,
    this.shareLink,
    this.fundraiserId,
    this.initialSupportersList,
    this.controller,
  });

  @override
  State<_LeaderboardShopDetailsContent> createState() =>
      _LeaderboardShopDetailsContentState();
}

class _LeaderboardShopDetailsContentState
    extends State<_LeaderboardShopDetailsContent> {
  List<dynamic> _supporters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initSupporters();
  }

  Future<void> _initSupporters() async {
    // 1. Check if supporters were passed directly
    if (widget.initialSupportersList != null &&
        widget.initialSupportersList!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _supporters = List.from(widget.initialSupportersList!);
          _isLoading = false;
        });
      }
      return;
    }

    // 2. Check participant object
    final p = widget.participant;
    if (p != null) {
      if (p['supporters'] is List && (p['supporters'] as List).isNotEmpty) {
        if (mounted) {
          setState(() {
            _supporters = List.from(p['supporters']);
            _isLoading = false;
          });
        }
        return;
      }
      if (p['supporters_list'] is List &&
          (p['supporters_list'] as List).isNotEmpty) {
        if (mounted) {
          setState(() {
            _supporters = List.from(p['supporters_list']);
            _isLoading = false;
          });
        }
        return;
      }
    }

    // 3. Try to fetch from API using fundraiserId
    int? fId = widget.fundraiserId;
    if (fId == null && p != null) {
      fId = int.tryParse(p['fundraiser_id']?.toString() ?? '') ??
          (p['fundraiser'] is Map
              ? int.tryParse(p['fundraiser']['id']?.toString() ?? '')
              : (p['fundraiser'] is int ? p['fundraiser'] as int : null)) ??
          (p['fundraiser_details'] is Map
              ? int.tryParse(p['fundraiser_details']['id']?.toString() ?? '')
              : null) ??
          int.tryParse(p['store_id']?.toString() ?? '') ??
          int.tryParse(p['popup_store_id']?.toString() ?? '') ??
          int.tryParse(p['shop_id']?.toString() ?? '');
    }

    ScheduleEventController? ctrl = widget.controller;
    if (ctrl == null && Get.isRegistered<ScheduleEventController>()) {
      ctrl = Get.find<ScheduleEventController>();
    }

    if (ctrl != null) {
      int? myFId = int.tryParse(ctrl.fundraiserDetails['id']?.toString() ?? '');

      // If fundraiserDetails is empty, attempt to load it using current event id
      if (myFId == null) {
        try {
          final token = await SharedPreferencesHelper.getAccessToken();
          final dynamic eventMap = ctrl.createdEvent['event'] ?? ctrl.createdEvent;
          final dynamic rawEventId = eventMap is Map ? eventMap['id'] : null;
          if (token != null && token.isNotEmpty && rawEventId != null) {
            final parsedEventId = int.tryParse(rawEventId.toString());
            if (parsedEventId != null) {
              final apiService = Get.isRegistered<ApiService>()
                  ? Get.find<ApiService>()
                  : Get.put(ApiService());
              final res = await apiService.getFundraiser(token, parsedEventId);
              if (res.status.isOk && res.body is Map) {
                ctrl.fundraiserDetails.assignAll(Map<String, dynamic>.from(res.body));
                myFId = int.tryParse(ctrl.fundraiserDetails['id']?.toString() ?? '');
              }
            }
          }
        } catch (e) {
          debugPrint('Error getting fundraiser details in sheet: $e');
        }
      }

      if (fId == null && myFId != null) {
        final myEmail = (await SharedPreferencesHelper.getEmail()).trim().toLowerCase();
        final myName = (await SharedPreferencesHelper.getName()).trim().toLowerCase();
        final pEmail = p?['email']?.toString().trim().toLowerCase() ?? '';
        final pName = (p?['full_name'] ?? p?['name'] ?? widget.name).toString().trim().toLowerCase();
        final storeName = ctrl.fundraiserDetails['name']?.toString().trim().toLowerCase() ?? '';

        final bool isCurrentUser = (myEmail.isNotEmpty && pEmail == myEmail) ||
            (myName.isNotEmpty && pName == myName) ||
            (storeName.isNotEmpty && (pName == storeName || widget.name.trim().toLowerCase() == storeName)) ||
            p?['is_mine'] == true ||
            p?['is_creator'] == true;

        if (isCurrentUser || fId == null) {
          fId = myFId;
        }
      }
    }

    debugPrint('LEADERBOARD DETAILS SHEET: Resolved fundraiserId = $fId');

    if (fId != null) {
      try {
        final token = await SharedPreferencesHelper.getAccessToken();
        if (token != null && token.isNotEmpty) {
          final apiService = Get.isRegistered<ApiService>()
              ? Get.find<ApiService>()
              : Get.put(ApiService());
          final response = await apiService.getFundraiserSupporters(token, fId);
          debugPrint('LEADERBOARD SUPPORTERS: status=${response.statusCode}, body=${response.body}');
          if (response.status.isOk && response.body != null) {
            dynamic data = response.body;
            if (data is String) {
              try {
                data = jsonDecode(data);
              } catch (e) {
                debugPrint('LEADERBOARD SUPPORTERS JSON Decode error: $e');
              }
            }

            List<dynamic> fetchedList = [];
            if (data is List) {
              fetchedList = List.from(data);
            } else if (data is Map) {
              if (data['results'] is List) {
                fetchedList = List.from(data['results']);
              } else if (data['supporters'] is List) {
                fetchedList = List.from(data['supporters']);
              } else if (data['data'] is List) {
                fetchedList = List.from(data['data']);
              }
            }

            if (mounted) {
              setState(() {
                _supporters = fetchedList;
                _isLoading = false;
              });
              return;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching supporters for fundraiser $fId: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVisitStore() async {
    String? url = widget.shareLink;
    final p = widget.participant;

    if (url == null || url.isEmpty) {
      if (p != null) {
        url = p['share_link']?.toString() ??
            p['store_link']?.toString() ??
            p['store_url']?.toString() ??
            p['popup_store']?.toString() ??
            p['url']?.toString();
        if (url == null && p['fundraiser'] is Map) {
          url = (p['fundraiser'] as Map)['share_link']?.toString();
        }
      }
    }

    if (url == null || url.isEmpty) {
      ScheduleEventController? ctrl = widget.controller;
      if (ctrl == null && Get.isRegistered<ScheduleEventController>()) {
        ctrl = Get.find<ScheduleEventController>();
      }
      if (ctrl != null) {
        final myFundraiser = ctrl.fundraiserDetails;
        if (myFundraiser.isNotEmpty) {
          url = myFundraiser['share_link']?.toString();
        }
      }
    }

    if (url != null && url.trim().isNotEmpty && url != 'null') {
      final uri = Uri.tryParse(url.trim());
      if (uri != null) {
        try {
          final launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (!launched) {
            Get.snackbar(
              'Error',
              'Could not open pop-up store ($url)',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black.withAlpha(26),
              colorText: Colors.black,
            );
          }
          return;
        } catch (e) {
          debugPrint('Launch URL Exception: $e');
          Get.snackbar(
            'Error',
            'Could not open link: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withAlpha(26),
            colorText: Colors.black,
          );
          return;
        }
      }
    }

    Get.snackbar(
      'Notice',
      'Pop-up store link is not available.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withAlpha(26),
      colorText: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double finalGoal = (widget.goal != null && widget.goal! > 0)
        ? widget.goal!
        : (widget.amount > 600 ? widget.amount * 1.5 : 1200);
    final double progress =
        finalGoal > 0 ? (widget.amount / finalGoal).clamp(0.0, 1.0) : 0.0;

    final displaySupportersCount = _supporters.isNotEmpty
        ? _supporters.length
        : widget.supporters;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
            child: Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  ClipOval(
                    child: widget.avatarUrl.isNotEmpty
                        ? Image.network(
                            widget.avatarUrl,
                            width: 70.w,
                            height: 70.w,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stackTrace) {
                              return Container(
                                width: 70.w,
                                height: 70.w,
                                color: const Color(0xFFF1F1F5),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                  size: 35.sp,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 70.w,
                            height: 70.w,
                            color: const Color(0xFFF1F1F5),
                            child: Icon(
                              Icons.person,
                              color: Colors.black26,
                              size: 35.sp,
                            ),
                          ),
                  ),
                  SizedBox(height: 12.h),
                  // Store Name
                  Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isTablet ? 17.0 : 17.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8.h,
                      backgroundColor: const Color(0xFFEFEFEF),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6FB6),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Goal & Supporters Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\$${widget.amount.toStringAsFixed(0)} ',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF6FB6),
                              ),
                            ),
                            TextSpan(
                              text: 'of ${finalGoal.toStringAsFixed(0)} goal',
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 13.0 : 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$displaySupportersCount supporters',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 13.0 : 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  SizedBox(height: 16.h),
                  // Supporters Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Supporters',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 15.0 : 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '$displaySupportersCount',
                          style: GoogleFonts.poppins(
                            fontSize: isTablet ? 11.0 : 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Supporters List Content
                  if (_isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (_supporters.isEmpty)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8FB),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 28.sp,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            displaySupportersCount > 0
                                ? '$displaySupportersCount supporters supported this store'
                                : 'No supporters yet',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 13.0 : 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Be the first to visit and support!',
                            style: GoogleFonts.poppins(
                              fontSize: isTablet ? 11.0 : 11.sp,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _supporters.length,
                      separatorBuilder: (ctx, idx) => Divider(
                        height: 16.h,
                        color: Colors.black.withValues(alpha: 0.04),
                      ),
                      itemBuilder: (ctx, idx) {
                        String sName = 'Anonymous Supporter';
                        String sAvatar = '';
                        double sAmount = 0.0;
                        int sOrders = 0;
                        String sEmail = '';

                        if (_supporters[idx] is Map) {
                          final m = _supporters[idx] as Map;
                          sName = m['name']?.toString() ??
                              m['full_name']?.toString() ??
                              m['supporter_name']?.toString() ??
                              'Anonymous Supporter';
                          sEmail = m['email']?.toString() ?? '';
                          sAvatar = ApiService.formatImageUrl(
                            m['image']?.toString() ??
                                m['avatar']?.toString() ??
                                '',
                          );
                          final rawAmt = m['total_purchased_amount'] ??
                              m['amount'] ??
                              m['achieved'] ??
                              m['contribution'];
                          sAmount = rawAmt != null
                              ? double.tryParse(rawAmt.toString()) ?? 0.0
                              : 0.0;
                          final rawOrders = m['total_orders'] ??
                              m['orders'] ??
                              m['order_count'];
                          sOrders = rawOrders != null
                              ? (int.tryParse(rawOrders.toString()) ?? 0)
                              : 0;
                        } else if (_supporters[idx] is String) {
                          sName = _supporters[idx].toString();
                        }

                        final String amountStr = sAmount % 1 == 0
                            ? '\$${sAmount.toInt()}'
                            : '\$${sAmount.toStringAsFixed(2)}';

                        return Row(
                          children: [
                            ClipOval(
                              child: sAvatar.isNotEmpty
                                  ? Image.network(
                                      sAvatar,
                                      width: isTablet ? 40.0 : 40.w,
                                      height: isTablet ? 40.0 : 40.w,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Container(
                                        width: isTablet ? 40.0 : 40.w,
                                        height: isTablet ? 40.0 : 40.w,
                                        color: const Color(0xFFF1F1F5),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.black26,
                                          size: 20.sp,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: isTablet ? 40.0 : 40.w,
                                      height: isTablet ? 40.0 : 40.w,
                                      color: const Color(0xFFF1F1F5),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.black26,
                                        size: 20.sp,
                                      ),
                                    ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sName,
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 13.5 : 13.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (sOrders > 0 || sEmail.isNotEmpty) ...[
                                    SizedBox(height: 2.h),
                                    Text(
                                      sOrders > 0
                                          ? '$sOrders ${sOrders == 1 ? 'order' : 'orders'}${sEmail.isNotEmpty ? ' • $sEmail' : ''}'
                                          : sEmail,
                                      style: GoogleFonts.poppins(
                                        fontSize: isTablet ? 11.0 : 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6FB6)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                amountStr,
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 13.0 : 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFF6FB6),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
          // Sticky Bottom "Visit pop-up store" Button
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _handleVisitStore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Visit pop-up store',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 15.0 : 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

