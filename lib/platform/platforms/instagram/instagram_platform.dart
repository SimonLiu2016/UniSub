import '../../base/video_platform_base.dart';

class InstagramPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'instagram';

  @override
  bool isValidUrl(String url) {
    return url.contains('instagram.com');
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Instagram download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Instagram video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Instagram cancel download not implemented');
  }
}
