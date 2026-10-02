class StripeConnectStatusModel {
  final String? accountId;
  final bool onboardingCompleted;
  final bool payoutsEnabled;
  final bool detailsSubmitted;
  final double totalCreatorEarnings;
  final double pendingPayoutAmount;
  final double transferredAmount;

  StripeConnectStatusModel({
    this.accountId,
    this.onboardingCompleted = false,
    required this.payoutsEnabled,
    this.detailsSubmitted = false,
    required this.totalCreatorEarnings,
    required this.pendingPayoutAmount,
    required this.transferredAmount,
  });

  factory StripeConnectStatusModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? earnings =
        json['earnings_summary'] is Map ? json['earnings_summary'] as Map<String, dynamic> : null;

    final String statusStr = (json['status'] ?? json['banking_status'] ?? json['banking_setup_status'] ?? '')
        .toString()
        .toLowerCase();
    final bool isStatusActive = statusStr == 'active' || statusStr == 'completed';

    return StripeConnectStatusModel(
      accountId: json['account_id']?.toString(),
      onboardingCompleted: json['onboarding_completed'] == true ||
          json['is_banking_setup'] == true ||
          json['banking_completed'] == true ||
          isStatusActive,
      payoutsEnabled: json['payouts_enabled'] == true ||
          json['banking_completed'] == true ||
          json['is_banking_setup'] == true ||
          isStatusActive,
      detailsSubmitted: json['details_submitted'] == true ||
          json['is_banking_setup'] == true ||
          isStatusActive,
      totalCreatorEarnings: _parseDouble(
        earnings?['total_creator_earnings'] ??
        earnings?['total_earnings'] ??
        earnings?['earnings'] ??
        json['total_creator_earnings'] ??
        json['total_earnings'] ??
        json['earnings'],
      ),
      pendingPayoutAmount: _parseDouble(
        earnings?['pending_payout_amount'] ??
        earnings?['pending_amount'] ??
        earnings?['pending_earnings'] ??
        earnings?['pending'] ??
        json['pending_payout_amount'] ??
        json['pending_amount'] ??
        json['pending_earnings'] ??
        json['pending'],
      ),
      transferredAmount: _parseDouble(
        earnings?['transferred_amount'] ??
        earnings?['transferred'] ??
        earnings?['paid_out'] ??
        json['transferred_amount'] ??
        json['transferred'] ??
        json['paid_out'],
      ),
    );
  }

  factory StripeConnectStatusModel.initial() {
    return StripeConnectStatusModel(
      accountId: null,
      onboardingCompleted: false,
      payoutsEnabled: false,
      detailsSubmitted: false,
      totalCreatorEarnings: 0.0,
      pendingPayoutAmount: 0.0,
      transferredAmount: 0.0,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'onboarding_completed': onboardingCompleted,
      'payouts_enabled': payoutsEnabled,
      'details_submitted': detailsSubmitted,
      'total_creator_earnings': totalCreatorEarnings,
      'pending_payout_amount': pendingPayoutAmount,
      'transferred_amount': transferredAmount,
    };
  }

  StripeConnectStatusModel copyWith({
    String? accountId,
    bool? onboardingCompleted,
    bool? payoutsEnabled,
    bool? detailsSubmitted,
    double? totalCreatorEarnings,
    double? pendingPayoutAmount,
    double? transferredAmount,
  }) {
    return StripeConnectStatusModel(
      accountId: accountId ?? this.accountId,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      payoutsEnabled: payoutsEnabled ?? this.payoutsEnabled,
      detailsSubmitted: detailsSubmitted ?? this.detailsSubmitted,
      totalCreatorEarnings: totalCreatorEarnings ?? this.totalCreatorEarnings,
      pendingPayoutAmount: pendingPayoutAmount ?? this.pendingPayoutAmount,
      transferredAmount: transferredAmount ?? this.transferredAmount,
    );
  }
}
