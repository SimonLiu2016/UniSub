import 'package:flutter_test/flutter_test.dart';
import 'package:unisub/models/subtitle_segment.dart';

void main() {
  group('SubtitleSegment', () {
    test('should create instance with correct values', () {
      final segment = SubtitleSegment(
        id: 1,
        startTime: 10.5,
        endTime: 15.8,
        text: 'Hello world',
        speaker: 'Speaker 1',
      );

      expect(segment.id, 1);
      expect(segment.startTime, 10.5);
      expect(segment.endTime, 15.8);
      expect(segment.text, 'Hello world');
      expect(segment.speaker, 'Speaker 1');
    });

    test('should convert to and from JSON', () {
      final originalSegment = SubtitleSegment(
        id: 2,
        startTime: 20.3,
        endTime: 25.7,
        text: 'Test text',
        speaker: 'Speaker 2',
      );

      final json = originalSegment.toJson();
      final restoredSegment = SubtitleSegment.fromJson(json);

      expect(restoredSegment.id, originalSegment.id);
      expect(restoredSegment.startTime, originalSegment.startTime);
      expect(restoredSegment.endTime, originalSegment.endTime);
      expect(restoredSegment.text, originalSegment.text);
      expect(restoredSegment.speaker, originalSegment.speaker);
    });

    test('should format toString correctly', () {
      final segment = SubtitleSegment(
        id: 3,
        startTime: 30.1,
        endTime: 35.9,
        text: 'Another test',
        speaker: 'Speaker 3',
      );

      final expectedString =
          'SubtitleSegment(id: 3, startTime: 30.1, endTime: 35.9, text: Another test, speaker: Speaker 3)';
      expect(segment.toString(), expectedString);
    });
  });
}
