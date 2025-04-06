import 'package:scoped_model/scoped_model.dart';
import '../services/exercise_service.dart';
import '../models/exercise.dart';

class ExercisesModel extends Model {
  final ExerciseService exerciseService;
  List<Exercise> _exercises = [];
  bool loading = false;

  List<Exercise> get exercises => List.from(_exercises);

  ExercisesModel({required this.exerciseService});

  loadExercises() {
    loading = true;
    exerciseService
        .loadExercises()
        .then((exercises) => _exercises = exercises)
        .catchError((_) => _exercises = [])
        .whenComplete(() {
      loading = false;
      notifyListeners();
    });
  }

  Future<void> addExercise(Exercise exercise) async {
    final newList = List<Exercise>.from(_exercises);
    newList.add(exercise);
    
    try {
      _exercises = newList;
      notifyListeners();
      await exerciseService.saveExercises(_exercises);
    } catch (e) {
      _exercises = List<Exercise>.from(_exercises);
      notifyListeners();
      print('Error adding exercise: $e');
      rethrow;
    }
  }

  Future<void> deleteExercise(Exercise exercise) async {
    final newList = List<Exercise>.from(_exercises);
    final index = newList.indexWhere((e) => e == exercise);
    
    if (index == -1) return;
    
    newList.removeAt(index);
    
    try {
      _exercises = newList;
      notifyListeners();
      await exerciseService.saveExercises(_exercises);
    } catch (e) {
      _exercises = List<Exercise>.from(_exercises);
      notifyListeners();
      print('Error deleting exercise: $e');
      rethrow;
    }
  }

  Future<void> editExercise(Exercise oldExercise, Exercise newExercise) async {
    final newList = List<Exercise>.from(_exercises);
    final index = newList.indexWhere((e) => e == oldExercise);
    
    if (index == -1) {
      throw Exception('Exercise not found');
    }
    
    newList[index] = newExercise;
    
    try {
      _exercises = newList;
      notifyListeners();
      await exerciseService.saveExercises(_exercises);
    } catch (e) {
      _exercises = List<Exercise>.from(_exercises);
      notifyListeners();
      print('Error editing exercise: $e');
      rethrow;
    }
  }

  Exercise? getExerciseByName(String name) {
    try {
      return _exercises.firstWhere((e) => e.name == name);
    } catch (e) {
      return null;
    }
  }
}

  