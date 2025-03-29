class SalaryRecommendation {
  final int employeeId;
  final String employeeName;
  final String position;
  final double currentSalary;
  final double recommendedSalary;
  final double increasePercentage;
  final List<String> reasonForIncrease;
  final String marketTrend;

  SalaryRecommendation({
    required this.employeeId,
    required this.employeeName,
    required this.position,
    required this.currentSalary,
    required this.recommendedSalary,
    required this.increasePercentage,
    required this.reasonForIncrease,
    required this.marketTrend,
  });

  factory SalaryRecommendation.fromJson(Map<String, dynamic> json) {
    return SalaryRecommendation(
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      position: json['position'],
      currentSalary: double.parse(json['current_salary'].toString()),
      recommendedSalary: double.parse(json['recommended_salary'].toString()),
      increasePercentage: double.parse(json['increase_percentage'].toString()),
      reasonForIncrease: List<String>.from(json['reason_for_increase']),
      marketTrend: json['market_trend'],
    );
  }
}
