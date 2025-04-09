// lib/features/history/providers/history_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/workout_provider.dart';
import '../../../core/models/workout.dart';

class HistoryProvider with ChangeNotifier {
  final WorkoutProvider _workoutProvider;
  
  // Filter options
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedMuscleGroup;
  String? _searchQuery;
  
  HistoryProvider(this._workoutProvider) {
    // Listen to changes in the workout provider
    _workoutProvider.addListener(() {
      notifyListeners();
    });
  }
  
  // Getters
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String? get selectedMuscleGroup => _selectedMuscleGroup;
  String? get searchQuery => _searchQuery;
  
  // Setters for filters
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }
  
  void setMuscleGroupFilter(String? muscleGroup) {
    _selectedMuscleGroup = muscleGroup;
    notifyListeners();
  }
  
  void setSearchQuery(String? query) {
    _searchQuery = query?.isNotEmpty == true ? query : null;
    notifyListeners();
  }
  
  // Reset all filters
  void resetFilters() {
    _startDate = null;
    _endDate = null;
    _selectedMuscleGroup = null;
    _searchQuery = null;
    notifyListeners();
  }
  
  // Get filtered workouts
  List<Workout> getFilteredWorkouts() {
    List<Workout> filteredWorkouts = List.from(_workoutProvider.workouts);
    
    // Apply date range filter
    if (_startDate != null) {
      filteredWorkouts = filteredWorkouts.where((workout) => 
        workout.date.isAfter(_startDate!) || 
        DateUtils.isSameDay(workout.date, _startDate)
      ).toList();
    }
    
    if (_endDate != null) {
      final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
      filteredWorkouts = filteredWorkouts.where((workout) => 
        workout.date.isBefore(endOfDay) || 
        DateUtils.isSameDay(workout.date, _endDate)
      ).toList();
    }
    
    // Apply muscle group filter
    if (_selectedMuscleGroup != null && _selectedMuscleGroup != 'All') {
      filteredWorkouts = filteredWorkouts.where((workout) => 
        workout.exercises.any((exercise) => 
          exercise.muscleGroup == _selectedMuscleGroup
        )
      ).toList();
    }
    
    // Apply search query filter
    if (_searchQuery != null) {
      final query = _searchQuery!.toLowerCase();
      filteredWorkouts = filteredWorkouts.where((workout) => 
        // Search in exercise names
        workout.exercises.any((exercise) => 
          exercise.exerciseName.toLowerCase().contains(query)
        ) ||
        // Search in notes
        (workout.notes?.toLowerCase().contains(query) ?? false) ||
        // Search in date
        DateFormat('EEEE, MMMM d, y').format(workout.date).toLowerCase().contains(query)
      ).toList();
    }
    
    return filteredWorkouts;
  }
  
  // Group workouts by month/year for better organization
  Map<String, List<Workout>> getWorkoutsGroupedByMonth() {
    final workouts = getFilteredWorkouts();
    final groupedWorkouts = <String, List<Workout>>{};
    
    for (final workout in workouts) {
      final monthYear = DateFormat('MMMM yyyy').format(workout.date);
      
      if (!groupedWorkouts.containsKey(monthYear)) {
        groupedWorkouts[monthYear] = [];
      }
      
      groupedWorkouts[monthYear]!.add(workout);
    }
    
    return groupedWorkouts;
  }
  
  // Get a summary of workout statistics for a given period
  Map<String, dynamic> getWorkoutSummary() {
    final workouts = getFilteredWorkouts();
    
    if (workouts.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalExercises': 0,
        'totalSets': 0,
        'totalWeight': 0.0,
        'averageSetsPerWorkout': 0.0,
      };
    }
    
    int totalSets = 0;
    int totalExercises = 0;
    double totalWeight = 0.0;
    
    for (final workout in workouts) {
      totalSets += workout.totalSets;
      totalExercises += workout.exercises.length;
      totalWeight += workout.totalWeightLifted;
    }
    
    return {
      'totalWorkouts': workouts.length,
      'totalExercises': totalExercises,
      'totalSets': totalSets,
      'totalWeight': totalWeight,
      'averageSetsPerWorkout': totalSets / workouts.length,
    };
  }
}

