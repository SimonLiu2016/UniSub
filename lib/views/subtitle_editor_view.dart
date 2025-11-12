import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../models/subtitle_segment.dart';
import '../services/subtitle_service.dart';
import '../widgets/subtitle_exporter.dart';

class SubtitleEditorView extends StatefulWidget {
  final List<SubtitleSegment> subtitles;
  final Function(List<SubtitleSegment>) onSubtitlesUpdated;

  const SubtitleEditorView({
    super.key,
    required this.subtitles,
    required this.onSubtitlesUpdated,
  });

  @override
  State<SubtitleEditorView> createState() => _SubtitleEditorViewState();
}

class _SubtitleEditorViewState extends State<SubtitleEditorView> {
  late List<SubtitleSegment> _editableSubtitles;
  final SubtitleService _subtitleService = SubtitleService();

  @override
  void initState() {
    super.initState();
    _editableSubtitles = List.from(widget.subtitles);
  }

  void _updateSubtitle(int index, String newText) {
    setState(() {
      _editableSubtitles[index] = SubtitleSegment(
        id: _editableSubtitles[index].id,
        startTime: _editableSubtitles[index].startTime,
        endTime: _editableSubtitles[index].endTime,
        text: newText,
        speaker: _editableSubtitles[index].speaker,
      );
    });
  }

  void _updateSpeaker(int index, String newSpeaker) {
    setState(() {
      _editableSubtitles[index] = SubtitleSegment(
        id: _editableSubtitles[index].id,
        startTime: _editableSubtitles[index].startTime,
        endTime: _editableSubtitles[index].endTime,
        text: _editableSubtitles[index].text,
        speaker: newSpeaker,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('字幕编辑'),
        actions: [
          // 导出按钮
          SubtitleExporter(subtitles: _editableSubtitles),
        ],
      ),
      body: ListView.builder(
        itemCount: _editableSubtitles.length,
        itemBuilder: (context, index) {
          final subtitle = _editableSubtitles[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时间信息
                  Text(
                    '${_formatTime(subtitle.startTime)} --> ${_formatTime(subtitle.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),

                  // 讲者编辑
                  Row(
                    children: [
                      Text('${localizations.speakerPrefix}: '),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: subtitle.speaker,
                          ),
                          onChanged: (value) => _updateSpeaker(index, value),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 字幕文本编辑
                  TextField(
                    controller: TextEditingController(text: subtitle.text),
                    onChanged: (value) => _updateSubtitle(index, value),
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '输入字幕文本...',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 保存并返回更新后的字幕
          widget.onSubtitlesUpdated(_editableSubtitles);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
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
