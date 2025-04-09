import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';

class SetInputCard extends StatelessWidget {
  final int setNumber;
  final double weight;
  final int reps;
  final Function(double) onWeightChanged;
  final Function(int) onRepsChanged;
  final VoidCallback onDelete;

  const SetInputCard({
    Key? key,
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.onWeightChanged,
    required this.onRepsChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final weightUnit = settingsProvider.weightUnit;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Text(
              'Set $setNumber',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          
          // Weight input
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  border: OutlineInputBorder(),
                  suffixText: weightUnit,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: weight > 0 ? weight.toString() : '',
                onChanged: (value) {
                  final parsedValue = double.tryParse(value) ?? 0;
                  onWeightChanged(parsedValue);
                },
              ),
            ),
          ),
          
          // Reps input
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextFormField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: reps > 0 ? reps.toString() : '',
                onChanged: (value) {
                  final parsedValue = int.tryParse(value) ?? 0;
                  onRepsChanged(parsedValue);
                },
              ),
            ),
          ),
          
          // Delete button
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red[300], size: 20),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
