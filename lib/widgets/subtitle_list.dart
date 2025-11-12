import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';
import '../localization/app_localizations.dart';

class SubtitleList extends StatefulWidget {
  final List<SubtitleSegment> subtitles;
  final int currentSubtitleIndex;
  final Function(int) onSubtitleTap;
  final Function(int, String) onSubtitleEdit;
  final Function(int, String) onSpeakerEdit;

  const SubtitleList({
    super.key,
    required this.subtitles,
    required this.currentSubtitleIndex,
    required this.onSubtitleTap,
    required this.onSubtitleEdit,
    required this.onSpeakerEdit,
  });

  @override
  State<SubtitleList> createState() => _SubtitleListState();
}

class _SubtitleListState extends State<SubtitleList> {
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, TextEditingController> _speakerControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant SubtitleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subtitles.length != widget.subtitles.length) {
      _initializeControllers();
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    for (final controller in _speakerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    // 清理旧的控制器
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    for (final controller in _speakerControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    _speakerControllers.clear();

    // 为每个字幕创建控制器
    for (int i = 0; i < widget.subtitles.length; i++) {
      final subtitle = widget.subtitles[i];
      _textControllers[i] = TextEditingController(text: subtitle.text);
      _speakerControllers[i] = TextEditingController(text: subtitle.speaker);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return ListView.builder(
      itemCount: widget.subtitles.length,
      itemBuilder: (context, index) {
        final subtitle = widget.subtitles[index];
        final isCurrent = index == widget.currentSubtitleIndex;

        return Card(
          margin: const EdgeInsets.all(8),
          elevation: isCurrent ? 4 : 2,
          color: isCurrent
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: ListTile(
            title: Row(
              children: [
                Text('${localizations.speakerPrefix}: '),
                Expanded(
                  child: TextField(
                    controller: _speakerControllers[index],
                    onChanged: (value) => widget.onSpeakerEdit(index, value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatTime(subtitle.startTime)),
                const SizedBox(height: 4),
                TextField(
                  controller: _textControllers[index],
                  onChanged: (value) => widget.onSubtitleEdit(index, value),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '输入字幕文本...',
                  ),
                ),
              ],
            ),
            onTap: () => widget.onSubtitleTap(index),
          ),
        );
      },
    );
  }

  /// 格式化时间为 HH:MM:SS 格式
  String _formatTime(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
