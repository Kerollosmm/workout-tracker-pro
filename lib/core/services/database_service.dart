import 'package:hive/hive.dart';
import 'package:workout_tracker/core/models/workout_set.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/user_settings.dart';

class DatabaseService {
  // Box names
  static const String exercisesBoxName = 'exercises';
  static const String workoutsBoxName = 'workouts';
  static const String settingsBoxName = 'settings';
  
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  DatabaseService._internal();
  
  // Get references to boxes
  Box<Exercise> get exercisesBox => Hive.box<Exercise>(exercisesBoxName);
  Box<Workout> get workoutsBox => Hive.box<Workout>(workoutsBoxName);
  Box<UserSettings> get settingsBox => Hive.box<UserSettings>(settingsBoxName);
  
  // Initialize the database
  Future<void> initialize() async {
    // Register Hive adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkoutSetAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WorkoutAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(WorkoutExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }
    
    // Open boxes
    await Hive.openBox<Exercise>(exercisesBoxName);
    await Hive.openBox<Workout>(workoutsBoxName);
    await Hive.openBox<UserSettings>(settingsBoxName);
    
    // Initialize with default data if needed
    await _initializeDefaultData();
  }
  
  Future<void> _initializeDefaultData() async {
    // Add default exercises if the box is empty
    if (exercisesBox.isEmpty) {
      final defaultExercises = _getDefaultExercises();
      for (final exercise in defaultExercises) {
        await exercisesBox.add(exercise);
      }
    }
    
    // Add default settings if the box is empty
    if (settingsBox.isEmpty) {
      final defaultSettings = UserSettings(
        language: 'en',
        weightUnit: 'kg',
        isDarkMode: false,
        notificationDays: [],
        notificationTime: '08:00',
      );
      await settingsBox.add(defaultSettings);
    }
  }
  
  List<Exercise> _getDefaultExercises() {
    return [
      Exercise(
        id: 'bench-press-default',
        name: 'Bench Press',
        muscleGroup: 'Chest',
        isCustom: false,
        iconPath: 'assets/icons/bench_press.png',
      ),
      Exercise(
        id: 'squat-default',
        name: 'Squat',
        muscleGroup: 'Legs',
        isCustom: false,
        iconPath: 'assets/icons/squat.png',
      ),
      Exercise(
        id: 'deadlift-default',
        name: 'Deadlift',
        muscleGroup: 'Back',
        isCustom: false,
        iconPath: 'assets/icons/deadlift.png',
      ),
      Exercise(
        id: 'shoulder-press-default',
        name: 'Shoulder Press',
        muscleGroup: 'Shoulders',
        isCustom: false,
        iconPath: 'assets/icons/shoulder_press.png',
      ),
      Exercise(
        id: 'bicep-curl-default',
        name: 'Bicep Curl',
        muscleGroup: 'Arms',
        isCustom: false,
        iconPath: 'assets/icons/bicep_curl.png',
      ),
      Exercise(
        id: 'pull-up-default',
        name: 'Pull Up',
        muscleGroup: 'Back',
        isCustom: false,
        iconPath: 'assets/icons/pull_up.png',
      ),
      Exercise(
        id: 'push-up-default',
        name: 'Push Up',
        muscleGroup: 'Chest',
        isCustom: false,
        iconPath: 'assets/icons/push_up.png',
      ),
      Exercise(
        id: 'leg-press-default',
        name: 'Leg Press',
        muscleGroup: 'Legs',
        isCustom: false,
        iconPath: 'assets/icons/leg_press.png',
      ),
      Exercise(
        id: 'lat-pulldown-default',
        name: 'Lat Pulldown',
        muscleGroup: 'Back',
        isCustom: false,
        iconPath: 'assets/icons/lat_pulldown.png',
      ),
      Exercise(
        id: 'tricep-extension-default',
        name: 'Tricep Extension',
        muscleGroup: 'Arms',
        isCustom: false,
        iconPath: 'assets/icons/tricep_extension.png',
      ),
    ];
  }
  
  // Clear all data (for testing or reset functionality)
  Future<void> clearAllData() async {
    await exercisesBox.clear();
    await workoutsBox.clear();
    await settingsBox.clear();
    await _initializeDefaultData();
  }
}