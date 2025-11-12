import 'package:flutter/material.dart';

class DownloadProgressBar extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;

  const DownloadProgressBar({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
