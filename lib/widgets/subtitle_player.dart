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
    this.fontSize = 16.0,
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
      bottom: widget.position == 'bottom' ? 50 : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${_currentSubtitle!.speaker}: ${_currentSubtitle!.text}',
          style: TextStyle(
            fontFamily: widget.fontFamily,
            fontSize: widget.fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
