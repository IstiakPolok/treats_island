import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../controller/schedule_event_controller.dart';
import 'sheets/congrats_event_sheet.dart';
import 'sheets/edit_event_sheet.dart';
import 'sheets/event_checklist_sheet.dart';
import 'sheets/invite_team_sheet.dart';
import 'sheets/share_popup_store_sheet.dart';
import 'widgets/event_overview_header.dart';
import 'widgets/event_tab_view.dart';
import 'widgets/shop_tab_view.dart';

export 'widgets/video_player_screen.dart';

class EventOverviewScreen extends StatefulWidget {
  final ScheduleEventController controller;
  final bool showCongratsSheet;
  final bool showShopTab;

  const EventOverviewScreen({
    super.key,
    required this.controller,
    this.showCongratsSheet = false,
    this.showShopTab = false,
  });

  @override
  State<EventOverviewScreen> createState() => _EventOverviewScreenState();
}

class _EventOverviewScreenState extends State<EventOverviewScreen> {
  late bool _isShopSelected;
  String _organizerName = 'No Name added';
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _isShopSelected = widget.showShopTab;
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _loadOrganizerName();

    if (widget.showCongratsSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCongratsSheet();
        _confettiController.play();
      });
    } else if (widget.showShopTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }
  }

  Future<void> _loadOrganizerName() async {
    final name = await SharedPreferencesHelper.getName();
    if (name.isNotEmpty && mounted) {
      setState(() {
        _organizerName = name;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showCongratsSheet() {
    CongratsEventSheet.show(
      context: context,
      controller: widget.controller,
      organizerName: _organizerName,
      confettiController: _confettiController,
      onViewChecklist: _showChecklistSheet,
    );
  }

  void _showChecklistSheet() {
    EventChecklistSheet.show(
      context: context,
      controller: widget.controller,
      organizerName: _organizerName,
      onInviteTeamTap: _showInviteTeamSheet,
    );
  }

  void _showInviteTeamSheet() {
    InviteTeamSheet.show(context, widget.controller);
  }

  void _showEditEventSheet() {
    EditEventSheet.show(context, widget.controller);
  }

  Future<Map<String, dynamic>?> _getFundraiserDetails() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('GET FUNDRAISER: No access token found');
      return null;
    }

    Map<String, dynamic>? eventData =
        widget.controller.createdEvent['event'] as Map<String, dynamic>?;
    int? eventId =
        eventData?['id'] as int? ??
        widget.controller.createdEvent['id'] as int?;
    if (eventId == null) {
      debugPrint('GET FUNDRAISER: Fetching my events...');
      await widget.controller.fetchMyEvents();
      eventData =
          widget.controller.createdEvent['event'] as Map<String, dynamic>?;
      eventId =
          eventData?['id'] as int? ??
          widget.controller.createdEvent['id'] as int?;
    }

    if (eventId == null) {
      debugPrint('GET FUNDRAISER: Event ID is null after fetching my events');
      return null;
    }

    try {
      final apiService = Get.isRegistered<ApiService>()
          ? Get.find<ApiService>()
          : Get.put(ApiService());
      final response = await apiService.getFundraiser(token, eventId);

      if (response.status.isOk &&
          response.body != null &&
          response.body is Map) {
        final Map<String, dynamic> result = Map<String, dynamic>.from(
          response.body,
        );
        widget.controller.fundraiserDetails.assignAll(result);
        return result;
      }
    } catch (e) {
      debugPrint('GET FUNDRAISER EXCEPTION: $e');
    }
    return null;
  }

  Future<void> _handleSharePopupStore(Map<String, dynamic>? fundraiser) async {
    Map<String, dynamic>? data =
        fundraiser ??
        (widget.controller.fundraiserDetails.isNotEmpty
            ? widget.controller.fundraiserDetails
            : null);
    if (data == null || data.isEmpty) {
      data = await _getFundraiserDetails();
    }

    if (data != null && mounted) {
      SharePopupStoreSheet.show(context, data);
    } else {
      Get.snackbar(
        'Error',
        'Could not load Pop-up store details. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black.withAlpha(26),
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: Stack(
        children: [
          Column(
            children: [
              EventOverviewHeader(
                controller: widget.controller,
                isShopSelected: _isShopSelected,
                onTabSelected: (isShop) {
                  setState(() {
                    _isShopSelected = isShop;
                  });
                },
                onEditTap: _showEditEventSheet,
                onChecklistTap: _showChecklistSheet,
                onRefresh: () {
                  if (mounted) setState(() {});
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: isTablet
                      ? const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20.0,
                        )
                      : EdgeInsets.all(20.w),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 650.0),
                      child: FutureBuilder<Map<String, dynamic>?>(
                        future: _getFundraiserDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final fundraiser = snapshot.data;

                          if (_isShopSelected) {
                            return ShopTabView(
                              controller: widget.controller,
                              fundraiser: fundraiser,
                              onShareTap: () =>
                                  _handleSharePopupStore(fundraiser),
                              onRefresh: () => setState(() {}),
                            );
                          } else {
                            return EventTabView(
                              controller: widget.controller,
                              organizerName: _organizerName,
                              onInviteSellerTap: _showInviteTeamSheet,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFFF6FB6),
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
