import '../../base/video_platform_base.dart';

class GenericPlatform extends VideoPlatformBase {
  @override
  String get platformName => 'generic';

  @override
  bool isValidUrl(String url) {
    // For generic platform, we accept any URL
    return true;
  }

  @override
  Future<String> downloadVideo(
    String url,
    Function(double progress, String status) onProgress,
  ) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Generic download not implemented');
  }

  @override
  Future<Map<String, dynamic>> getVideoInfo(String url) async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Generic video info not implemented');
  }

  @override
  Future<void> cancelDownload() async {
    // Implementation would use the macOS platform interface
    throw UnimplementedError('Generic cancel download not implemented');
  }
}
