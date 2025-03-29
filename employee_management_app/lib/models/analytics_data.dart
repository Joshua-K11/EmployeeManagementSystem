// lib/models/analytics_data.dart

class EmployeeAnalytics {
  final Map<String, int> employeesByDepartment;
  final Map<String, int> employeesByTenure;
  final Map<String, double> salaryDistribution;
  final List<Map<String, dynamic>> performanceTrend;
  final Map<String, double> turnoverRisk;

  EmployeeAnalytics({
    required this.employeesByDepartment,
    required this.employeesByTenure,
    required this.salaryDistribution,
    required this.performanceTrend,
    required this.turnoverRisk,
  });

  factory EmployeeAnalytics.fromJson(Map<String, dynamic> json) {
    // Parse employees by department
    Map<String, int> departmentData = {};
    if (json['employees_by_department'] != null) {
      json['employees_by_department'].forEach((key, value) {
        departmentData[key] = value;
      });
    }

    // Parse employee tenure
    Map<String, int> tenureData = {};
    if (json['employees_by_tenure'] != null) {
      json['employees_by_tenure'].forEach((key, value) {
        tenureData[key] = value;
      });
    }

    // Parse salary distribution
    Map<String, double> salaryData = {};
    if (json['salary_distribution'] != null) {
      json['salary_distribution'].forEach((key, value) {
        salaryData[key] = value is double ? value : value.toDouble();
      });
    }

    // Parse performance trend
    List<Map<String, dynamic>> performanceData = [];
    if (json['performance_trend'] != null) {
      for (var item in json['performance_trend']) {
        performanceData.add(Map<String, dynamic>.from(item));
      }
    }

    // Parse turnover risk
    Map<String, double> turnoverData = {};
    if (json['turnover_risk'] != null) {
      json['turnover_risk'].forEach((key, value) {
        turnoverData[key] = value is double ? value : value.toDouble();
      });
    }

    return EmployeeAnalytics(
      employeesByDepartment: departmentData,
      employeesByTenure: tenureData,
      salaryDistribution: salaryData,
      performanceTrend: performanceData,
      turnoverRisk: turnoverData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employees_by_department': employeesByDepartment,
      'employees_by_tenure': employeesByTenure,
      'salary_distribution': salaryDistribution,
      'performance_trend': performanceTrend,
      'turnover_risk': turnoverRisk,
    };
  }
}
