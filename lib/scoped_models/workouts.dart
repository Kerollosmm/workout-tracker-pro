import 'package:scoped_model/scoped_model.dart';

import '../services/workout_service.dart';
import '../models/workout_set.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';

class WorkoutsModel extends Model {
  WorkoutService workoutService;
  List<Workout> _workouts = [];
  bool loading = false;

  List<Workout> get workouts {
    /// list.from creates a new instance so that
    /// the workouts array cannot be modified in
    /// memory by Widgets.
    return List.from(_workouts);
  }

  WorkoutsModel({required this.workoutService});

  loadWorkouts() {
    loading = true;
    notifyListeners();

    workoutService
        .loadWorkouts()
        .then((workouts) => _workouts = workouts)
        .catchError((_) => _workouts = [])
        .whenComplete(
      () {
        loading = false;
        notifyListeners();
      },
    );
  }

  /// Returns the index of the workout on the specified date. -1 returned
  /// if workout does not exist on that date.
  int getWorkoutOnDate(DateTime date) {
    return _workouts.indexWhere((Workout workout) => workout.date == date);
  }

  /// Creates a blank workout for a specified date
  void createWorkout(DateTime date) {
    final workout = Workout(date: date, workoutExercises: []);
    _workouts.add(workout);
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  /// Adds an already created workout to the list of workouts
  /// this method is helpful when loading workouts from a data
  /// source.
  void addWorkout(Workout workout) {
    _workouts.add(workout);
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  /// Deletes a workout at the specified index
  void deleteWorkout(int index) {
    _workouts.removeAt(index);
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  /// Edits a workout at the specified index with a new workout
  void editWorkout(int index, Workout newWorkout) {
    _workouts[index] = newWorkout;
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  /// Add an exercise to the workout at the specified index.
  void addWorkoutExercise(
    int index,
    WorkoutExercise workoutExercise,
  ) {
    _workouts[index].workoutExercises.add(workoutExercise);
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  /// Add an exercise set to the workout at the specified index.
  void addWorkoutSet(
    int workoutIndex,
    int workoutExerciseIndex, {
    reps,
    weight,
  }) {
    final WorkoutSet workoutSet = WorkoutSet(
      reps: reps,
      weight: weight,
    );
    _workouts[workoutIndex]
        .workoutExercises[workoutExerciseIndex]
        .workoutSets
        .add(workoutSet);
    workoutService.saveWorkouts(workouts);
    notifyListeners();
  }

  List<Workout> getTodayWorkouts() {
    // Filters workouts for today
    return workouts.where((workout) => isToday(workout.date)).toList();
  }

  int calculateTotalWeightLifted() {
    return getTodayWorkouts().fold(0, (sum, workout) {
      return sum + workout.workoutExercises.fold(0, (exerciseSum, exercise) {
        return exerciseSum + exercise.workoutSets.fold(0, (setSum, set) {
          return setSum + (set.weight * set.reps);
        });
      });
    });
  }

  int calculateTotalReps() {
    return getTodayWorkouts().fold(0, (sum, workout) {
      return sum + workout.workoutExercises.fold(0, (exerciseSum, exercise) {
        return exerciseSum + exercise.workoutSets.fold(0, (setSum, set) {
          return setSum + set.reps;
        });
      });
    });
  }

  /// Get all exercises performed today with their total weight lifted
  List<Map<String, dynamic>> getTodayExercises() {
    final exercisesMap = <String, int>{};
    for (var workout in getTodayWorkouts()) {
      for (var exercise in workout.workoutExercises) {
        final totalWeight = exercise.workoutSets.fold(
            0, (sum, set) => sum + (set.weight * set.reps));
        exercisesMap[exercise.name] =
            (exercisesMap[exercise.name] ?? 0) + totalWeight;
      }
    }
    return exercisesMap.entries
        .map((entry) => {'name': entry.key, 'totalWeight': entry.value})
        .toList();
  }

  /// Calculate percentage change in weight lifted from first to last update
  double calculateWeightChangePercentage() {
    final todayWorkouts = getTodayWorkouts();
    if (todayWorkouts.isEmpty || todayWorkouts.first.workoutExercises.isEmpty) {
      return 0.0; // No data to compare
    }

    // Assuming workouts or sets are added in chronological order
    final firstWorkout = todayWorkouts.first;
    final lastWorkout = todayWorkouts.last;

    final firstWeight = firstWorkout.workoutExercises.first.workoutSets.isEmpty
        ? 0
        : firstWorkout.workoutExercises.first.workoutSets.first.weight *
            firstWorkout.workoutExercises.first.workoutSets.first.reps;
    final lastTotalWeight = calculateTotalWeightLifted();

    if (firstWeight == 0) return 0.0; // Avoid division by zero
    return ((lastTotalWeight - firstWeight) / firstWeight) * 100;
  }

  /// Checks if the given date is today's date
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
