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
    return StripeConnectStatusModel(
      accountId: json['account_id']?.toString(),
      onboardingCompleted: json['onboarding_completed'] == true,
      payoutsEnabled: json['payouts_enabled'] == true,
      detailsSubmitted: json['details_submitted'] == true,
      totalCreatorEarnings: _parseDouble(json['total_creator_earnings']),
      pendingPayoutAmount: _parseDouble(json['pending_payout_amount']),
      transferredAmount: _parseDouble(json['transferred_amount']),
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
