import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/workout_provider.dart';
import '../../../core/providers/exercise_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedExerciseId;
  String _timeFilter = 'Monthly'; // Weekly, Monthly, All Time

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    // Automatically select first exercise if none selected
    if (_selectedExerciseId == null && exerciseProvider.exercises.isNotEmpty) {
      _selectedExerciseId = exerciseProvider.exercises.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Performance'), Tab(text: 'Muscle Groups')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Performance Tab
          _buildPerformanceTab(context, workoutProvider, exerciseProvider),

          // Muscle Groups Tab
          _buildMuscleGroupsTab(context, workoutProvider),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(
    BuildContext context,
    WorkoutProvider workoutProvider,
    ExerciseProvider exerciseProvider,
  ) {
    return Column(
      children: [
        // Exercise Dropdown
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select Exercise',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.fitness_center),
            ),
            value: _selectedExerciseId,
            items:
                exerciseProvider.exercises.map((exercise) {
                  return DropdownMenuItem(
                    value: exercise.id,
                    child: Text(exercise.name),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedExerciseId = value;
              });
            },
          ),
        ),

        // Time Filter Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterChip('Weekly', _timeFilter == 'Weekly'),
              SizedBox(width: 8),
              _buildFilterChip('Monthly', _timeFilter == 'Monthly'),
              SizedBox(width: 8),
              _buildFilterChip('All Time', _timeFilter == 'All Time'),
            ],
          ),
        ),

        // Performance Chart
        if (_selectedExerciseId != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildPerformanceChart(
                workoutProvider,
                _selectedExerciseId!,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _timeFilter = label;
          });
        }
      },
    );
  }

  Widget _buildPerformanceChart(WorkoutProvider provider, String exerciseId) {
    // Determine how many data points to fetch based on filter
    int limit;
    switch (_timeFilter) {
      case 'Weekly':
        limit = 7;
        break;
      case 'Monthly':
        limit = 30;
        break;
      case 'All Time':
      default:
        limit = 100; // Just get all available points
        break;
    }

    final data = provider.getExerciseProgressData(exerciseId, limit: limit);

    if (data.isEmpty) {
      return Center(child: Text('No data available for this exercise'));
    }

    // Transform to chart data points
    final spots =
        data.map((point) {
          // X-axis is the index (0, 1, 2, ...), Y-axis is the weight
          final index = data.indexOf(point).toDouble();
          return FlSpot(index, point['weight'] as double);
        }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12),
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
        maxY:
            spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) *
            1.2, // 20% higher than max
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupsTab(BuildContext context, WorkoutProvider provider) {
    final muscleGroups = provider.getMuscleGroupDistribution();

    if (muscleGroups.isEmpty) {
      return Center(child: Text('No workout data available'));
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _getMuscleGroupSections(muscleGroups),
              ),
            ),
          ),
        ),

        // Legend
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children:
                muscleGroups.keys.map((group) {
                  final color = _getMuscleGroupColor(group);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '$group (${muscleGroups[group]})',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getMuscleGroupSections(
    Map<String, int> muscleGroups,
  ) {
    return muscleGroups.entries.map((entry) {
      final color = _getMuscleGroupColor(entry.key);
      final value = entry.value.toDouble();
      final total = muscleGroups.values.fold(0, (sum, count) => sum + count);
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        color: color,
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getMuscleGroupColor(String muscleGroup) {
    // Assign a consistent color for each muscle group
    final colors = {
      'Chest': Colors.red,
      'Back': Colors.blue,
      'Shoulders': Colors.orange,
      'Arms': Colors.purple,
      'Legs': Colors.green,
      'Core': Colors.yellow[700]!,
      'Cardio': Colors.pink,
      'Full Body': Colors.teal,
    };

    return colors[muscleGroup] ?? Colors.grey;
  }
}
