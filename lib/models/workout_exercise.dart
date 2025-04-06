import './workout_set.dart';
import './exercise.dart';

class WorkoutExercise extends Exercise {
  final List<WorkoutSet> workoutSets;

  WorkoutExercise({
    required String name,
    required String muscleGroup, // Added required parameter
    required this.workoutSets,
  }) : super(name: name, muscleGroup: muscleGroup); // Pass to superclass

  @override
  Map<String, Object> toJson() {
    return {
      "name": name,
      "muscleGroup": muscleGroup, // Include muscleGroup in JSON
      "workoutSets": workoutSets.map((set) => set.toJson()).toList(),
    };
  }

  static WorkoutExercise fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String, // Extract from JSON
      workoutSets: (json['workoutSets'] as List)
          .map<WorkoutSet>((ws) => WorkoutSet.fromJson(ws))
          .toList(),
    );
  }
}