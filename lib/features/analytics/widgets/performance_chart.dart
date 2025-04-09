import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import '../../../config/themes/app_theme.dart';
// import '../../../services/localization_service.dart'; // Commenting out due to missing file
import '../../../core/providers/settings_provider.dart';

class PerformanceChartProgress extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final String valueUnit;
  final Color? lineColor;
  final double? maxY;
  final bool showAverageLine;

  const PerformanceChartProgress({
    super.key,
    required this.data,
    required this.title,
    required this.valueUnit,
    this.lineColor,
    this.maxY,
    this.showAverageLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    final chartColor = lineColor ?? theme.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            title, // Removed localization due to missing service
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        _buildChartContainer(theme, chartColor, settings), // Removed isRTL
      ],
    );
  }

  Widget _buildChartContainer(
    ThemeData theme,
    Color chartColor,
    SettingsProvider settings,
  ) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: data.isEmpty
          ? Center(
              child: Text(
                'No data available', // Removed localization due to missing service
                style: theme.textTheme.bodyLarge,
              ),
            )
          : LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.dividerColor,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: _buildTitlesData(settings), // Removed isRTL
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: theme.dividerColor),
                ),
                minX: 0,
                maxX: data.length > 1 ? (data.length - 1).toDouble() : 1,
                minY: 0,
                maxY: _calculateMaxY(),
                lineBarsData: _buildChartLines(chartColor, theme),
                lineTouchData: _buildTouchData(settings),
              ),
            ),
    );
  }

  FlTitlesData _buildTitlesData(SettingsProvider settings) {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 24,
          getTitlesWidget: (value, meta) => _buildDateTitle(value, meta), // Added meta argument
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          getTitlesWidget: (value, meta) => _buildValueTitle(value, settings, meta), // Added meta argument
        ),
      ),
    );
  }

  Widget _buildDateTitle(double value, TitleMeta meta) { // Added meta parameter
    final index = value.toInt();
    if (index < 0 || index >= data.length) return const SizedBox.shrink();
    
    final date = data[index]['date'] as DateTime;
    return SideTitleWidget(
      // axisSide: AxisSide.bottom, // Removed due to undefined parameter
      meta: meta,
      child: Text(
        DateFormat('MMM d').format(date),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _buildValueTitle(double value, SettingsProvider settings, TitleMeta meta) { // Added meta parameter
    return SideTitleWidget(
      // axisSide: AxisSide.left, // Removed due to undefined parameter
      meta: meta,
      child: Text(
        '${value.toStringAsFixed(settings.weightUnit == 'kg' ? 1 : 0)} $valueUnit',
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  List<LineChartBarData> _buildChartLines(Color chartColor, ThemeData theme) {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['value'] as double);
    }).toList();

    final lines = [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: chartColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: data.length < 10,
          getDotPainter: (spot, percent, chart, index) => FlDotCirclePainter(
            radius: 3,
            color: chartColor,
            strokeWidth: 1,
            strokeColor: theme.cardColor,
          ),
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [chartColor.withOpacity(0.3), chartColor.withOpacity(0.1)],
            stops: const [0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ];

    if (showAverageLine) {
      final average = data.isEmpty 
          ? 0 
          : data.map((e) => e['value']).reduce((a, b) => a + b) / data.length;
      
      lines.add(
        LineChartBarData(
          spots: [FlSpot(0, average), FlSpot(data.length.toDouble() - 1, average)],
          color: chartColor.withOpacity(0.5),
          barWidth: 1,
          dashArray: [5, 5],
          isCurved: false,
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return lines;
  }

  LineTouchData _buildTouchData(SettingsProvider settings) {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        // tooltipBgColor: Colors.grey[800]!, // Removed to avoid errors
        getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
          final index = spot.x.toInt();
          final date = data[index]['date'] as DateTime;
          return LineTooltipItem(
            '${DateFormat.yMMMd().format(date)}\n'
            '${spot.y.toStringAsFixed(settings.weightUnit == 'kg' ? 1 : 0)} $valueUnit',
            TextStyle(color: AppTheme.darkTheme.primaryColor),
          );
        }).toList(),
      ),
    );
  }

  double _calculateMaxY() {
    if (maxY != null) return maxY!;
    if (data.isEmpty) return 10;

    final maxValue = data.map((e) => e['value'] as double).reduce(
      (a, b) => a > b ? a : b);
    return maxValue * 1.2;
  }
}
