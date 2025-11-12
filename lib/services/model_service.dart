import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ModelService {
  static const String _modelsDirName = 'models';

  /// 获取模型目录路径
  Future<Directory> getModelsDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final modelsDir = Directory(path.join(appDir.path, _modelsDirName));
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  /// 检查模型是否存在
  Future<bool> isModelExists(String modelName) async {
    final modelsDir = await getModelsDirectory();
    final modelPath = path.join(modelsDir.path, '$modelName.bin');
    return File(modelPath).existsSync();
  }

  /// 获取模型文件路径
  Future<String> getModelPath(String modelName) async {
    final modelsDir = await getModelsDirectory();
    return path.join(modelsDir.path, '$modelName.bin');
  }

  /// 下载模型（模拟实现）
  Future<void> downloadModel(
    String modelName,
    Function(double) onProgress,
  ) async {
    // 这里应该是实际的模型下载实现
    // 暂时模拟下载过程

    // 模拟下载进度
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      onProgress(i / 100);
    }

    // 创建一个模拟的模型文件
    final modelPath = await getModelPath(modelName);
    final file = File(modelPath);
    await file.writeAsString('Simulated model content for $modelName');
  }

  /// 删除模型
  Future<void> deleteModel(String modelName) async {
    final modelPath = await getModelPath(modelName);
    final file = File(modelPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// 获取已下载的模型列表
  Future<List<String>> getDownloadedModels() async {
    final modelsDir = await getModelsDirectory();
    final files = modelsDir.listSync();
    final modelNames = <String>[];

    for (final file in files) {
      if (file is File && file.path.endsWith('.bin')) {
        final fileName = path.basenameWithoutExtension(file.path);
        modelNames.add(fileName);
      }
    }

    return modelNames;
  }
}
