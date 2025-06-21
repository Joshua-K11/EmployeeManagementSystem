class Attendance {
  final int id;
  final int employeeId;
  final String employeeName;
  final String date;
  final String checkInTime;
  final String? checkOutTime;
  final String status;
  final double? latitude;
  final double? longitude;
  final String? notes;

  Attendance({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.latitude,
    this.longitude,
    this.notes,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],
      date: json['date'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'],
      latitude:
          json['latitude'] != null
              ? double.parse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.parse(json['longitude'].toString())
              : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'date': date,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    };
  }
}
