class PolicyData {
  String policyType;
  double percentageChange;
  String policyTarget;
  String timeFrame;

  PolicyData({
    required this.policyType,
    required this.percentageChange,
    required this.policyTarget,
    required this.timeFrame,
  });

  Map<String, dynamic> toJson() {
    return {
      'policy_type': policyType,
      'percentage_change': percentageChange,
      'policy_target': policyTarget,
      'time_frame': timeFrame,
    };
  }
}
