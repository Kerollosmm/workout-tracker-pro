import 'package:flutter/material.dart';
import '../../../core/models/exercise.dart';

class ExerciseSelector extends StatefulWidget {
  final List<Exercise> exercises;

  const ExerciseSelector({
    Key? key,
    required this.exercises,
  }) : super(key: key);

  @override
  _ExerciseSelectorState createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  String _searchQuery = '';
  String _selectedMuscleGroup = 'All';
  
  List<Exercise> get filteredExercises {
    List<Exercise> result = widget.exercises;
    
    // Filter by muscle group if not "All"
    if (_selectedMuscleGroup != 'All') {
      result = result.where((e) => e.muscleGroup == _selectedMuscleGroup).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      result = result.where((e) => 
        e.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final muscleGroups = ['All', ...widget.exercises
      .map((e) => e.muscleGroup)
      .toSet()
      .toList()..sort()];
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Exercise',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Exercises...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Muscle group filter
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: muscleGroups.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final muscleGroup = muscleGroups[index];
                final isSelected = _selectedMuscleGroup == muscleGroup;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMuscleGroup = muscleGroup;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      muscleGroup,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Exercise list
          Expanded(
            child: filteredExercises.isEmpty
                ? Center(
                    child: Text('No exercises found'),
                  )
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return ListTile(
                        leading: Icon(Icons.fitness_center), // Replaced image with icon
                        title: Text(exercise.name),
                        subtitle: Text(exercise.muscleGroup),
                        trailing: exercise.isFavorite
                            ? Icon(Icons.star, color: Colors.amber)
                            : null,
                        onTap: () {
                          Navigator.pop(context, exercise);
                        },
                      );
                    },
                  ),
          ),
          
          // "Add Custom Exercise" button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_exercise');
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Custom Exercise'),
                  ],
                ),
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
    );
  }
}
