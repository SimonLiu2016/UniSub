import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class DragDropPlaceholder extends StatelessWidget {
  final Function(String) onFileDropped;

  const DragDropPlaceholder({super.key, required this.onFileDropped});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 80,
            color: Colors.grey.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            localizations.dragHint,
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.orText} ${localizations.selectFile}',
            style: TextStyle(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.withOpacity(0.7)
                  : Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
