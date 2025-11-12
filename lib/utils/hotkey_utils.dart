import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HotkeyUtils {
  static const String defaultHotkey = 'Cmd+Shift+S';

  /// 注册全局热键 (需要原生实现)
  static void registerGlobalHotkey() {
    if (Platform.isMacOS || Platform.isWindows) {
      // 全局热键需要通过原生代码实现
      // 可以使用Flutter插件如 "hotkey_manager" 或自定义原生代码
      // 这里只是一个占位符
    }
  }

  /// 注销全局热键
  static void unregisterGlobalHotkey() {
    // 注销全局热键
  }

  /// 处理热键事件
  static void handleHotkeyEvent(String hotkey) {
    switch (hotkey) {
      case 'Cmd+Shift+S':
        // 快速打开应用或显示主窗口
        break;
      default:
        // 处理其他热键
        break;
    }
  }

  /// 检查是否支持全局热键
  static bool supportsGlobalHotkeys() {
    return Platform.isMacOS || Platform.isWindows;
  }

  /// 获取默认热键组合
  static String getDefaultHotkey() {
    if (Platform.isMacOS) {
      return 'Cmd+Shift+S';
    } else if (Platform.isWindows) {
      return 'Ctrl+Shift+S';
    } else {
      return defaultHotkey;
    }
  }

  /// 验证热键组合是否有效
  static bool isValidHotkey(String hotkey) {
    // 简单验证热键格式
    final hotkeyRegex = RegExp(r'^(Cmd|Ctrl|Alt|Shift|\+)+[A-Z0-9]$');
    return hotkeyRegex.hasMatch(hotkey);
  }
}
