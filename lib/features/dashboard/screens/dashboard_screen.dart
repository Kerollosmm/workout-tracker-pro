import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/workout_provider.dart';
import '../widgets/progress_chart_widget.dart';
import '../widgets/workout_summary_card.dart';
import '../widgets/quick_stats_widget.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final today = DateTime.now();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/workout_log');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data if needed
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Progress',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              
              // Quick Stats
              QuickStatsWidget(
                totalSets: workoutProvider.getTotalSets(today),
                totalWeight: workoutProvider.getTotalWeightLifted(today),
              ),
              SizedBox(height: 24),
              
              // Weekly Progress Chart
              Text(
                'This Week',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              ProgressChartWidget(
                // Weekly data
              ),
              SizedBox(height: 24),
              
              // Recent Workouts
              Text(
                'Recent Workouts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              _buildRecentWorkouts(context, workoutProvider),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: // Already on Dashboard
              break;
            case 1:
              Navigator.pushNamed(context, '/workout_log');
              break;
            case 2:
              Navigator.pushNamed(context, '/analytics');
              break;
            case 3:
              Navigator.pushNamed(context, '/history');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentWorkouts(BuildContext context, WorkoutProvider provider) {
    final recentWorkouts = provider.workouts.take(3).toList();
    
    if (recentWorkouts.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No workouts yet. Start tracking your progress!',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: recentWorkouts.map((workout) {
        return WorkoutSummaryCard(
          workout: workout,
          onTap: () {
            // Navigate to workout details
          },
        );
      }).toList(),
    );
  }
}
