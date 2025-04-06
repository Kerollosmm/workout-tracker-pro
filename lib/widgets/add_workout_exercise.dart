import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/exercises.dart';
import '../scoped_models/workouts.dart';
import '../models/workout_exercise.dart';
import '../models/exercise.dart';

/// The purpose of this widget is to encapsulate all of the neceassary logic
/// needed to add a workout exercise to a workout. To do this the widget
/// will make use of the ScopedModel. The only object his widget needs to
/// complete its job is the index of the workout the exercise should be added to.
///
/// NOTE: main reason for making this a seperate component was because the
/// workouts_page widget was getting cluttered with all the scenarios it has
/// and the widget test file was getting large.

class AddWorkoutExercise extends StatelessWidget {
  final int index;
  final Function showModal;

  const AddWorkoutExercise(this.index, this.showModal, {super.key});

  @override
  Widget build(BuildContext context) {
    WorkoutsModel workoutsModel = ScopedModel.of<WorkoutsModel>(context);
    ExercisesModel exercisesModel = ScopedModel.of<ExercisesModel>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.center,
      child: ElevatedButton(
        key: const Key('addExercisesButton'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 5,
        ),
        onPressed: () {
          showModal(context, exercisesModel.exercises).then((
            Exercise? exercise,
          ) {
            if (exercise != null) {
              // Add null-check for muscleGroup
              workoutsModel.addWorkoutExercise(
                index,
                WorkoutExercise(
                  name: exercise.name,
                  muscleGroup: exercise.muscleGroup ?? 'Other',
                  workoutSets: [],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${exercise.name} added to workout!')),
              );
            }
          });
        },
        child: const Text('Add Exercise', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
