import '../../base/video_platform_base.dart';

class FacebookPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'facebook';

  @override
  bool isValidUrl(String url) {
    return url.contains('facebook.com') || url.contains('fb.com');
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Facebook download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Facebook video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Facebook cancel download not implemented');
  }
}
