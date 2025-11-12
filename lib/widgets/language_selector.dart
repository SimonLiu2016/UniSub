import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;
  final List<Map<String, String>> languages;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.languages,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      items: languages.map((language) {
        return DropdownMenuItem<String>(
          value: language['code'],
          child: Text(language['name']!),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onLanguageChanged(value);
        }
      },
    );
  }
}
