class Employee {
  final int id;
  final String name;
  final String email;
  final String position;
  final int departmentId;
  final String departmentName;
  final double salary;
  final String phoneNumber;
  final String address;
  final String joiningDate;
  final String? profileImage;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.position,
    required this.departmentId,
    required this.departmentName,
    required this.salary,
    required this.phoneNumber,
    required this.address,
    required this.joiningDate,
    this.profileImage,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      departmentId: json['department_id'],
      departmentName: json['department']['name'],
      salary: double.parse(json['salary'].toString()),
      phoneNumber: json['phone_number'],
      address: json['address'],
      joiningDate: json['joining_date'],
      profileImage: json['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'position': position,
      'department_id': departmentId,
      'salary': salary,
      'phone_number': phoneNumber,
      'address': address,
      'joining_date': joiningDate,
    };
  }
}
