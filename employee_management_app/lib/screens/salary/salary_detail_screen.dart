import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/salary_provider.dart';

class SalaryDetailScreen extends StatefulWidget {
  static const routeName = '/salary-detail';

  @override
  _SalaryDetailScreenState createState() => _SalaryDetailScreenState();
}

class _SalaryDetailScreenState extends State<SalaryDetailScreen> {
  var _isInit = true;
  var _isLoading = false;
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
  );

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final departmentId = ModalRoute.of(context)!.settings.arguments as int;

      Provider.of<SalaryProvider>(
        context,
        listen: false,
      ).fetchDepartmentSalaryDetail(departmentId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });

      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final salaryProvider = Provider.of<SalaryProvider>(context);
    final departmentDetail = salaryProvider.selectedDepartmentDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text(departmentDetail?.departmentName ?? 'Department Salary'),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : departmentDetail == null
              ? Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              departmentDetail.departmentName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Employees:'),
                                Text(
                                  departmentDetail.employees.length.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Salary:'),
                                Text(
                                  currencyFormatter.format(
                                    departmentDetail.totalSalary,
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Average Salary:'),
                                Text(
                                  currencyFormatter.format(
                                    departmentDetail.totalSalary /
                                        departmentDetail.employees.length,
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Employee Salary Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: departmentDetail.employees.length,
                      itemBuilder:
                          (ctx, i) => Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(departmentDetail.employees[i].name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(departmentDetail.employees[i].position),
                                ],
                              ),
                              trailing: Text(
                                currencyFormatter.format(
                                  departmentDetail.employees[i].salary,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}
