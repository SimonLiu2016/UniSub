import 'package:flutter/foundation.dart';
import '../platform/platform_manager.dart';

/// 视频服务类，使用新的平台管理器架构
class VideoService {
  final PlatformManager _platformManager = PlatformManager();

  /// 支持的平台列表
  static const List<String> supportedPlatforms = [
    'youtube',
    'bilibili',
    'x', // Twitter
    'tiktok',
    'instagram',
    'facebook',
  ];

  /// 检查URL是否为支持的平台链接
  bool isSupportedPlatform(String url) {
    return _platformManager.getPlatformForUrl(url) != null;
  }

  /// 获取视频平台类型
  String getPlatformType(String url) {
    final platform = _platformManager.getPlatformForUrl(url);
    return platform?.platformName ?? 'unknown';
  }

  /// 下载视频
  Future<String> downloadVideo(
    String videoUrl,
    Function(double, String) onProgress,
  ) async {
    try {
      return await _platformManager.downloadVideo(videoUrl, (
        double progress,
        String status,
      ) {
        onProgress(progress, status);
      });
    } catch (e) {
      debugPrint('视频下载失败: $e');
      rethrow;
    }
  }

  /// 获取视频信息
  Future<Map<String, dynamic>> getVideoInfo(String videoUrl) async {
    try {
      return await _platformManager.getVideoInfo(videoUrl);
    } catch (e) {
      debugPrint('获取视频信息失败: $e');
      rethrow;
    }
  }

  /// 取消当前下载
  Future<void> cancelDownload(String videoUrl) async {
    try {
      await _platformManager.cancelDownload(videoUrl);
    } catch (e) {
      debugPrint('取消下载失败: $e');
      rethrow;
    }
  }
}
