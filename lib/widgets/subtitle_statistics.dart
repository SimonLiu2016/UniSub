import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';

class SubtitleStatistics extends StatelessWidget {
  final List<SubtitleSegment> subtitles;

  const SubtitleStatistics({super.key, required this.subtitles});

  @override
  Widget build(BuildContext context) {
    final totalSegments = subtitles.length;
    final totalWords = _calculateTotalWords();
    final totalDuration = _calculateTotalDuration();
    final averageWordsPerSegment = totalSegments > 0
        ? totalWords / totalSegments
        : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('字幕统计', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildStatItem(context, '字幕段数', '$totalSegments'),
            _buildStatItem(context, '总词数', '$totalWords'),
            _buildStatItem(context, '总时长', _formatDuration(totalDuration)),
            _buildStatItem(
              context,
              '平均每段词数',
              averageWordsPerSegment.toStringAsFixed(1),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalWords() {
    int total = 0;
    for (final subtitle in subtitles) {
      total += subtitle.text.split(' ').length;
    }
    return total;
  }

  double _calculateTotalDuration() {
    double total = 0;
    for (final subtitle in subtitles) {
      total += subtitle.endTime - subtitle.startTime;
    }
    return total;
  }

  String _formatDuration(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else {
      return '${minutes}m ${secs}s';
    }
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
