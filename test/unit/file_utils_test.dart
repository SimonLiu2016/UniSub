import 'package:flutter_test/flutter_test.dart';
import 'package:unisub/utils/file_utils.dart';

void main() {
  group('FileUtils', () {
    test('should get file extension correctly', () {
      expect(FileUtils.getFileExtension('/path/to/file.mp4'), '.mp4');
      expect(FileUtils.getFileExtension('/path/to/file.MP4'), '.mp4');
      expect(FileUtils.getFileExtension('/path/to/file'), '');
    });

    test('should get file name without extension correctly', () {
      expect(
        FileUtils.getFileNameWithoutExtension('/path/to/file.mp4'),
        'file',
      );
      expect(FileUtils.getFileNameWithoutExtension('/path/to/file'), 'file');
      expect(FileUtils.getFileNameWithoutExtension('file.mp4'), 'file');
    });

    test('should format file size correctly', () {
      expect(FileUtils.formatFileSize(512), '512 B');
      expect(FileUtils.formatFileSize(1024), '1.0 KB');
      expect(FileUtils.formatFileSize(1024 * 1024), '1.0 MB');
      expect(FileUtils.formatFileSize(1024 * 1024 * 1024), '1.0 GB');
    });
  });
}
