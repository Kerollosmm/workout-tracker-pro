import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ThemeSelector({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<bool>(
          title: Text('Light Mode'),
          value: false,
          groupValue: isDarkMode,
          onChanged: (value) {
            if (value != null) {
              onThemeChanged(value);
            }
          },
        ),
        RadioListTile<bool>(
          title: Text('Dark Mode'),
          value: true,
          groupValue: isDarkMode,
          onChanged: (value) {
            if (value != null) {
              onThemeChanged(value);
            }
          },
        ),
      ],
    );
  }
}
