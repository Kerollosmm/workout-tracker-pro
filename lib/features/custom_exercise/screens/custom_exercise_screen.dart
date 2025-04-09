import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/exercise.dart';
import '../../../core/providers/exercise_provider.dart';
import '../widgets/muscle_group_selector.dart';

class CustomExerciseScreen extends StatefulWidget {
  @override
  _CustomExerciseScreenState createState() => _CustomExerciseScreenState();
}

class _CustomExerciseScreenState extends State<CustomExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedMuscleGroup = 'Chest';
  bool _isFavorite = false;
  String? _notes;
  final uuid = Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveExercise() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    
    final newExercise = Exercise(
      id: uuid.v4(),
      name: _nameController.text.trim(),
      muscleGroup: _selectedMuscleGroup,
      isFavorite: _isFavorite,
      notes: _notes,
      isCustom: true,
    );
    
    exerciseProvider.addExercise(newExercise);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exercise added successfully')),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Custom Exercise'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              
              // Muscle Group Selection
              Text(
                'Muscle Group',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              MuscleGroupSelector(
                muscleGroups: exerciseProvider.allMuscleGroups,
                selectedMuscleGroup: _selectedMuscleGroup,
                onMuscleGroupSelected: (muscleGroup) {
                  setState(() {
                    _selectedMuscleGroup = muscleGroup;
                  });
                },
              ),
              SizedBox(height: 24),
              
              // Favorite Checkbox
              CheckboxListTile(
                title: Text('Add to Favorites'),
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 24),
              
              // Notes Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _notes = value;
                },
              ),
              SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveExercise,
                  child: Text(
                    'Save Exercise',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
