import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformUtils {
  /// 检查是否为macOS平台
  static bool isMacOS() {
    return Platform.isMacOS;
  }

  /// 检查是否为Windows平台
  static bool isWindows() {
    return Platform.isWindows;
  }

  /// 检查是否为Linux平台
  static bool isLinux() {
    return Platform.isLinux;
  }

  /// 获取当前平台名称
  static String getPlatformName() {
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }

  /// 获取macOS版本信息
  static Future<String> getMacOSVersion() async {
    if (!Platform.isMacOS) return 'Not macOS';

    try {
      final result = await Process.run('sw_vers', ['-productVersion']);
      return result.stdout.toString().trim();
    } catch (e) {
      return 'Unknown';
    }
  }

  /// 检查是否支持原生菜单栏 (macOS)
  static bool supportsNativeMenuBar() {
    return Platform.isMacOS;
  }

  /// 检查是否支持Touch Bar (macOS)
  static bool supportsTouchBar() {
    return Platform.isMacOS;
  }

  /// 检查是否支持深色模式
  static bool supportsDarkMode() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// 检查是否支持系统通知
  static bool supportsSystemNotifications() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  /// 获取应用数据目录
  static String getAppDataDirectory() {
    if (Platform.isMacOS) {
      return '${Platform.environment['HOME']}/Library/Application Support';
    } else if (Platform.isWindows) {
      return Platform.environment['APPDATA'] ?? '';
    } else {
      return Platform.environment['HOME'] ?? '';
    }
  }

  /// 检查是否支持全局热键
  static bool supportsGlobalHotkeys() {
    return Platform.isMacOS || Platform.isWindows;
  }
}
