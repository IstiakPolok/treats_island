import 'package:flutter/material.dart';
import '../../controller/schedule_event_controller.dart';
import 'shop_created_view.dart';
import 'shop_empty_view.dart';

class ShopTabView extends StatelessWidget {
  final ScheduleEventController controller;
  final Map<String, dynamic>? fundraiser;
  final VoidCallback onShareTap;
  final VoidCallback onRefresh;

  const ShopTabView({
    super.key,
    required this.controller,
    required this.fundraiser,
    required this.onShareTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final String? name = fundraiser?['name']?.toString();
    final bool hasName =
        name != null && name.trim().isNotEmpty && name != 'null';

    if (hasName) {
      return ShopCreatedView(
        controller: controller,
        fundraiser: fundraiser,
        onShareTap: onShareTap,
        onRefresh: onRefresh,
      );
    }

    return const ShopEmptyView();
  }
}
