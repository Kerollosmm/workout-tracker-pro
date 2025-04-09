// lib/features/custom_exercise/providers/custom_exercise_provider.dart

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/exercise.dart';
import '../../../core/providers/exercise_provider.dart';

class CustomExerciseProvider with ChangeNotifier {
  final ExerciseProvider _exerciseProvider;
  final uuid = Uuid();
  
  String _exerciseName = '';
  String _selectedMuscleGroup = 'Chest';
  bool _isFavorite = false;
  String? _notes;
  
  CustomExerciseProvider(this._exerciseProvider);
  
  // Getters
  String get exerciseName => _exerciseName;
  String get selectedMuscleGroup => _selectedMuscleGroup;
  bool get isFavorite => _isFavorite;
  String? get notes => _notes;
  List<String> get muscleGroups => _exerciseProvider.allMuscleGroups;
  
  // Setters
  void setExerciseName(String name) {
    _exerciseName = name;
    notifyListeners();
  }
  
  void setMuscleGroup(String muscleGroup) {
    _selectedMuscleGroup = muscleGroup;
    notifyListeners();
  }
  
  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
  
  void setNotes(String? notes) {
    _notes = notes;
    notifyListeners();
  }
  
  // Reset form data
  void resetForm() {
    _exerciseName = '';
    _selectedMuscleGroup = 'Chest';
    _isFavorite = false;
    _notes = null;
    notifyListeners();
  }
  
  // Save custom exercise
  Future<bool> saveExercise() async {
    if (_exerciseName.trim().isEmpty) {
      return false;
    }
    
    final newExercise = Exercise(
      id: uuid.v4(),
      name: _exerciseName.trim(),
      muscleGroup: _selectedMuscleGroup,
      isFavorite: _isFavorite,
      notes: _notes,
      isCustom: true,
    );
    
    await _exerciseProvider.addExercise(newExercise);
    resetForm();
    return true;
  }
  
  // Load exercise data for editing
  void loadExercise(Exercise exercise) {
    _exerciseName = exercise.name;
    _selectedMuscleGroup = exercise.muscleGroup;
    _isFavorite = exercise.isFavorite;
    _notes = exercise.notes;
    notifyListeners();
  }
  
  // Update existing exercise
  Future<bool> updateExercise(String exerciseId) async {
    if (_exerciseName.trim().isEmpty) {
      return false;
    }
    
    final exercise = _exerciseProvider.getExerciseById(exerciseId);
    if (exercise == null) {
      return false;
    }
    
    exercise.name = _exerciseName.trim();
    exercise.muscleGroup = _selectedMuscleGroup;
    exercise.isFavorite = _isFavorite;
    exercise.notes = _notes;
    
    await _exerciseProvider.updateExercise(exercise);
    resetForm();
    return true;
  }
}
