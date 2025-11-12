import 'package:flutter/material.dart';

class ProcessingStatusDisplay extends StatelessWidget {
  final String status;
  final double progress;
  final String detail;

  const ProcessingStatusDisplay({
    super.key,
    required this.status,
    required this.progress,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(status, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(detail, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
