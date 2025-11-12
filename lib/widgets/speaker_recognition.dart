import 'package:flutter/material.dart';
import '../models/subtitle_segment.dart';

class SpeakerRecognition extends StatefulWidget {
  final List<SubtitleSegment> subtitles;
  final Function(List<SubtitleSegment>) onSpeakersUpdated;

  const SpeakerRecognition({
    super.key,
    required this.subtitles,
    required this.onSpeakersUpdated,
  });

  @override
  State<SpeakerRecognition> createState() => _SpeakerRecognitionState();
}

class _SpeakerRecognitionState extends State<SpeakerRecognition> {
  late List<SubtitleSegment> _subtitles;
  final Map<String, String> _speakerMap = {};
  int _nextSpeakerId = 1;

  @override
  void initState() {
    super.initState();
    _subtitles = List.from(widget.subtitles);
    _initializeSpeakers();
  }

  void _initializeSpeakers() {
    // 初始化说话人标签
    for (final subtitle in _subtitles) {
      if (!_speakerMap.containsKey(subtitle.speaker)) {
        _speakerMap[subtitle.speaker] = '講者 $_nextSpeakerId';
        _nextSpeakerId++;
      }
    }

    // 更新字幕说话人标签
    for (int i = 0; i < _subtitles.length; i++) {
      final originalSpeaker = _subtitles[i].speaker;
      if (_speakerMap.containsKey(originalSpeaker)) {
        _subtitles[i] = SubtitleSegment(
          id: _subtitles[i].id,
          startTime: _subtitles[i].startTime,
          endTime: _subtitles[i].endTime,
          text: _subtitles[i].text,
          speaker: _speakerMap[originalSpeaker]!,
        );
      }
    }
  }

  void _updateSpeaker(String oldSpeaker, String newSpeaker) {
    setState(() {
      _speakerMap[oldSpeaker] = newSpeaker;

      // 更新所有使用该说话人的字幕
      for (int i = 0; i < _subtitles.length; i++) {
        if (_subtitles[i].speaker == oldSpeaker) {
          _subtitles[i] = SubtitleSegment(
            id: _subtitles[i].id,
            startTime: _subtitles[i].startTime,
            endTime: _subtitles[i].endTime,
            text: _subtitles[i].text,
            speaker: newSpeaker,
          );
        }
      }
    });

    // 通知父组件更新
    widget.onSpeakersUpdated(_subtitles);
  }

  void _autoClusterSpeakers() {
    setState(() {
      // 这里应该是实际的说话人聚类算法实现
      // 暂时使用简单的模拟实现
      _speakerMap.clear();
      _nextSpeakerId = 1;

      // 模拟聚类结果
      for (int i = 0; i < _subtitles.length; i++) {
        final speakerKey = 'speaker_${i % 3}'; // 模拟3个说话人
        if (!_speakerMap.containsKey(speakerKey)) {
          _speakerMap[speakerKey] = '講者 $_nextSpeakerId';
          _nextSpeakerId++;
        }

        _subtitles[i] = SubtitleSegment(
          id: _subtitles[i].id,
          startTime: _subtitles[i].startTime,
          endTime: _subtitles[i].endTime,
          text: _subtitles[i].text,
          speaker: _speakerMap[speakerKey]!,
        );
      }
    });

    // 通知父组件更新
    widget.onSpeakersUpdated(_subtitles);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('说话人识别', style: Theme.of(context).textTheme.titleMedium),
                ElevatedButton(
                  onPressed: _autoClusterSpeakers,
                  child: const Text('自动识别'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._speakerMap.entries.map((entry) {
              return _buildSpeakerItem(entry.key, entry.value);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerItem(String originalSpeaker, String displaySpeaker) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$originalSpeaker → '),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: displaySpeaker),
              onChanged: (value) => _updateSpeaker(originalSpeaker, value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
