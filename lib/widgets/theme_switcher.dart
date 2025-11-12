import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedTheme,
        items: [
          DropdownMenuItem(
            value: 'system',
            child: Text(localizations.systemTheme),
          ),
          DropdownMenuItem(
            value: 'light',
            child: Text(localizations.lightTheme),
          ),
          DropdownMenuItem(value: 'dark', child: Text(localizations.darkTheme)),
        ],
        onChanged: (value) {
          if (value != null) {
            onThemeChanged(value);
          }
        },
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }
}
