import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';
import '../utils/time_utils.dart';

class SubtitleTimeline extends StatefulWidget {
  final List<SubtitleSegment> subtitles;
  final int currentSubtitleIndex;
  final Function(int) onSubtitleTap;
  final Function(int, String) onSubtitleEdit;
  final Function(int, String) onSpeakerEdit;

  const SubtitleTimeline({
    super.key,
    required this.subtitles,
    required this.currentSubtitleIndex,
    required this.onSubtitleTap,
    required this.onSubtitleEdit,
    required this.onSpeakerEdit,
  });

  @override
  State<SubtitleTimeline> createState() => _SubtitleTimelineState();
}

class _SubtitleTimelineState extends State<SubtitleTimeline> {
  final Map<int, TextEditingController> _textControllers = {};
  final Map<int, TextEditingController> _speakerControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant SubtitleTimeline oldWidget) {
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
    return Container(
      color: const Color(0xFF1E1E1E),
      child: ListView.builder(
        itemCount: widget.subtitles.length,
        itemBuilder: (context, index) {
          final subtitle = widget.subtitles[index];
          final isCurrent = index == widget.currentSubtitleIndex;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isCurrent
                  ? const Color(0xFF2C2C2E)
                  : const Color(0xFF2C2C2E).withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCurrent ? const Color(0xFF007AFF) : Colors.transparent,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Row(
                children: [
                  // 说话人标签
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSpeakerColor(subtitle.speaker),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle.speaker,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 时间范围
                  Text(
                    '${TimeUtils.formatTimeMs(subtitle.startTime)} → ${TimeUtils.formatTimeMs(subtitle.endTime)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // 字幕文本
                  TextField(
                    controller: _textControllers[index],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => widget.onSubtitleEdit(index, value),
                  ),
                ],
              ),
              onTap: () => widget.onSubtitleTap(index),
            ),
          );
        },
      ),
    );
  }

  /// 根据说话人名称返回对应的颜色
  Color _getSpeakerColor(String speaker) {
    // 定义6种柔和的颜色
    final colors = [
      const Color(0xFF007AFF), // 蓝色
      const Color(0xFF34C759), // 绿色
      const Color(0xFFFF9500), // 橙色
      const Color(0xFFFF2D55), // 红色
      const Color(0xFFAF52DE), // 紫色
      const Color(0xFF5856D6), // 靛蓝色
    ];

    // 根据说话人名称的哈希值选择颜色
    final hash = speaker.hashCode.abs();
    return colors[hash % colors.length];
  }
}
