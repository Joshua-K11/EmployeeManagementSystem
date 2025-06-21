class TurnoverPrediction {
  final int employeeId;
  final String employeeName;
  final double riskScore;
  final List<String> riskFactors;
  final String riskLevel;
  final String recommendedAction;

  TurnoverPrediction({
    required this.employeeId,
    required this.employeeName,
    required this.riskScore,
    required this.riskFactors,
    required this.riskLevel,
    required this.recommendedAction,
  });

  factory TurnoverPrediction.fromJson(Map<String, dynamic> json) {
    return TurnoverPrediction(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      riskScore: json['risk_score'].toDouble(),
      riskFactors: List<String>.from(json['risk_factors']),
      riskLevel: json['risk_level'],
      recommendedAction: json['recommended_action'],
    );
  }
}
