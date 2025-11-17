import '../../base/video_platform_base.dart';

class TikTokPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'tiktok';

  @override
  bool isValidUrl(String url) {
    return url.contains('tiktok.com') || url.contains('tiktok.com');
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('TikTok download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('TikTok video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('TikTok cancel download not implemented');
  }
}
