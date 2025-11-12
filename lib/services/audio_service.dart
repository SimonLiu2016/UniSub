import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AudioService {
  static const String _tempDirName = 'temp';

  /// 获取临时目录路径
  Future<Directory> getTempDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final appTempDir = Directory(path.join(tempDir.path, _tempDirName));
    if (!await appTempDir.exists()) {
      await appTempDir.create(recursive: true);
    }
    return appTempDir;
  }

  /// 保存音频文件到临时目录
  Future<File> saveAudioToTemp(String fileName, List<int> audioData) async {
    final tempDir = await getTempDirectory();
    final filePath = path.join(tempDir.path, fileName);
    final file = File(filePath);
    return await file.writeAsBytes(audioData);
  }

  /// 清理临时目录
  Future<void> clearTempDirectory() async {
    final tempDir = await getTempDirectory();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      await tempDir.create(recursive: true);
    }
  }

  /// 获取临时目录中的文件
  Future<List<FileSystemEntity>> getTempFiles() async {
    final tempDir = await getTempDirectory();
    return tempDir.listSync();
  }
}
