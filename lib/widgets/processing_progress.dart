import 'package:flutter/material.dart';

class ProcessingProgress extends StatelessWidget {
  final double progress;
  final String status;
  final String detail;

  const ProcessingProgress({
    super.key,
    required this.progress,
    required this.status,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(value: progress),
        const SizedBox(height: 16),
        Text(status, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(detail, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        // 进度百分比
        Text(
          '${(progress * 100).round()}%',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
