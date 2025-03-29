import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/salary_provider.dart';
import '../../widgets/app_drawer.dart';
import 'salary_detail_screen.dart';

class SalarySummaryScreen extends StatefulWidget {
  static const routeName = '/salary-summary';

  @override
  _SalarySummaryScreenState createState() => _SalarySummaryScreenState();
}

class _SalarySummaryScreenState extends State<SalarySummaryScreen> {
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
      Provider.of<SalaryProvider>(context).fetchSalarySummaries().then((_) {
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
    final salarySummaries = salaryProvider.salarySummaries;

    return Scaffold(
      appBar: AppBar(title: Text('Salary Summary')),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : salarySummaries.isEmpty
              ? Center(
                child: Text(
                  'No salary data found.',
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
                              'Total Salary Overview',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Employees:'),
                                Text(
                                  salarySummaries
                                      .fold(
                                        0,
                                        (sum, item) => sum + item.employeeCount,
                                      )
                                      .toString(),
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
                                    salarySummaries.fold(
                                      0.0,
                                      (sum, item) => sum + item.totalSalary,
                                    ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: salarySummaries.length,
                      itemBuilder:
                          (ctx, i) => Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(salarySummaries[i].departmentName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${salarySummaries[i].employeeCount} employees',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Total: ${currencyFormatter.format(salarySummaries[i].totalSalary)}',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.show_chart,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Avg: ${currencyFormatter.format(salarySummaries[i].averageSalary)}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  SalaryDetailScreen.routeName,
                                  arguments: salarySummaries[i].departmentId,
                                );
                              },
                            ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}
