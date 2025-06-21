class SalarySummary {
  final int departmentId;
  final String departmentName;
  final int employeeCount;
  final double totalSalary;
  final double averageSalary;

  SalarySummary({
    required this.departmentId,
    required this.departmentName,
    required this.employeeCount,
    required this.totalSalary,
    required this.averageSalary,
  });

  factory SalarySummary.fromJson(Map<String, dynamic> json) {
    return SalarySummary(
      departmentId: json['department_id'],
      departmentName: json['department_name'],
      employeeCount: json['employee_count'],
      totalSalary: double.parse(json['total_salary'].toString()),
      averageSalary: double.parse(json['average_salary'].toString()),
    );
  }
}

class SalaryDetail {
  final int departmentId;
  final String departmentName;
  final List<EmployeeSalary> employees;
  final double totalSalary;

  SalaryDetail({
    required this.departmentId,
    required this.departmentName,
    required this.employees,
    required this.totalSalary,
  });

  factory SalaryDetail.fromJson(Map<String, dynamic> json) {
    List<EmployeeSalary> employeeList = [];
    for (var emp in json['employees']) {
      employeeList.add(EmployeeSalary.fromJson(emp));
    }

    return SalaryDetail(
      departmentId: json['department_id'],
      departmentName: json['department_name'],
      employees: employeeList,
      totalSalary: double.parse(json['total_salary'].toString()),
    );
  }
}

class EmployeeSalary {
  final int id;
  final String name;
  final String position;
  final double salary;

  EmployeeSalary({
    required this.id,
    required this.name,
    required this.position,
    required this.salary,
  });

  factory EmployeeSalary.fromJson(Map<String, dynamic> json) {
    return EmployeeSalary(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      salary: double.parse(json['salary'].toString()),
    );
  }
}
