import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/turnover_provider.dart';
import '../../widgets/app_drawer.dart';

class TurnoverPredictionScreen extends StatefulWidget {
  static const routeName = '/turnover-prediction';

  @override
  _TurnoverPredictionScreenState createState() =>
      _TurnoverPredictionScreenState();
}

class _TurnoverPredictionScreenState extends State<TurnoverPredictionScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TurnoverProvider>(context).fetchTurnoverPredictions().then((
        _,
      ) {
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
    final turnoverProvider = Provider.of<TurnoverProvider>(context);
    final predictions = turnoverProvider.predictions;

    return Scaffold(
      appBar: AppBar(title: Text('Turnover Risk Prediction')),
      drawer: AppDrawer(),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : predictions.isEmpty
              ? Center(
                child: Text(
                  'No turnover predictions available.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : Column(
                children: [
                  Container(
                    color: Colors.blue.withOpacity(0.1),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This screen shows employees with potential turnover risk. Take action to retain valuable team members.',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: predictions.length,
                      itemBuilder: (ctx, i) {
                        final prediction = predictions[i];
                        Color riskColor;

                        if (prediction.riskLevel == 'High') {
                          riskColor = Colors.red;
                        } else if (prediction.riskLevel == 'Medium') {
                          riskColor = Colors.orange;
                        } else {
                          riskColor = Colors.green;
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ExpansionTile(
                            title: Text(
                              prediction.employeeName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: riskColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: riskColor),
                                  ),
                                  child: Text(
                                    '${prediction.riskLevel} Risk',
                                    style: TextStyle(
                                      color: riskColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Score: ${(prediction.riskScore * 100).toInt()}%',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: riskColor,
                              child: Text(
                                '${(prediction.riskScore * 100).toInt()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Risk Factors:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ...prediction.riskFactors.map(
                                      (factor) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_right, size: 16),
                                            SizedBox(width: 4),
                                            Expanded(child: Text(factor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Text(
                                      'Recommended Action:',
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
                                      child: Text(prediction.recommendedAction),
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
