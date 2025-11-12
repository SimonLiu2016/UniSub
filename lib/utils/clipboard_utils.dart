import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class ClipboardUtils {
  static Timer? _clipboardTimer;
  static String? _lastClipboardContent;

  /// 获取剪贴板内容
  static Future<String?> getClipboardText() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data?.text;
    } catch (e) {
      return null;
    }
  }

  /// 检查剪贴板内容是否为有效的视频URL
  static bool isValidVideoUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    final videoUrlRegex = RegExp(
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be|bilibili\.com|twitter\.com|x\.com|tiktok\.com|instagram\.com|facebook\.com)\/.+',
      caseSensitive: false,
    );

    return videoUrlRegex.hasMatch(url);
  }

  /// 开始监听剪贴板变化
  static void startClipboardMonitoring(Function(String) onValidUrlDetected) {
    _clipboardTimer?.cancel();
    _clipboardTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final clipboardContent = await getClipboardText();

      if (clipboardContent != null &&
          clipboardContent != _lastClipboardContent &&
          isValidVideoUrl(clipboardContent)) {
        _lastClipboardContent = clipboardContent;
        onValidUrlDetected(clipboardContent);
      }
    });
  }

  /// 停止监听剪贴板变化
  static void stopClipboardMonitoring() {
    _clipboardTimer?.cancel();
    _clipboardTimer = null;
    _lastClipboardContent = null;
  }

  /// 设置剪贴板内容
  static Future<void> setClipboardText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
