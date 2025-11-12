import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import '../models/subtitle_segment.dart';
import '../utils/time_utils.dart';

class SubtitleService {
  /// 生成SRT格式字幕
  String generateSrt(List<SubtitleSegment> segments) {
    final buffer = StringBuffer();

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      buffer.writeln('${i + 1}');
      buffer.writeln(
        TimeUtils.formatTimeSrt(segment.startTime) +
            ' --> ' +
            TimeUtils.formatTimeSrt(segment.endTime),
      );
      buffer.writeln('${segment.speaker}: ${segment.text}');
      buffer.writeln(); // 空行分隔
    }

    return buffer.toString();
  }

  /// 生成VTT格式字幕
  String generateVtt(List<SubtitleSegment> segments) {
    final buffer = StringBuffer();

    buffer.writeln('WEBVTT');
    buffer.writeln(); // 空行

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      buffer.writeln('${i + 1}');
      buffer.writeln(
        TimeUtils.formatTimeSrt(segment.startTime) +
            ' --> ' +
            TimeUtils.formatTimeSrt(segment.endTime),
      );
      buffer.writeln('${segment.speaker}: ${segment.text}');
      buffer.writeln(); // 空行分隔
    }

    return buffer.toString();
  }

  /// 生成ASS格式字幕
  String generateAss(List<SubtitleSegment> segments) {
    final buffer = StringBuffer();

    // ASS文件头
    buffer.writeln('[Script Info]');
    buffer.writeln('Title: UniSub Generated Subtitles');
    buffer.writeln('ScriptType: v4.00+');
    buffer.writeln('WrapStyle: 0');
    buffer.writeln('ScaledBorderAndShadow: yes');
    buffer.writeln();

    // V4+ Styles
    buffer.writeln('[V4+ Styles]');
    buffer.writeln(
      'Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding',
    );
    buffer.writeln(
      'Style: Default,Noto Sans TC,20,&H00FFFFFF,&H000000FF,&H00000000,&H00000000,0,0,0,0,100,100,0,0,1,2,1,2,10,10,10,1',
    );
    buffer.writeln();

    // Events
    buffer.writeln('[Events]');
    buffer.writeln(
      'Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text',
    );

    for (final segment in segments) {
      buffer.writeln(
        'Dialogue: 0,${TimeUtils.formatTimeAss(segment.startTime)},${TimeUtils.formatTimeAss(segment.endTime)},Default,${segment.speaker},0,0,0,,${segment.text}',
      );
    }

    return buffer.toString();
  }

  /// 保存字幕到文件
  Future<String> saveSubtitle(
    List<SubtitleSegment> segments,
    String format,
    String fileName,
  ) async {
    String content;

    switch (format.toLowerCase()) {
      case 'srt':
        content = generateSrt(segments);
        break;
      case 'vtt':
        content = generateVtt(segments);
        break;
      case 'ass':
        content = generateAss(segments);
        break;
      default:
        throw Exception('Unsupported subtitle format: $format');
    }

    // 获取文档目录
    final documentsDir = await _getDocumentsDirectory();
    final subDir = Directory(path.join(documentsDir.path, 'UniSub'));

    if (!await subDir.exists()) {
      await subDir.create(recursive: true);
    }

    final filePath = path.join(subDir.path, '$fileName.$format');
    final file = File(filePath);
    await file.writeAsString(content, encoding: utf8);

    return filePath;
  }

  /// 获取文档目录
  Future<Directory> _getDocumentsDirectory() async {
    // 在实际应用中，这里应该使用path_provider获取文档目录
    // 暂时返回一个临时目录作为示例
    return Directory.systemTemp;
  }
}
