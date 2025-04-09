// lib/features/dashboard/widgets/workout_summary_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import '../../../config/themes/app_theme.dart';
import '../../../core/models/workout.dart';
import '../../../core/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onTap;

  const WorkoutSummaryCard({
    Key? key,
    required this.workout,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');
    
    // Calculate summary stats
    final totalExercises = workout.exercises.length;
    final totalSets = workout.totalSets;
    final totalWeightLifted = workout.totalWeightLifted;
    
    // Find primary muscle group (most trained in this workout)
    final muscleGroupCounts = <String, int>{};
    for (final exercise in workout.exercises) {
      if (muscleGroupCounts.containsKey(exercise.muscleGroup)) {
        muscleGroupCounts[exercise.muscleGroup] = muscleGroupCounts[exercise.muscleGroup]! + 1;
      } else {
        muscleGroupCounts[exercise.muscleGroup] = 1;
      }
    }
    
    final primaryMuscleGroup = muscleGroupCounts.entries.isEmpty 
        ? 'N/A'
        : muscleGroupCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
            
    final muscleGroupColor = AppTheme.getColorForMuscleGroup(primaryMuscleGroup);
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_l),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius_l),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and muscle group row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        dateFormat.format(workout.date),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(
                      primaryMuscleGroup,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: muscleGroupColor,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing_s),
              
              // Time row
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    timeFormat.format(workout.date),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing_m),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    context, 
                    '$totalExercises', 
                    'Exercises',
                  ),
                  _buildStatColumn(
                    context, 
                    '$totalSets', 
                    'Sets',
                  ),
                  _buildStatColumn(
                    context, 
                    '${totalWeightLifted.toStringAsFixed(0)}', 
                    settingsProvider.weightUnit,
                  ),
                ],
              ),
              
              // Exercise list preview (first 2 only)
              if (workout.exercises.isNotEmpty) ...[
                SizedBox(height: AppTheme.spacing_m),
                Divider(height: 1),
                SizedBox(height: AppTheme.spacing_s),
                ...workout.exercises.take(2).map((exercise) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.fitness_center, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exercise.exerciseName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${exercise.sets.length} sets',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )),
                
                // Show indicator if more exercises are present
                if (workout.exercises.length > 2)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '+ ${workout.exercises.length - 2} more exercises',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
