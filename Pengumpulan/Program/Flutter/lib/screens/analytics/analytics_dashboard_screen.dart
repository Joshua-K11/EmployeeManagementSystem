import 'package:employee_management_app/models/analytics_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';


import '../../providers/analytics_provider.dart';
import '../../widgets/app_drawer.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  static const routeName = '/analytics-dashboard';

  @override
  _AnalyticsDashboardScreenState createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AnalyticsProvider>(context).fetchAnalytics().then((_) {
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
    final analyticsProvider = Provider.of<AnalyticsProvider>(context);
    final analytics = analyticsProvider.analytics;

    return Scaffold(
      appBar: AppBar(title: Text('Analytics Dashboard')),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : analytics == null
              ? Center(
                child: Text(
                  'No analytics data available.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Employee Distribution by Department',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 250,
                      child: _buildDepartmentPieChart(analytics),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Salary Distribution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 250,
                      child: _buildSalaryBarChart(analytics),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Employee Performance Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 250,
                      child: _buildPerformanceLineChart(analytics),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Employee Turnover Risk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildTurnoverRiskCards(analytics),
                  ],
                ),
              ),
    );
  }

  Widget _buildDepartmentPieChart(EmployeeAnalytics analytics) {
    final departmentData = analytics.employeesByDepartment;
    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];

    int i = 0;
    departmentData.forEach((department, count) {
      sections.add(
        PieChartSectionData(
          title: '$department\n$count',
          value: count.toDouble(),
          color: colors[i % colors.length],
          radius: 100,
          titleStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      );
      i++;
    });

    return PieChart(
      PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 2),
    );
  }

  Widget _buildSalaryBarChart(EmployeeAnalytics analytics) {
    final salaryData = analytics.salaryDistribution;
    final List<BarChartGroupData> barGroups = [];

    int i = 0;
    salaryData.forEach((range, percentage) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: percentage,
              color: Colors.blue,
              width: 20,
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
      i++;
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                List<String> ranges = salaryData.keys.toList();
                if (index >= 0 && index < ranges.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      ranges[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('${value.toInt()}%'),
                );
              },
              interval: 20,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }

  Widget _buildPerformanceLineChart(EmployeeAnalytics analytics) {
    final performanceData = analytics.performanceTrend;
    final List<FlSpot> spots = [];

    for (int i = 0; i < performanceData.length; i++) {
      spots.add(FlSpot(i.toDouble(), performanceData[i]['score'].toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < performanceData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      performanceData[index]['month'],
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(value.toInt().toString()),
                );
              },
              interval: 20,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnoverRiskCards(EmployeeAnalytics analytics) {
    final turnoverData = analytics.turnoverRisk;
    final sortedEmployees =
        turnoverData.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children:
          sortedEmployees.take(5).map((entry) {
            final riskPercentage = (entry.value * 100).toInt();
            Color riskColor;
            String riskLevel;

            if (riskPercentage >= 75) {
              riskColor = Colors.red;
              riskLevel = 'High';
            } else if (riskPercentage >= 50) {
              riskColor = Colors.orange;
              riskLevel = 'Medium';
            } else {
              riskColor = Colors.green;
              riskLevel = 'Low';
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(entry.key),
                subtitle: Text('Risk Level: $riskLevel'),
                trailing: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: riskColor.withOpacity(0.2),
                    border: Border.all(color: riskColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$riskPercentage%',
                      style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
