import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import '../../../config/themes/app_theme.dart';
import '../../../core/providers/settings_provider.dart';
import '../providers/dashboard_provider.dart';

class ProgressChartWidget extends StatefulWidget {
  @override
  _ProgressChartWidgetState createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> {
  bool _showWeight = true; // Toggle between weight and sets

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    
    // Get data for the current week
    final weekData = dashboardProvider.getWeeklyChartData();
    
    // Create spots for the chart based on selected metric
    final List<FlSpot> spots = weekData.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = _showWeight 
          ? entry.value['totalWeight'] as double
          : (entry.value['totalSets'] as int).toDouble();
      return FlSpot(index, value);
    }).toList();
    
    // Calculate maximum Y value to set chart scale
    double maxY = 0;
    if (spots.isNotEmpty) {
      maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    }
    // Add some padding to the max Y value and ensure minimum of 10
    maxY = maxY > 0 ? (maxY * 1.2).ceilToDouble() : 10;
    
    return Container(
      height: 220,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius_l),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing_m,
            vertical: AppTheme.spacing_s,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart title and toggle button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showWeight 
                        ? 'Weight Lifted This Week (${settingsProvider.weightUnit})' 
                        : 'Sets Completed This Week',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                    icon: Icon(_showWeight ? Icons.repeat : Icons.fitness_center),
                    onPressed: () {
                      setState(() {
                        _showWeight = !_showWeight;
                      });
                    },
                    tooltip: 'Switch to ${_showWeight ? 'Sets' : 'Weight'}',
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing_s),
              
              // Single Chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Add padding to avoid overflow
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < weekData.length) {
                                final date = weekData[index]['date'] as DateTime;
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    '${date.day}/${date.month}',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text('${value.toInt()}'),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: const Color(0xff37434d), width: 1),
                      ),
                      minX: 0,
                      maxX: spots.length - 1.0,
                      minY: 0,
                      maxY: maxY,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 5,
                                color: Theme.of(context).primaryColor,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.3),
                              ],
                              stops: const [0.5],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Calculate a nice interval for the Y-axis based on the max value
  double _calculateInterval(double maxValue) {
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 500) return 100;
    return 200;
  }
}
