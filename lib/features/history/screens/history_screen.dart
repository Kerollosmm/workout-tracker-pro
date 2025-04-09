import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/models/workout.dart';
import '../../../core/providers/workout_provider.dart';
import '../../../core/providers/settings_provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final workouts = workoutProvider.workouts;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
      ),
      body: workouts.isEmpty
          ? Center(
              child: Text('No workout history yet'),
            )
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return _buildWorkoutHistoryItem(context, workout, settingsProvider.weightUnit);
              },
            ),
    );
  }
  
  Widget _buildWorkoutHistoryItem(BuildContext context, Workout workout, String weightUnit) {
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          dateFormat.format(workout.date),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${workout.exercises.length} exercises • ${workout.totalSets} sets',
        ),
        children: [
          // Exercises list
          ...workout.exercises.map((exercise) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name
                  Row(
                    children: [
                      Icon(Icons.fitness_center, size: 16),
                      SizedBox(width: 8),
                      Text(
                        exercise.exerciseName,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Text(
                        exercise.muscleGroup,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  // Set details
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, top: 8.0),
                    child: Column(
                      children: [
                        // Set header
                        Row(
                          children: [
                            Expanded(flex: 1, child: Text('Set', style: TextStyle(fontSize: 12, color: Colors.grey))),
                            Expanded(flex: 2, child: Text('Weight', style: TextStyle(fontSize: 12, color: Colors.grey))),
                            Expanded(flex: 1, child: Text('Reps', style: TextStyle(fontSize: 12, color: Colors.grey))),
                          ],
                        ),
                        Divider(height: 8),
                        
                        // Set rows
                        ...List.generate(exercise.sets.length, (setIndex) {
                          final set = exercise.sets[setIndex];
                          return Row(
                            children: [
                              Expanded(flex: 1, child: Text('${setIndex + 1}')),
                              Expanded(flex: 2, child: Text('${set.weight} $weightUnit')),
                              Expanded(flex: 1, child: Text('${set.reps}')),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  Divider(),
                ],
              ),
            );
          }).toList(),
          
          // Notes section if available
          if (workout.notes != null && workout.notes!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(workout.notes!),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
