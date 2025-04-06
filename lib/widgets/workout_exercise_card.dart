import 'package:flutter/material.dart';

import '../widgets/add_workout_set.dart';
import '../models/workout_set.dart';
import '../models/workout_exercise.dart';

class WorkoutExerciseCard extends StatelessWidget {
  final int workoutIndex;
  final int exerciseIndex;
  final WorkoutExercise exercise;

  const WorkoutExerciseCard(
    this.workoutIndex,
    this.exerciseIndex,
    this.exercise, {
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exercise.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Text('Sets: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: _buildSetsList(context, exercise.workoutSets)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }

  List<Widget> _buildSetsList(
    BuildContext context,
    List<WorkoutSet> workoutSets,
  ) {
    List<Widget> setsList = [];

    // create the array of chips to display the workout sets
    for (var i = 0; i < workoutSets.length; i++) {
      final WorkoutSet workoutSet = workoutSets[i];

      setsList.add(GestureDetector(
        key: Key('workoutSet$i'),
        onTap: () => {},
        child: Chip(
          label: Text('${workoutSet.reps} x ${workoutSet.weight}'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ));

      setsList.add(const SizedBox(width: 8.0));
    }

    // add the plus icon for adding a new set
    setsList.add(AddWorkoutSet(
      workoutIndex,
      exerciseIndex,
      key: const Key('addWorkoutSet'),
    ));

    return setsList;
  }
}
