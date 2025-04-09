import 'package:flutter/material.dart';

class MuscleGroupSelector extends StatelessWidget {
  final List<String> muscleGroups;
  final String selectedMuscleGroup;
  final Function(String) onMuscleGroupSelected;

  const MuscleGroupSelector({
    Key? key,
    required this.muscleGroups,
    required this.selectedMuscleGroup,
    required this.onMuscleGroupSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: muscleGroups.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final muscleGroup = muscleGroups[index];
          final isSelected = selectedMuscleGroup == muscleGroup;
          
          return GestureDetector(
            onTap: () => onMuscleGroupSelected(muscleGroup),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: isSelected 
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
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
    );
  }
}
