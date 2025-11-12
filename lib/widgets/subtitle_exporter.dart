import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';
import '../services/subtitle_service.dart';
import '../utils/share_utils.dart';

class SubtitleExporter extends StatefulWidget {
  final List<SubtitleSegment> subtitles;

  const SubtitleExporter({super.key, required this.subtitles});

  @override
  State<SubtitleExporter> createState() => _SubtitleExporterState();
}

class _SubtitleExporterState extends State<SubtitleExporter> {
  final SubtitleService _subtitleService = SubtitleService();
  bool _isExporting = false;
  String _exportStatus = '';

  Future<void> _exportSubtitles(String format) async {
    setState(() {
      _isExporting = true;
      _exportStatus = '正在导出为 $format 格式...';
    });

    try {
      final filePath = await _subtitleService.saveSubtitle(
        widget.subtitles,
        format,
        'unisub_export',
      );

      setState(() {
        _isExporting = false;
        _exportStatus = '导出完成: $filePath';
      });

      if (mounted) {
        // 显示导出成功消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('字幕已导出到: $filePath'),
            action: SnackBarAction(
              label: '分享',
              onPressed: () => ShareUtils.shareSubtitleFile(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportStatus = '导出失败: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isExporting)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(_exportStatus),
              ],
            ),
          ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.save),
          onSelected: _exportSubtitles,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'srt', child: Text('导出为 SRT')),
            PopupMenuItem(value: 'vtt', child: Text('导出为 VTT')),
            PopupMenuItem(value: 'ass', child: Text('导出为 ASS')),
          ],
        ),
      ],
    );
  }
}
