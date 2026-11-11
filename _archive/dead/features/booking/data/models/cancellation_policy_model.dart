class CancellationPolicyModel {
  final DateTime? freeCancellationBefore;

  const CancellationPolicyModel({this.freeCancellationBefore});

  factory CancellationPolicyModel.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyModel(
      freeCancellationBefore: json['free_cancellation_before'] == null
          ? null
          : DateTime.parse(json['free_cancellation_before']),
    );
  }

  bool get isRefundable => freeCancellationBefore != null;
}
