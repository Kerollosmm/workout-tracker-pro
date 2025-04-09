// lib/features/dashboard/providers/dashboard_provider.dart

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/workout_provider.dart';
import '../../../core/providers/exercise_provider.dart';
import '../../../core/models/workout.dart';

class DashboardProvider with ChangeNotifier {
  final WorkoutProvider _workoutProvider;
  final ExerciseProvider _exerciseProvider;
  
  DashboardProvider(this._workoutProvider, this._exerciseProvider) {
    // Listen to changes in workout and exercise providers
    _workoutProvider.addListener(() {
      notifyListeners();
    });
    _exerciseProvider.addListener(() {
      notifyListeners();
    });
  }
  
  // Get today's date with time set to start of day
  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  
  // Get today's progress
  int get todayTotalSets => _workoutProvider.getTotalSets(today);
  double get todayTotalWeight => _workoutProvider.getTotalWeightLifted(today);
  
  // Get weekly data for chart
  List<Map<String, dynamic>> getWeeklyChartData() {
    final weekData = <Map<String, dynamic>>[];
    final now = DateTime.now();
    
    // Calculate the start of the week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    
    // Generate data for each day of the week
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final totalWeight = _workoutProvider.getTotalWeightLifted(day);
      final totalSets = _workoutProvider.getTotalSets(day);
      
      weekData.add({
        'date': day,
        'day': DateFormat('E').format(day), // Short day name (Mon, Tue, etc.)
        'totalWeight': totalWeight,
        'totalSets': totalSets,
      });
    }
    
    return weekData;
  }
  
  // Get recent workouts (limited to 3)
  List<Workout> get recentWorkouts {
    final workouts = _workoutProvider.workouts;
    
    if (workouts.isEmpty) {
      return [];
    }
    
    // Return the 3 most recent workouts
    return workouts.take(3).toList();
  }
  
  // Get most recent workout exercise
  Map<String, dynamic> getMostRecentExercise() {
    final workouts = _workoutProvider.workouts;
    
    if (workouts.isEmpty || workouts.first.exercises.isEmpty) {
      return {
        'name': 'No exercise yet',
        'muscleGroup': '',
        'date': DateTime.now(),
      };
    }
    
    final latestWorkout = workouts.first;
    final latestExercise = latestWorkout.exercises.first;
    
    return {
      'name': latestExercise.exerciseName,
      'muscleGroup': latestExercise.muscleGroup,
      'date': latestWorkout.date,
    };
  }
  
  // Get total workout stats
  Map<String, dynamic> getTotalStats() {
    return {
      'totalWorkouts': _workoutProvider.workouts.length,
      'totalExercises': _getTotalExercisesPerformed(),
      'totalSets': _workoutProvider.getTotalSets(null),
      'totalWeight': _workoutProvider.getTotalWeightLifted(null),
    };
  }
  
  // Calculate total number of exercises performed across all workouts
  int _getTotalExercisesPerformed() {
    int total = 0;
    for (final workout in _workoutProvider.workouts) {
      total += workout.exercises.length;
    }
    return total;
  }
}
