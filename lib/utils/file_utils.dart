import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  /// 选择文件
  static Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'avi', 'mov', 'mkv', 'mp3', 'wav', 'flac'],
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path;
    }

    return null;
  }

  /// 获取应用文档目录
  static Future<Directory> getDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// 获取应用支持目录
  static Future<Directory> getSupportDirectory() async {
    return await getApplicationSupportDirectory();
  }

  /// 获取临时目录
  static Future<Directory> getTemporaryDirectory() async {
    return await getTemporaryDirectory();
  }

  /// 获取UniSub字幕目录
  static Future<Directory> getSubtitleDirectory() async {
    final documentsDir = await getDocumentsDirectory();
    final subtitleDir = Directory(path.join(documentsDir.path, 'UniSub'));

    if (!await subtitleDir.exists()) {
      await subtitleDir.create(recursive: true);
    }

    return subtitleDir;
  }

  /// 获取文件扩展名
  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  /// 获取不带扩展名的文件名
  static String getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// 检查文件是否存在
  static Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }

  /// 删除文件
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 获取文件大小（字节）
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final stat = await file.stat();
      return stat.size;
    }
    return 0;
  }

  /// 格式化文件大小显示
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
