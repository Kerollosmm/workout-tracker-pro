import 'package:flutter/material.dart';

class UnitsSelector extends StatelessWidget {
  final String selectedUnit;
  final Function(String) onUnitChanged;

  const UnitsSelector({
    Key? key,
    required this.selectedUnit,
    required this.onUnitChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final units = [
      {'code': 'kg', 'name': 'Kilograms (kg)'},
      {'code': 'lbs', 'name': 'Pounds (lbs)'},
    ];
    
    return Column(
      children: units.map((unit) {
        final isSelected = selectedUnit == unit['code'];
        return RadioListTile<String>(
          title: Text(unit['name']!),
          value: unit['code']!,
          groupValue: selectedUnit,
          onChanged: (value) {
            if (value != null) {
              onUnitChanged(value);
            }
          },
        );
      }).toList(),
    );
  }
}
