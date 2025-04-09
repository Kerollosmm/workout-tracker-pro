import 'package:hive/hive.dart';
part 'workout_set.g.dart';

@HiveType(typeId: 1)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  double weight;
  
  @HiveField(2)
  int reps;
  
  @HiveField(3)
  DateTime timestamp;
  
  // Optional
  @HiveField(4)
  bool isCompleted;
  
  @HiveField(5)
  String? notes;
  
  WorkoutSet({
    required this.id,
    required this.weight,
    required this.reps,
    required this.timestamp,
    this.isCompleted = true,
    this.notes,
  });

  WorkoutSet copyWith({
    double? weight,
    int? reps,
  }) {
    return WorkoutSet(
      id: this.id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      timestamp: this.timestamp,
      isCompleted: this.isCompleted,
      notes: this.notes,
    );
  }
}
