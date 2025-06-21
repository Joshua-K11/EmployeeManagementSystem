import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/salary_recommendation_provider.dart';
import '../../widgets/app_drawer.dart';

class SalaryRecommendationScreen extends StatefulWidget {
  static const routeName = '/salary-recommendation';

  @override
  _SalaryRecommendationScreenState createState() =>
      _SalaryRecommendationScreenState();
}

class _SalaryRecommendationScreenState
    extends State<SalaryRecommendationScreen> {
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
      Provider.of<SalaryRecommendationProvider>(
        context,
      ).fetchSalaryRecommendations().then((_) {
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
    final recommendationProvider = Provider.of<SalaryRecommendationProvider>(
      context,
    );
    final recommendations = recommendationProvider.recommendations;

    return Scaffold(
      appBar: AppBar(title: Text('Salary Recommendations')),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : recommendations.isEmpty
              ? Center(
                child: Text(
                  'No salary recommendations available.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Container(
                    color: Colors.green.withOpacity(0.1),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Based on performance, market trends, and tenure, here are the recommended salary adjustments.',
                            style: TextStyle(color: Colors.green[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recommendations.length,
                      itemBuilder: (ctx, i) {
                        final recommendation = recommendations[i];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ExpansionTile(
                            title: Text(
                              recommendation.employeeName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recommendation.position),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.green),
                                      ),
                                      child: Text(
                                        '+${recommendation.increasePercentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormatter.format(
                                    recommendation.recommendedSalary,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(
                                    recommendation.currentSalary,
                                  ),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reasons for Increase:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ...recommendation.reasonForIncrease.map(
                                      (reason) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(child: Text(reason)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Text(
                                      'Market Trend:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(recommendation.marketTrend),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            // Reject recommendation logic
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Recommendation rejected',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('Reject'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Approve recommendation logic
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Recommendation approved',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('Approve Increase'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
