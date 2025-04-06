import 'dart:convert';
import 'dart:io';

import 'package:workout_tracker/models/workout_exercise.dart';
import 'package:workout_tracker/models/workout_set.dart';

import '../models/workout.dart';
import './doc_reader_service.dart';
import './workout_service.dart';

class WorkoutServiceFlutter extends WorkoutService {
  final Future<Directory> Function() getDirectory;
  late DocReaderService docReaderService;

  WorkoutServiceFlutter(
    this.getDirectory,
  ) {
    docReaderService = DocReaderService(getDirectory, 'WorkoutsStorage');
  }

// workout_service_flutter.dart
@override
Future<List<Workout>> loadWorkouts() async {
  try {
    final json = await docReaderService.readFromDisk();
    if (json['workouts'] == null) return [];
    return (json['workouts'] as List).map<Workout>((w) => Workout.fromJson(w)).toList();
  } catch (e) {
    print('Error loading workouts: $e');
    return [];
  }
}
  @override
  Future<File> saveWorkouts(List<Workout> workouts) async {
    final String json = const JsonEncoder().convert({
      'workouts': workouts.map((workout) => workout.toJson()).toList(),
    });

    return docReaderService.writeToDisk(json);
  }
}
