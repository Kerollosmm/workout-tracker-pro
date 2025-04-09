import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import 'package:workout_tracker/core/services/localization_service.dart';

import '../../../config/themes/app_theme.dart';

class MuscleGroupChartWidget extends StatelessWidget {
  final Map<String, int> muscleGroups;
  final Map<String, Color>? colors;
  final double chartRadius;
  final double legendFontSize;

  const MuscleGroupChartWidget({
    super.key,
    required this.muscleGroups,
    this.colors,
    this.chartRadius = 100,
    this.legendFontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colorMap = colors ?? AppTheme.muscleGroupColors;
    final theme = Theme.of(context);
    
    if (muscleGroups.isEmpty) {
      return Center(
        child: Text(
          'No workout data available'.tr,
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return Column(
      children: [
        _buildPieChart(colorMap, theme),
        const SizedBox(height: 16),
        _buildLegend(colorMap, theme),
      ],
    );
  }

  Widget _buildPieChart(Map<String, Color> colorMap, ThemeData theme) {
    return SizedBox(
      height: chartRadius * 2,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: chartRadius * 0.4,
          sections: _buildChartSections(colorMap),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(Map<String, Color> colorMap) {
    final total = muscleGroups.values.fold(0, (sum, count) => sum + count);
    
    return muscleGroups.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      
      return PieChartSectionData(
        color: colorMap[entry.key] ?? AppTheme.primaryColor,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: chartRadius,
        titleStyle: TextStyle(
          fontSize: legendFontSize * 1.2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, Color> colorMap, ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      children: muscleGroups.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: legendFontSize,
              height: legendFontSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorMap[entry.key],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${entry.key} (${entry.value})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: legendFontSize,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}