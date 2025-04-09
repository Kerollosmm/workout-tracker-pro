import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';

class WorkoutProvider with ChangeNotifier {
  final Box<Workout> _workoutsBox = Hive.box<Workout>('workouts');
  final uuid = Uuid();
  
  List<Workout> get workouts {
    // Return sorted workouts by date (newest first)
    final workoutsList = _workoutsBox.values.toList();
    workoutsList.sort((a, b) => b.date.compareTo(a.date));
    return workoutsList;
  }
  
  List<Workout> getWorkoutsByDateRange(DateTime start, DateTime end) {
    return workouts.where((w) => 
      w.date.isAfter(start) && w.date.isBefore(end)
    ).toList();
  }
  
  Workout? getWorkoutById(String id) {
    try {
      return _workoutsBox.values.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> addWorkout(Workout workout) async {
    await _workoutsBox.add(workout);
    notifyListeners();
  }
  
  Future<void> updateWorkout(Workout workout) async {
    final index = _workoutsBox.values.toList().indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      await _workoutsBox.putAt(index, workout);
      notifyListeners();
    }
  }
  
  Future<void> deleteWorkout(String id) async {
    final index = _workoutsBox.values.toList().indexWhere((w) => w.id == id);
    if (index != -1) {
      await _workoutsBox.deleteAt(index);
      notifyListeners();
    }
  }
  
  // Stats & Analytics
  double getTotalWeightLifted(DateTime? date) {
    if (date == null) {
      return workouts.fold(0, (sum, workout) => sum + workout.totalWeightLifted);
    }
    
    // For specific date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final dayWorkouts = workouts.where((w) => 
      w.date.isAfter(startOfDay) && w.date.isBefore(endOfDay)
    ).toList();
    
    return dayWorkouts.fold(0, (sum, workout) => sum + workout.totalWeightLifted);
  }
  
  int getTotalSets(DateTime? date) {
    if (date == null) {
      return workouts.fold(0, (sum, workout) => sum + workout.totalSets);
    }
    
    // For specific date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final dayWorkouts = workouts.where((w) => 
      w.date.isAfter(startOfDay) && w.date.isBefore(endOfDay)
    ).toList();
    
    return dayWorkouts.fold(0, (sum, workout) => sum + workout.totalSets);
  }
  
  // Get exercise performance data for charts
  List<Map<String, dynamic>> getExerciseProgressData(String exerciseId, {int limit = 10}) {
    final data = <Map<String, dynamic>>[];
    
    // Find workouts containing this exercise
    final workoutsWithExercise = workouts.where((w) => 
      w.exercises.any((e) => e.exerciseId == exerciseId)
    ).toList();
    
    // Sort by date
    workoutsWithExercise.sort((a, b) => a.date.compareTo(b.date));
    
    // Take only the most recent ones based on limit
    final limitedWorkouts = workoutsWithExercise.length > limit 
        ? workoutsWithExercise.sublist(workoutsWithExercise.length - limit) 
        : workoutsWithExercise;
    
    for (var workout in limitedWorkouts) {
      final exercise = workout.exercises.firstWhere((e) => e.exerciseId == exerciseId);
      
      // Calculate max weight for this exercise in this workout
      if (exercise.sets.isNotEmpty) {
        final maxWeight = exercise.sets.reduce((curr, next) => 
          curr.weight > next.weight ? curr : next
        ).weight;
        
        data.add({
          'date': workout.date,
          'weight': maxWeight,
        });
      }
    }
    
    return data;
  }
  
  // Get distribution of muscle groups trained
  Map<String, int> getMuscleGroupDistribution() {
    final distribution = <String, int>{};
    
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (distribution.containsKey(exercise.muscleGroup)) {
          distribution[exercise.muscleGroup] = distribution[exercise.muscleGroup]! + 1;
        } else {
          distribution[exercise.muscleGroup] = 1;
        }
      }
    }
    
    return distribution;
  }
}
