import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';

class SubtitleTimeline extends StatelessWidget {
  final List<SubtitleSegment> subtitles;
  final double totalTime;
  final double currentPosition;
  final Function(SubtitleSegment) onSubtitleTap;

  const SubtitleTimeline({
    super.key,
    required this.subtitles,
    required this.totalTime,
    required this.currentPosition,
    required this.onSubtitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: _TimelinePainter(
          subtitles: subtitles,
          totalTime: totalTime,
          currentPosition: currentPosition,
        ),
        child: GestureDetector(
          onTapUp: (details) {
            // 处理点击事件
          },
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final List<SubtitleSegment> subtitles;
  final double totalTime;
  final double currentPosition;

  _TimelinePainter({
    required this.subtitles,
    required this.totalTime,
    required this.currentPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2;

    // 绘制时间轴线
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // 绘制当前播放位置指示器
    final currentPositionX = (currentPosition / totalTime) * size.width;
    paint.color = Colors.blue;
    paint.strokeWidth = 3;
    canvas.drawLine(
      Offset(currentPositionX, 0),
      Offset(currentPositionX, size.height),
      paint,
    );

    // 绘制字幕片段
    for (final subtitle in subtitles) {
      final startX = (subtitle.startTime / totalTime) * size.width;
      final endX = (subtitle.endTime / totalTime) * size.width;
      final segmentWidth = endX - startX;

      paint.color = Colors.blue[200]!;
      paint.strokeWidth = 20;

      // 绘制字幕片段
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(endX, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
