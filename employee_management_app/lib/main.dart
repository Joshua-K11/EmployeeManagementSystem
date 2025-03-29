import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/employee_provider.dart';
import './providers/department_provider.dart';
import './providers/salary_provider.dart';
import './providers/analytics_provider.dart';
import './providers/turnover_provider.dart';
import './providers/salary_recommendation_provider.dart';
import './providers/attendance_provider.dart';

import './screens/auth/login_screen.dart';
import './screens/auth/register_screen.dart';
import './screens/home/home_screen.dart';
import './screens/employees/employee_list_screen.dart';
import './screens/employees/employee_detail_screen.dart';
import './screens/employees/employee_form_screen.dart';
import './screens/departments/department_list_screen.dart';
import './screens/departments/department_form_screen.dart';
import './screens/salary/salary_summary_screen.dart';
import './screens/salary/salary_detail_screen.dart';
import './screens/salary/salary_recommendation_screen.dart';
import './screens/analytics/analytics_dashboard_screen.dart';
import './screens/analytics/turnover_prediction_screen.dart';
import './screens/attendance/attendance_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => EmployeeProvider()),
        ChangeNotifierProvider(create: (ctx) => DepartmentProvider()),
        ChangeNotifierProvider(create: (ctx) => SalaryProvider()),
        ChangeNotifierProvider(create: (ctx) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (ctx) => TurnoverProvider()),
        ChangeNotifierProvider(create: (ctx) => SalaryRecommendationProvider()),
        ChangeNotifierProvider(create: (ctx) => AttendanceProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder:
            (ctx, auth, _) => MaterialApp(
              title: 'Employee Management System',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                hintColor: Colors.amber,
                fontFamily: 'Lato',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home:
                  auth.isAuth
                      ? HomeScreen()
                      : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder:
                            (ctx, authResultSnapshot) =>
                                authResultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? Center(child: CircularProgressIndicator())
                                    : LoginScreen(),
                      ),
              routes: {
                HomeScreen.routeName: (ctx) => HomeScreen(),
                LoginScreen.routeName: (ctx) => LoginScreen(),
                RegisterScreen.routeName: (ctx) => RegisterScreen(),
                EmployeeListScreen.routeName: (ctx) => EmployeeListScreen(),
                EmployeeDetailScreen.routeName: (ctx) => EmployeeDetailScreen(),
                EmployeeFormScreen.routeName: (ctx) => EmployeeFormScreen(),
                DepartmentListScreen.routeName: (ctx) => DepartmentListScreen(),
                DepartmentFormScreen.routeName: (ctx) => DepartmentFormScreen(),
                SalarySummaryScreen.routeName: (ctx) => SalarySummaryScreen(),
                SalaryDetailScreen.routeName: (ctx) => SalaryDetailScreen(),
                SalaryRecommendationScreen.routeName:
                    (ctx) => SalaryRecommendationScreen(),
                AnalyticsDashboardScreen.routeName:
                    (ctx) => AnalyticsDashboardScreen(),
                TurnoverPredictionScreen.routeName:
                    (ctx) => TurnoverPredictionScreen(),
                AttendanceScreen.routeName: (ctx) => AttendanceScreen(),
              },
            ),
      ),
    );
  }
}
