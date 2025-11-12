import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';

class SubtitlePlayer extends StatefulWidget {
  final List<SubtitleSegment> subtitles;
  final double videoPosition;
  final String fontFamily;
  final double fontSize;
  final String position; // 'top' or 'bottom'

  const SubtitlePlayer({
    super.key,
    required this.subtitles,
    required this.videoPosition,
    this.fontFamily = 'NotoSansTC',
    this.fontSize = 18.0, // 默认字体大小改为18pt
    this.position = 'bottom',
  });

  @override
  State<SubtitlePlayer> createState() => _SubtitlePlayerState();
}

class _SubtitlePlayerState extends State<SubtitlePlayer> {
  SubtitleSegment? _currentSubtitle;

  @override
  Widget build(BuildContext context) {
    _updateCurrentSubtitle();

    if (_currentSubtitle == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 20,
      right: 20,
      top: widget.position == 'top' ? 50 : null,
      bottom: widget.position == 'bottom' ? 100 : null, // 调整到底部100px区域
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x88000000), // 半透明黑底 #00000088
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${_currentSubtitle!.speaker}: ${_currentSubtitle!.text}',
          style: TextStyle(
            fontFamily: widget.fontFamily,
            fontSize: widget.fontSize,
            color: Colors.white,
            fontWeight: FontWeight.normal, // 改为正常字重
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _updateCurrentSubtitle() {
    for (final subtitle in widget.subtitles) {
      if (widget.videoPosition >= subtitle.startTime &&
          widget.videoPosition <= subtitle.endTime) {
        if (_currentSubtitle?.id != subtitle.id) {
          setState(() {
            _currentSubtitle = subtitle;
          });
        }
        return;
      }
    }

    // 如果没有找到匹配的字幕，清除当前字幕
    if (_currentSubtitle != null) {
      setState(() {
        _currentSubtitle = null;
      });
    }
  }
}
