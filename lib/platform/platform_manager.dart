import 'platforms/youtube/youtube_platform.dart';
import 'platforms/bilibili/bilibili_platform.dart';
import 'platforms/twitter/twitter_platform.dart';
import 'platforms/tiktok/tiktok_platform.dart';
import 'platforms/instagram/instagram_platform.dart';
import 'platforms/facebook/facebook_platform.dart';
import 'platforms/generic/generic_platform.dart';
import 'base/video_platform_base.dart';
import 'interface/platform_interface.dart';
import 'macos/platform_macos.dart';

class PlatformManager {
  static final PlatformManager _instance = PlatformManager._internal();

  factory PlatformManager() => _instance;

  PlatformManager._internal();

  final PlatformVideoInterface _platformInterface = MacOSPlatformVideo();

  final List<VideoPlatformBase> _platforms = [
    YouTubePlatform(),
    BilibiliPlatform(),
    TwitterPlatform(),
    TikTokPlatform(),
    InstagramPlatform(),
    FacebookPlatform(),
    GenericPlatform(), // Generic should be last
  ];

  /// Get the appropriate platform for a given URL
  VideoPlatformBase? getPlatformForUrl(String url) {
    for (var platform in _platforms) {
      if (platform.isValidUrl(url)) {
        return platform;
      }
    }
    return null;
  }

  /// Download video using the appropriate platform
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    final platform = getPlatformForUrl(url);
    if (platform == null) {
      throw Exception('Unsupported video platform');
    }

    return await _platformInterface.downloadVideo(
      url,
      platform.platformName,
      onProgress,
    );
  }

  /// Get video information
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    final platform = getPlatformForUrl(url);
    if (platform == null) {
      throw Exception('Unsupported video platform');
    }

    return await _platformInterface.getVideoInfo(url, platform.platformName);
  }

  /// Cancel current download
  Future<void> cancelDownload(String url) async {
    final platform = getPlatformForUrl(url);
    if (platform == null) {
      throw Exception('Unsupported video platform');
    }

    await _platformInterface.cancelDownload(platform.platformName);
  }
}
