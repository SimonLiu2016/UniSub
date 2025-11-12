import 'package:flutter_test/flutter_test.dart';
import 'package:unisub/utils/time_utils.dart';

void main() {
  group('TimeUtils', () {
    test('should format time in SRT format correctly', () {
      expect(TimeUtils.formatTimeSrt(0), '00:00:00,000');
      expect(TimeUtils.formatTimeSrt(1.5), '00:00:01,500');
      expect(TimeUtils.formatTimeSrt(61.25), '00:01:01,250');
      expect(TimeUtils.formatTimeSrt(3661.75), '01:01:01,750');
    });

    test('should format time in ASS format correctly', () {
      expect(TimeUtils.formatTimeAss(0), '0:00:00.00');
      expect(TimeUtils.formatTimeAss(1.5), '0:00:01.50');
      expect(TimeUtils.formatTimeAss(61.25), '0:01:01.25');
      expect(TimeUtils.formatTimeAss(3661.75), '1:01:01.75');
    });

    test('should format time in HMS format correctly', () {
      expect(TimeUtils.formatTimeHms(0), '00:00:00');
      expect(TimeUtils.formatTimeHms(1.5), '00:00:01');
      expect(TimeUtils.formatTimeHms(61.25), '00:01:01');
      expect(TimeUtils.formatTimeHms(3661.75), '01:01:01');
    });

    test('should parse SRT time format correctly', () {
      expect(TimeUtils.parseTimeSrt('00:00:00,000'), 0.0);
      expect(TimeUtils.parseTimeSrt('00:00:01,500'), 1.5);
      expect(TimeUtils.parseTimeSrt('00:01:01,250'), 61.25);
      expect(TimeUtils.parseTimeSrt('01:01:01,750'), 3661.75);
    });

    test('should parse ASS time format correctly', () {
      expect(TimeUtils.parseTimeAss('0:00:00.00'), 0.0);
      expect(TimeUtils.parseTimeAss('0:00:01.50'), 1.5);
      expect(TimeUtils.parseTimeAss('0:01:01.25'), 61.25);
      expect(TimeUtils.parseTimeAss('1:01:01.75'), 3661.75);
    });
  });
}
