import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_tracker/models/workout_exercise.dart';
import '../scoped_models/workouts.dart';
import '../models/workout.dart';

class WeeklyProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<WorkoutsModel>(
      builder: (context, child, model) {
        final weeklyData = _getWeeklyData(model.workouts);
        final maxY = _calculateMaxY(weeklyData);

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weekly Performance',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildLegend(),
                  ],
                ),
                const SizedBox(height: 20),
                AspectRatio(
                  aspectRatio: 1.6,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) => 
                              _bottomTitle(value, meta, weeklyData),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: weeklyData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: day.totalWeight.toDouble(),
                              color: Colors.red,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildWeeklyStats(weeklyData),
              ],
            ),
          ),
          );
        },
    );
      }
  }

  List<DailyStats> _getWeeklyData(List<Workout> workouts) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      final dailyWorkouts = workouts.where((w) => 
        w.date.year == date.year &&
        w.date.month == date.month &&
        w.date.day == date.day
      ).toList();

      int totalWeight = dailyWorkouts.fold(0, (sum, workout) => sum + 
        workout.workoutExercises.fold(0, (s, e) => s + 
          e.workoutSets.fold(0, (a, set) => a + (set.weight * set.reps))
        )
      );

      int totalSets = dailyWorkouts.fold(0, (sum, workout) => sum + 
        workout.workoutExercises.fold(0, (s, e) => s + e.workoutSets.length)
      );

      return DailyStats(
        date: date,
        totalWeight: totalWeight,
        totalSets: totalSets,
      );
    });
  }

  double _calculateMaxY(List<DailyStats> weeklyData) {
    final maxValue = weeklyData.fold(0, (max, day) => 
      day.totalWeight > max ? day.totalWeight : max);
    return maxValue > 0 ? maxValue * 1.2 : 100; // Minimum 100 for empty weeks
  }

  Widget _bottomTitle(double value, TitleMeta meta, List<DailyStats> data) {
    final index = value.toInt();
    if (index >= data.length) return const SizedBox.shrink();
    return SideTitleWidget(
      meta: meta,
      child: Text(
        _getDayAbbreviation(data[index].date.weekday),
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  String _getDayAbbreviation(int weekday) {
    return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text('Total Weight (lbs)',
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStats(List<DailyStats> weeklyData) {
    final totalWeight = weeklyData.fold(0, (sum, day) => sum + day.totalWeight);
    final totalSets = weeklyData.fold(0, (sum, day) => sum + day.totalSets);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Weight', '$totalWeight lbs'),
        _buildStatItem('Total Sets', '$totalSets sets'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        Text(label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }


class DailyStats {
  final DateTime date;
  final int totalWeight;
  final int totalSets;

  DailyStats({
    required this.date,
    required this.totalWeight,
    required this.totalSets,
  });
}