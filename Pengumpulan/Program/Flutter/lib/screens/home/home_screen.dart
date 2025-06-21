import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/app_drawer.dart';
import '../employees/employee_list_screen.dart';
import '../departments/department_list_screen.dart';
import '../salary/salary_summary_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.name ?? "User"}!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Employee Management System',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildActionCard(
                  context,
                  Icons.people,
                  'Employees',
                  Colors.blue,
                  () {
                    Navigator.of(
                      context,
                    ).pushNamed(EmployeeListScreen.routeName);
                  },
                ),
                SizedBox(width: 16),
                _buildActionCard(
                  context,
                  Icons.business,
                  'Departments',
                  Colors.green,
                  () {
                    Navigator.of(
                      context,
                    ).pushNamed(DepartmentListScreen.routeName);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildActionCard(
                  context,
                  Icons.monetization_on,
                  'Salary',
                  Colors.orange,
                  () {
                    Navigator.of(
                      context,
                    ).pushNamed(SalarySummaryScreen.routeName);
                  },
                ),
                SizedBox(width: 16),
                _buildActionCard(
                  context,
                  Icons.settings,
                  'Settings',
                  Colors.purple,
                  () {
                    // Navigate to settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: color),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
