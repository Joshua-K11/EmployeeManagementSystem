import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/employees/employee_list_screen.dart';
import '../screens/departments/department_list_screen.dart';
import '../screens/salary/salary_summary_screen.dart';
import '../screens/salary/salary_recommendation_screen.dart';
import '../screens/analytics/analytics_dashboard_screen.dart';
import '../screens/analytics/turnover_prediction_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/auth/login_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('Menu'), automaticallyImplyLeading: false),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Employees'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(EmployeeListScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Departments'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(DepartmentListScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Salary'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(SalarySummaryScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Analytics Dashboard'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AnalyticsDashboardScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.trending_down),
            title: Text('Turnover Prediction'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(TurnoverPredictionScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.recommend),
            title: Text('Salary Recommendations'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(SalaryRecommendationScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Attendance'),
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AttendanceScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
