import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    Key? key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'ar', 'name': 'Arabic'},
      // Add more languages as needed
    ];
    
    return Column(
      children: languages.map((language) {
        final isSelected = selectedLanguage == language['code'];
        return RadioListTile<String>(
          title: Text(language['name']!),
          value: language['code']!,
          groupValue: selectedLanguage,
          onChanged: (value) {
            if (value != null) {
              onLanguageChanged(value);
            }
          },
        );
      }).toList(),
    );
  }
}
