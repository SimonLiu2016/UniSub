import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static const String _settingsFileName = 'settings.json';

  // 默认设置
  static const Map<String, dynamic> _defaultSettings = {
    'language': 'zh_TW',
    'theme': 'system',
    'model': 'medium',
    'subtitleFont': 'NotoSansTC',
    'subtitleFontSize': 16,
    'subtitleColor': '#FFFFFF',
    'subtitlePosition': 'bottom',
    'translateTarget': 'zh_TW',
    'realtimeTranslation': true,
    'translationPostProcessing': true,
    'onlineVideoSupport': true,
    'downloadSpeedLimit': 0, // 0表示无限制
    'cacheCleanupPeriod': 7, // 天
  };

  /// 获取设置文件路径
  Future<String> _getSettingsFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, _settingsFileName);
  }

  /// 读取设置
  Future<Map<String, dynamic>> readSettings() async {
    try {
      final filePath = await _getSettingsFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final content = await file.readAsString();
        final settings = jsonDecode(content);
        return _mergeWithDefaults(settings);
      } else {
        // 如果设置文件不存在，创建默认设置文件
        await writeSettings(_defaultSettings);
        return Map<String, dynamic>.from(_defaultSettings);
      }
    } catch (e) {
      // 如果读取失败，返回默认设置
      return Map<String, dynamic>.from(_defaultSettings);
    }
  }

  /// 写入设置
  Future<void> writeSettings(Map<String, dynamic> settings) async {
    final filePath = await _getSettingsFilePath();
    final file = File(filePath);
    final content = jsonEncode(settings);
    await file.writeAsString(content);
  }

  /// 更新单个设置项
  Future<void> updateSetting(String key, dynamic value) async {
    final settings = await readSettings();
    settings[key] = value;
    await writeSettings(settings);
  }

  /// 获取特定设置项的值
  Future<dynamic> getSetting(String key) async {
    final settings = await readSettings();
    return settings[key];
  }

  /// 合并默认设置和用户设置
  Map<String, dynamic> _mergeWithDefaults(Map<String, dynamic> userSettings) {
    final mergedSettings = Map<String, dynamic>.from(_defaultSettings);

    // 用用户设置覆盖默认设置
    userSettings.forEach((key, value) {
      if (_defaultSettings.containsKey(key)) {
        mergedSettings[key] = value;
      }
    });

    return mergedSettings;
  }
}
