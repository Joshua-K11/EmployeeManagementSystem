import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/attendance';

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  var _isInit = true;
  var _isLoading = false;
  final _notesController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AttendanceProvider>(context).fetchAttendances().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _showCheckInDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Check In'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you at your workplace and ready to start your day?'),
                SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ElevatedButton(
                child: Text('Check In'),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  try {
                    final user =
                        Provider.of<AuthProvider>(context, listen: false).user!;
                    await Provider.of<AttendanceProvider>(
                      context,
                      listen: false,
                    ).checkIn(
                      user.id,
                      _notesController.text.isEmpty
                          ? null
                          : _notesController.text,
                    );
                    _notesController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully checked in!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Check in failed: ${error.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showCheckOutDialog(int attendanceId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Check Out'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Are you done with your work for today?'),
                SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ElevatedButton(
                child: Text('Check Out'),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  try {
                    await Provider.of<AttendanceProvider>(
                      context,
                      listen: false,
                    ).checkOut(
                      attendanceId,
                      _notesController.text.isEmpty
                          ? null
                          : _notesController.text,
                    );
                    _notesController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully checked out!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Check out failed: ${error.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;
    final attendances = attendanceProvider.attendances;
    final todayAttendance = attendanceProvider.todayAttendance;
    final isCheckedIn = attendanceProvider.isCheckedIn;

    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    final now = DateTime.now();
    final today = dateFormat.format(now);
    final currentTime = timeFormat.format(now);

    return Scaffold(
      appBar: AppBar(title: Text('Attendance')),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          today,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (todayAttendance != null)
                    Card(
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Attendance',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Check In'),
                                    Text(
                                      todayAttendance.checkInTime,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Check Out'),
                                    Text(
                                      todayAttendance.checkOutTime ?? '-',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            todayAttendance.checkOutTime != null
                                                ? Colors.red
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                if (todayAttendance.checkOutTime == null)
                                  ElevatedButton(
                                    onPressed:
                                        () => _showCheckOutDialog(
                                          todayAttendance.id,
                                        ),
                                    child: Text('Check Out'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                            if (todayAttendance.notes != null) ...[
                              SizedBox(height: 8),
                              Text(
                                'Notes:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(todayAttendance.notes!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  if (!isCheckedIn && user != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ElevatedButton(
                        onPressed: _showCheckInDialog,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 8),
                              Text('CHECK IN', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Attendance History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        attendances.isEmpty
                            ? Center(
                              child: Text('No attendance records found.'),
                            )
                            : ListView.builder(
                              itemCount: attendances.length,
                              itemBuilder: (ctx, i) {
                                final attendance = attendances[i];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      DateFormat(
                                        'EEEE, dd MMMM yyyy',
                                      ).format(DateTime.parse(attendance.date)),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          Icons.login,
                                          size: 16,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(attendance.checkInTime),
                                        SizedBox(width: 16),
                                        if (attendance.checkOutTime !=
                                            null) ...[
                                          Icon(
                                            Icons.logout,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 4),
                                          Text(attendance.checkOutTime!),
                                        ],
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            attendance.status == 'Present'
                                                ? Colors.green.withOpacity(0.2)
                                                : attendance.status == 'Late'
                                                ? Colors.orange.withOpacity(0.2)
                                                : Colors.red.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        attendance.status,
                                        style: TextStyle(
                                          color:
                                              attendance.status == 'Present'
                                                  ? Colors.green
                                                  : attendance.status == 'Late'
                                                  ? Colors.orange
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
