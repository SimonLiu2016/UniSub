import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as path;

class ShareUtils {
  /// 分享字幕文件
  static Future<void> shareSubtitleFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await Share.shareXFiles([XFile(filePath)]);
    }
  }

  /// 分享多个字幕文件
  static Future<void> shareMultipleSubtitleFiles(List<String> filePaths) async {
    final xFiles = <XFile>[];

    for (final filePath in filePaths) {
      final file = File(filePath);
      if (await file.exists()) {
        xFiles.add(XFile(filePath));
      }
    }

    if (xFiles.isNotEmpty) {
      await Share.shareXFiles(xFiles);
    }
  }

  /// 分享字幕内容文本
  static Future<void> shareSubtitleText(String content, String fileName) async {
    await Share.share(content, subject: fileName);
  }

  /// 获取分享选项
  static List<Map<String, dynamic>> getShareOptions() {
    return [
      {'title': 'AirDrop', 'icon': 'airdrop'},
      {'title': '微信', 'icon': 'wechat'},
      {'title': 'LINE', 'icon': 'line'},
      {'title': '邮件', 'icon': 'email'},
      {'title': '复制链接', 'icon': 'link'},
    ];
  }
}
