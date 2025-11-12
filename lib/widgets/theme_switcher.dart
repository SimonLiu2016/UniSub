import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final String selectedTheme;
  final Function(String) onThemeChanged;

  const ThemeSwitcher({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTheme,
      items: const [
        DropdownMenuItem(value: 'system', child: Text('跟随系统')),
        DropdownMenuItem(value: 'light', child: Text('浅色')),
        DropdownMenuItem(value: 'dark', child: Text('深色')),
      ],
      onChanged: (value) {
        if (value != null) {
          onThemeChanged(value);
        }
      },
    );
  }
}
