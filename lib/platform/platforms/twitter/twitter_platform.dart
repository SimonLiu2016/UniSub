import '../../base/video_platform_base.dart';

class TwitterPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'twitter';

  @override
  bool isValidUrl(String url) {
    return url.contains('twitter.com') || url.contains('x.com');
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Twitter download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Twitter video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Twitter cancel download not implemented');
  }
}
