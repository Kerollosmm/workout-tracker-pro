import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:workout_tracker/pages/add_exercise_page.dart';
import 'package:workout_tracker/widgets/ExerciseEditDialog%20.dart';
import '../models/exercise.dart';
import '../scoped_models/exercises.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScopedModelDescendant<ExercisesModel>(
      builder: (BuildContext context, Widget? child, ExercisesModel model) {
        void _navigateToEditScreen(
          BuildContext context,
          Exercise exercise,
          ExercisesModel model,
        ) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ExerciseEditDialog(
                exercise: exercise,
                onSave: (updatedExercise) {
                  model.editExercise(exercise, updatedExercise);
                },
              );
            },
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child:
                  model.exercises.isEmpty
                      ? Center(
                        child: Text(
                          'No exercises added yet.\nTap "Add Exercise" below to start!',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final exercise = model.exercises[index];
                          return _ExerciseListItem(
                            exercise: exercise,
                            onDelete: () => model.deleteExercise(exercise),
                            onEdit:
                                () => _navigateToEditScreen(
                                  context,
                                  exercise,
                                  model,
                                ),

                            muscleGroup: exercise.muscleGroup,
                          );
                        },
                        itemCount: model.exercises.length,
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                child: const Text('Add Exercise'),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddExercisePage(),
                      ),
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final String muscleGroup;

  const _ExerciseListItem({
    required this.exercise,
    required this.onDelete,
    required this.onEdit,
    required this.muscleGroup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(Icons.fitness_center, color: theme.colorScheme.primary),
        title: Text(exercise.name, style: theme.textTheme.bodyLarge),
        subtitle: Text(
          muscleGroup,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: theme.colorScheme.error,
          onPressed: () => _showDeleteConfirmation(context),
        ),
        onTap: onEdit,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Exercise'),
          content: const Text('Are you sure you want to delete this exercise?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
